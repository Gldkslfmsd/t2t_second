#!/bin/bash


qsub_launch() {
	echo qsubmit -jobname=$2 -gpus=1 -gpumem=11G \"./gen-train-dec.sh $1 $3 $4 $5\"
#	./gen-train-dec.sh $1 $3 $4 $5
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

# Mon Dec 18 16:57:39 CET 2017
# tmorf+subwords, der+subwords
JOBS="translate_decs_tmorfsub_dersub tms-ders-g test.de.tmorf test.cs.der gen_only
translate_decs_tmorfsub_tmorfsub tms-tms-g test.de.tmorf test.cs.tmorf gen_only"


JOBS="translate_decs_tmorfsub_tmorfsub tms-tms-g test.de.tmorf test.cs.tmorf 
translate_decs_tmorfsub_dersub tms-ders-g test.de.tmorf test.cs.der 
translate_decs_sub_dersub d-sd-g test.de.tok test.cs.der 
translate_decs_sub_tmorfsub d-st-g test.de.tok test.cs.tmorf 
translate_decs_tmorfsub_sub d-ts-g test.de.tmorf test.cs.tok"

JOBS="translate_encs_sub_dersub e-sd-g test.en.tok test.cs.der"

# znovu spouštím ty, co spadly

JOBS="translate_decs_tmorfsub_tmorfsub d-tt-t test.de.tmorf test.cs.tmorf
translate_decs_tmorfsub_sub d-ts-g test.de.tmorf test.cs.tok
translate_encs_sub_dersub e-sd-g test.en.tok test.cs.der"

# po uvolnění místa

JOBS="translate_encs_sub_dersub e-sd-g test.en.tok test.cs.der
translate_decs_tmorfsub_sub d-ts-g test.de.tmorf test.cs.tok"

JOBS="translate_decs_tmorfsub_tmorfsub d-tt-t test.de.tmorf test.cs.tmorf"


# 
JOBS="translate_encs_sub_dersub e-sd-g test.en.tok test.cs.der
translate_decs_sub_tmorfsub d-st-g test.de.tok test.cs.tmorf"


# Sat Dec 23 16:40:01 CET 2017
# spočítal jsem detok

JOBS="translate_decs_bpe50kaaderzz de-derzz-t aa.test.de.bpe50k  zz.test.cs.der+bpe37k
translate_decs_bpe50kaader de-der-t aa.test.de.bpe50k  test.cs.der+bpe54k
translate_decs_tmorfsub_sub d-ts-g test.de.tmorf test.cs.tok -2
translate_decs_sub_dersub d-sd-g test.de.tok test.cs.der"

JOBS="translate_encs_sub_dersub e-sd-g test.en.tok test.cs.der"

#JOBS="translate_decs_tmorfsub_sub d-ts-g test.de.tmorf test.cs.tok -2"

#JOBS="translate_decs_tmorfsub_tmorfsub d-tt-t test.de.tmorf test.cs.tmorf"

#JOBS="translate_decs_bpe_und bpe_und test.de.bpe_und50k test.cs.bpe_und50k"
JOBS="translate_decs_bpe_und bpe_und_gen test.de.und_bpe50k test.cs.und_bpe50k"

JOBS="translate_decs_bpe_und bpe_und2 test.de.und_bpe50k test.cs.und_bpe50k -2"

JOBS="translate_decs_bpe_shrd bpe_shrd test.de.shrd_bpe100k test.cs.shrd_bpe100k
translate_decs_bpe_shrd_und bpe_s_und test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k"

JOBS="translate_decs_bpe_und bpe_und2 test.de.und_bpe50k test.cs.und_bpe50k -2"

JOBS="translate_decs_bpe_shrd bpe_shrd2 test.de.shrd_bpe100k test.cs.shrd_bpe100k -2"

JOBS="translate_decs_bpe_shrd_und bpe_s_un2 test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k -2"
#translate_decs_bpe_shrd_und bpe_s_und test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k"

JOBS="translate_decs_sub_dersub_fix gen-sds-fix test.de.tok test.cs.der-fix"

# doplňuju bpe def zz

JOBS="translate_decs_bpedefzz bpedefzz test.de.tok zz.test.cs.bpe"

JOBS="translate_decs_bpeaadef bpeaadef aa.test.de.bpe test.cs.bpe50k"

JOBS="translate_decs_sub_tmorfsub_fix gen-sts-fix test.de.tok test.cs.tmorf-fix
translate_decs_tmorfsub_sub_fix gen-tss-fix test.de.tmorf-fix test.cs.tok"

JOBS="translate_decs_bpeaadef bpeaadef2 aa.test.de.bpe test.cs.bpe50k -2"
JOBS="translate_decs_bpedefzz bpedefzz test.de.tok zz.test.cs.bpe -2"

JOBS="translate_decs_tmorfsub_tmorfsub_fix tsts-fix test.de.tmorf-fix test.cs.tmorf-fix
translate_decs_tmorfsub_dersub_fix tsds-fix test.de.tmorf-fix test.cs.der-fix"

JOBS="translate_decs_tmorfsub_sub_fix tss-fix2 test.de.tmorf-fix test.cs.tok -2
translate_decs_bpeaadef bpeaadef aa.test.de.bpe test.cs.bpe50k
translate_decs_sub_tmorfsub_fix gen-sts-fix test.de.tok test.cs.tmorf-fix
translate_decs_tmorfsub_sub_fix gen-tss-fix test.de.tmorf-fix test.cs.tok
translate_decs_bpeaadef bpeaadef2 aa.test.de.bpe test.cs.bpe50k -2"

JOBS="translate_decs_bpe_und_endfix  bpeundendfix test.de.und_bpe_endfix50k test.cs.und_bpe_endfix50k
translate_decs_bpe_und_endfix  b2peundendfix test.de.und_bpe_endfix50k test.cs.und_bpe_endfix50k -2"


JOBS="translate_decs_bpe_und_endfix  bpeundendfix test.de.und_bpe_endfix50k test.cs.und_bpe_endfix50k
translate_decs_bpe_und_endfix  b2peundendfix test.de.und_bpe_endfix50k test.cs.und_bpe_endfix50k -2"


JOBS="translate_decs_bpe_shrd_und_endfix shrdundef test.de.shrd_und_bpe_endfix100k test.cs.shrd_und_bpe_endfix100k"

JOBS="translate_decs_bpe_und_endfix  bpeundendfix test.de.und_bpe_endfix50k test.cs.und_bpe_endfix50k"

JOBS="translate_decs_bpe_und_endfix  b2peundendfix test.de.und_bpe_endfix50k test.cs.und_bpe_endfix50k -2"

JOBS="translate_decs_bpe_shrd_und_endfix s2hrdundef test.de.shrd_und_bpe_endfix100k test.cs.shrd_und_bpe_endfix100k -2"

JOBS="translate_decs_bpe_und_endfix  b2peundendfix test.de.und_bpe_endfix50k test.cs.und_bpe_endfix50k -2"

JOBS="translate_decs_bpe_shrd_und_endfix s2hrdundef test.de.shrd_und_bpe_endfix100k test.cs.shrd_und_bpe_endfix100k -2"

JOBS="translate_decs_bpe_shrd_und_again shrdundag test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k
translate_decs_bpe_und_again undagain test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k"

JOBS="translate_decs_bpe_shrd_und_again sh2rdundag test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k -2
translate_decs_bpe_und_again un2dagain test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k -2"

JOBS="translate_decs_bpe_shrd_und_again shrdundag test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k"

JOBS="translate_decs_bpe_shrd_und_again sh2rdundag test.de.shrd_und_bpe100k test.cs.shrd_und_bpe100k -2"

#: > running_jobs
echo "$JOBS" | while read prob name src tgt iter; do
	if echo $iter | grep 'gen_only' >/dev/null; then
		qsub_launch_cpu $prob $name $src $tgt $iter
	else
		echo $prob $iter >> running_jobs
		sort -u running_jobs > tmp
		mv tmp running_jobs
		qsub_launch $prob $name $src $tgt $iter
	fi
done


#qsub_launch algorithmic_reverse_binary40_test jn


