#!/bin/bash


qsub_launch() {
	echo qsubmit -jobname=$2 -gpus=1 -gpumem=11G \"./gen-train-dec.sh $1 $3 $4 $5\"
#	./gen-train-dec.sh $1 $3 $4 $5
}

#export PROBLEM=translate_decs_subwords
#PROBLEM=algorithmic_reverse_binary40_test
#PROBLEM=translate_decs_subwords

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




JOBS="translate_decs_bpe50k _bpe50k
translate_decs_bpe50kaa _bpe50kaa
translate_decs_pmorfaa _pmorfaa
translate_decs_pmorfzz _pmorfzz"

JOBS="translate_decs_aazzpmorf _pmorfaazz
translate_decs_aazzbpe50k _bpe50kaazz"

JOBS="translate_decs_bpe50kzz bpe50kzz"

# 3. vlna spouštění
# Thu Nov 23 22:28:06 CET 2017
JOBS="translate_decs_bpeaa !bpeaa"

JOBS="translate_decs_bpezz !bpezz
translate_decs_bpeaazz !bpeaazz"

# 4. vlna spouštění
# Wed Nov 29 15:54:05 CET 2017

JOBS="translate_decs_subwords subw test.de.tok  test.cs.tok
translate_decs_bpe bpe test.de.bpe50k  test.cs.bpe50k
translate_decs_bpezz bpezz zz.test.de.bpe  zz.test.cs.bpe
translate_decs_bpeaa bpeaa aa.test.de.bpe  aa.test.cs.bpe"

# 5. vlna
# Fri Dec  1 13:47:49 CET 2017
JOBS="translate_encs_subwords encssubw test.en-cs.en.tok test.en-cs.cs.tok
translate_encs_bpe encsbpe test.en-cs.en.bpe50k test.en-cs.cs.bpe50k"

JOBS="translate_decs_bpe bpe-2 test.de.bpe50k  test.cs.bpe50k -2
translate_decs_bpeaa bpeaa-2 aa.test.de.bpe  aa.test.cs.bpe -2"

# opraveno
JOBS="translate_encs_bpe encsbpe test.en-cs.en.bpe50k test.en-cs.cs.bpe50k"

# 6. vlna
# Mon Dec  4 14:24:59 CET 2017
# oprava save_checkpoints_secs

JOBS="translate_encs_bpe encsbpe test.en-cs.en.bpe50k test.en-cs.cs.bpe50k
translate_decs_subwords subw test.de.tok  test.cs.tok
translate_decs_bpezz bpezz zz.test.de.bpe  zz.test.cs.bpe
translate_decs_bpe bpe-2 test.de.bpe50k  test.cs.bpe50k -2
translate_decs_bpeaa bpeaa-2 aa.test.de.bpe  aa.test.cs.bpe -2
translate_encs_subwords encssubw test.en-cs.en.tok test.en-cs.cs.tok"

JOBS="translate_decs_subwords subw test.de.tok  test.cs.tok"
#translate_encs_bpe encsbpe test.en-cs.en.bpe50k test.en-cs.cs.bpe50k"






echo "$JOBS" | while read prob name src tgt iter; do
	qsub_launch $prob $name $src $tgt $iter
done


#qsub_launch algorithmic_reverse_binary40_test jn


