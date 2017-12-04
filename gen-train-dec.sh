#!/bin/bash
# generic script to launch training via qsubmit
# $1: problem
export PROBLEM=$1
export SRC_TEST=$2
export TGT_TEST=$3
export TRAIN_ITER=$4

echo solving problem $PROBLEM

export MODEL=transformer
#	--hparams_set=transformer_big_single_gpu \ # protože mi to dává lepší výsledky než base už po cca 20 hodinách trénování
export HPARAMS=transformer_big_single_gpu

export DIR=$PWD
export DATA_DIR=$DIR/t2t_data/$PROBLEM/data_dir
export TMP_DIR=$DIR/t2t_source_data
export TRAIN_DIR=$DIR/t2t_data/$PROBLEM/train_dir/$MODEL-$HPARAMS$TRAIN_ITER


mkdir -p $DATA_DIR $TMP_DIR $TRAIN_DIR

./link_data.sh

source p3-t2t-gpu-fork/bin/activate

GEN_STAMP=$DATA_DIR/is_generated
# Generate data
if [ ! -f $GEN_STAMP ]; then
	echo generating input data...
	t2t-datagen \
		--data_dir=$DATA_DIR \
		--tmp_dir=$TMP_DIR \
		--problem=$PROBLEM \
		--random_seed 123 \
		--t2t_usr_dir=t2t_usr &&
	touch $GEN_STAMP
else
	echo generating input data skipped...
fi

if [ ! -e $DATA_DIR/test.de ] || [ ! -e $DATA_DIR/test.cs ]; then
	echo linking src and tgt test
#	rm -f $DATA_DIR/test.de $DATA_DIR/test.cs
	ln -rs $TMP_DIR/$SRC_TEST $DATA_DIR/test.de
	ln -rs $TMP_DIR/$TGT_TEST $DATA_DIR/test.cs
fi

echo training...

if [ -z "$TRAIN_ITER" ]; then
	WM_STEPS=30000
else
	WM_STEPS=60000
fi

# Train
# *  If you run out of memory, add --hparams='batch_size=1024'.
t2t-trainer \
	--data_dir=$DATA_DIR \
	--problems=$PROBLEM \
	--model=$MODEL \
	--hparams_set=$HPARAMS \
	--output_dir=$TRAIN_DIR \
	--t2t_usr_dir=t2t_usr \
	--train_steps=1000000 \
	--hparams='batch_size=1500,learning_rate_warmup_steps='$WM_STEPS \
	--save_checkpoints_secs=3600 \
	--keep_checkpoint_max=32 \
	--eval_steps=68 
 #,shared_embeddings_and_softmax_wights=0
## protože 250k ne vždy stačí a zabít to můžu kdykoli
#	--train_steps=1000000 \
#	--hparams='batch_size=1500' \ # protože když tam nechám vyšší hodnotu, tak mi to spadne na OOM.
##		#   samozřejmě s base modelem lze nechat vyšší a obecně je dobré batch_size nastavit na nejvyšší hodnotu,
##		#   na které to nepadá a pak pro jistotu ještě trochu snížit
#	--save_checkpoints_secs=3600 \ # protože mi stačí ukládat checkpointy jen jednou za hodinu
#	--keep_checkpoint_max=32 \ # na konci chci zprůměrovat checkpointy a občas mi jako nejlepší vyšlo 8, jindy 16 a jindy i 32, \	#   tak je dobré jich mít uložených aspoň tolik. Je-li místo na disku, tak lze nechat i víc.
##Když spouštím trénování na 1 GPU, tak ještě přidávám
#	 --eval_steps=68 # aby se evaluovalo na celém dev setu
##	   Číslo 68 platí pro batch_size=1500, translate_ende_wmt32k a defaultní dev set wmt13.
##	   Obecně je dobré tam nastavit vysoké číslo, pak se kouknout, u které batche to vypisuje warning
##	   a příslušně snížit.
echo training done
echo decoding

./decode.sh

echo decoding done

