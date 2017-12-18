#!/bin/bash


qsub_launch() {
#	echo qsubmit -jobname=$2 -gpus=1 -gpumem=11G \"./gen-train-dec.sh $1 $3 $4 $5\"
	./gen-train-dec.sh $1 $3 $4 $5
}

qsub_launch12() {
	echo qsubmit -jobname=$2 -gpus=1 -gpumem=12G \"./gen-train-dec.sh $1 $3 $4 $5\"
#	./gen-train-dec.sh $1 $3 $4 $5
}


qsub_launch_cpu() {
	echo qsubmit -jobname=$2 \"./gen-train-dec.sh $1 $3 $4 $5\"
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

#JOBS="translate_decs_subwords subw test.de.tok  test.cs.tok"
JOBS="translate_encs_bpe encsbpe test.en-cs.en.bpe50k test.en-cs.cs.bpe50k"


# 7.vlna
# pokus o opravu subwords -> subwords100k
# Tue Dec  5 10:43:37 CET 2017
JOBS="translate_decs_subwords100k d-subw100 test.de.tok  test.cs.tok gen_only
translate_encs_subwords100k e-subw100 test.en.tok  test.cs.tok gen_only"

JOBS="translate_decs_subwords100k dsubw100 test.de.tok  test.cs.tok
translate_decs_subwords100k dsub100-2 test.de.tok  test.cs.tok -2"

JOBS="translate_encs_subwords100k e-subw100 test.en.tok  test.cs.tok
translate_encs_subwords100k e-subw100-2 test.en.tok  test.cs.tok -2
translate_decs_subwords100k dsubw100 test.de.tok  test.cs.tok"


# Mon Dec 11 09:43:13 CET 2017
# zvýšíme file_byte_budget

JOBS="translate_encs_subwords100k_fbb1000m e-1000M test.en.tok  test.cs.tok gen_only
translate_encs_subwords100k_fbb100m e-100M test.en.tok  test.cs.tok gen_only"

JOBS="translate_encs_subwords100k_fbb100m e-100Mt test.en.tok  test.cs.tok"

JOBS="translate_encs_subwords97k_fbb100m e-97k100M test.en.tok  test.cs.tok gen_only"

JOBS="translate_encs_subwords100k_fbb1000m e-1000M test.en.tok  test.cs.tok"

# trénují se
JOBS="translate_decs_bpeaazz bpeaazz-g aa.test.de.bpe  zz.test.cs.bpe
translate_decs_bpezzaa bpezzaa-g zz.test.de.bpe  aa.test.cs.bpe"

# spustit, až se dogeneruje
JOBS="translate_decs_subwords100k_fbb100m d-100M-g test.de.tok  test.cs.tok"

JOBS="translate_encs_subwords100k_fbb1000m e-1000M test.en.tok  test.cs.tok"

JOBS="translate_decs_subwords100k_fbb100m d-100M-g test.de.tok  test.cs.tok"

JOBS="translate_decs_bpeaazz bpeaazz-t aa.test.de.bpe  zz.test.cs.bpe
translate_decs_bpezzaa bpezzaa-t zz.test.de.bpe  aa.test.cs.bpe -2"

JOBS="translate_decs_subwords100k_fbb100m d-100M-gt test.de.tok  test.cs.tok -2"

# derinet a spol.
JOBS="translate_decs_bpe50kaaderzz de-derzz-t aa.test.de.bpe50k  zz.test.cs.der+bpe37k
translate_decs_bpe50kaader de-der-t aa.test.de.bpe50k  test.cs.der+bpe54k"

#translate_decs_bpe50kaaderzz de-derzz-t2 aa.test.de.tok  zz.test.cs.tok -2
#translate_decs_bpe50kaader de-der-t2 aa.test.de.tok  test.cs.tok -2"


echo "$JOBS" | while read prob name src tgt iter; do
	qsub_launch $prob $name $src $tgt $iter
done


#qsub_launch algorithmic_reverse_binary40_test jn


