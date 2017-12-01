#!/bin/bash

PROBLEM_SRC_TGT="translate_decs_aazzbpe50k aa.test.de.bpe50k zz.test.cs.bpe50k
translate_decs_aazzpmorf aa.test.de.pmorf zz.test.cs.pmorf
translate_decs_bpe50k test.de.bpe50k  test.cs.bpe50k
translate_decs_bpe50kaa aa.test.de.bpe50k  aa.test.cs.bpe50k 
translate_decs_bpe50kzz zz.test.de.bpe50k  zz.test.cs.bpe50k 
translate_decs_bpeaa aa.test.de.bpe  aa.test.cs.bpe
translate_decs_bpeaazz aa.test.de.bpe  zz.test.cs.bpe
translate_decs_bpezz zz.test.de.bpe  zz.test.cs.bpe
translate_decs_pmorfaa aa.test.de.pmorf  aa.test.cs.pmorf
translate_decs_pmorfzz zz.test.de.pmorf  zz.test.cs.pmorf
translate_decs_subwords test.de.tok  test.cs.tok"

#NO="translate_decs_bpe30k3 test.de.bpe30k  test.cs.bpe30k"

export MODEL=transformer
export HPARAMS=transformer_big_single_gpu
export DIR=$PWD
export DATA_DIR=$DIR/t2t_data/$PROBLEM/data_dir
export TMP_DIR=$DIR/t2t_source_data
export TRAIN_DIR=$DIR/t2t_data/$PROBLEM/train_dir/$MODEL-$HPARAMS

dec_qs() {
	PROBLEM=$1
	echo qsubmit -jobname=dec-${PROBLEM/translate_decs_/} -gpus=1 -gpumem=11G \""./decode.sh $PROBLEM"\"
}

echo -n "qsubmit -jobname=decoding-all -gpus=1 -gpumem=11G \""

echo "$PROBLEM_SRC_TGT" | while read PROBLEM src tgt; do
	DATA_DIR=$DIR/t2t_data/$PROBLEM/data_dir
	TRAIN_DIR=$DIR/t2t_data/$PROBLEM/train_dir/$MODEL-$HPARAMS
	if [ ! -e $DATA_DIR/test.de ] && [ ! -e $DATA_DIR/test.cs ]; then
		ln -rs $TMP_DIR/$src $DATA_DIR/test.de
		ln -rs $TMP_DIR/$tgt $DATA_DIR/test.cs
	fi
#	dec_qs $PROBLEM
	echo -n " ./decode.sh $PROBLEM ; echo \`date\` $PROBLEM finished with status \$? >> decoding.log; "
	
done

echo -n "\""


