#!/bin/bash
source p3-t2t-gpu-fork/bin/activate
PROBLEM=$1
t2t-bleu \
	--model_dir=t2t_data/$PROBLEM""/train_dir/transformer-transformer_big_single_gpu \
	--data_dir=t2t_data/$PROBLEM/data_dir \
	--translations_dir=t2t_decodedfiles \
	--hparams_set=transformer_big_single_gpu \
	--source=t2t_data/$PROBLEM/data_dir/test.de \
	--reference=t2t_data/$PROBLEM/data_dir/test.cs \
	--t2t_usr_dir=t2t_usr \
	--postprocess=true \
	--problems=$PROBLEM
