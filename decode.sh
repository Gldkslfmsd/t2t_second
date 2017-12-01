#!/bin/bash
#
## Decode

PROBLEM=$1

BEAM_SIZE=4
ALPHA=0.6

export MODEL=transformer
export HPARAMS=transformer_big_single_gpu
export DIR=$PWD
export DATA_DIR=$DIR/t2t_data/$PROBLEM/data_dir
export TMP_DIR=$DIR/t2t_source_data
export TRAIN_DIR=$DIR/t2t_data/$PROBLEM/train_dir/$MODEL-$HPARAMS

DECODE_FILE=$DATA_DIR/test.de
REFERENCE=$DATA_DIR/test.cs


source p3-t2t-gpu-fork/bin/activate

echo `date` decoding $PROBLEM
t2t-decoder \
  --data_dir=$DATA_DIR \
  --problems=$PROBLEM \
  --model=$MODEL \
  --hparams_set=$HPARAMS \
  --output_dir=$TRAIN_DIR \
  --decode_hparams="beam_size=$BEAM_SIZE,alpha=$ALPHA" \
  --decode_from_file=$DECODE_FILE \
  --t2t_usr_dir=t2t_usr
D=$?
echo `date` decoding finished

OUT=$DECODE_FILE.$MODEL.$HPARAMS.$PROBLEM.beam$BEAM_SIZE.alpha$ALPHA.decodes
cp $OUT $OUTPUT_DIR/test.cs.$PROBLEM.`date -u +"%Y-%m-%dT%H:%M:%SZ"`

perl multi-bleu.perl $REF < $OUT

exit $D
