#!/bin/bash

if [ ! -z "$1" ]; then
	echo qsubmit -jobname=bleu-loop "\"./$0\""
	exit
fi

JOBS="translate_decs_subwords subw test.de.tok  test.cs.tok
translate_decs_bpe bpe test.de.bpe50k  test.cs.bpe50k
translate_decs_bpezz bpezz zz.test.de.bpe  zz.test.cs.bpe
translate_decs_bpeaa bpeaa aa.test.de.bpe  aa.test.cs.bpe stamp"

JOBS="translate_encs_subwords 
translate_encs_bpe 
translate_decs_bpe -2
translate_decs_bpezz 
translate_decs_bpeaa -2
translate_decs_subwords \"\" stamp-subw 
"

JOBS="translate_encs_bpe
translate_decs_subwords 
translate_decs_bpezz 
translate_decs_bpe -2 
translate_decs_bpeaa -2 
translate_encs_subwords
translate_decs_subwords100k
translate_decs_subwords100k -2"


# po zabití 6. vlny

JOBS="translate_encs_bpe
translate_decs_subwords100k -2 
translate_decs_subwords100k
translate_encs_subwords100k -2 
translate_encs_subwords100k"

JOBS="translate_encs_subwords100k_fbb100m
translate_decs_bpeaazz
translate_encs_subwords100k_fbb1000m
translate_decs_bpezzaa -2
translate_decs_subwords100k_fbb100m
translate_decs_subwords100k_fbb100m -2
translate_decs_bpe50kaaderzz
translate_decs_bpe50kaader
translate_decs_bpe50kaaderzz -2
translate_decs_bpe50kaader -2"

JOBS="-translate_encs_subwords100k_fbb100m
-translate_decs_bpeaazz
-translate_encs_subwords100k_fbb1000m
-translate_decs_bpezzaa -2
translate_decs_subwords100k_fbb100m
translate_decs_subwords100k_fbb100m -2
translate_decs_bpe50kaaderzz
translate_decs_bpe50kaader
translate_decs_bpe50kaaderzz -2
translate_decs_bpe50kaader -2"

# TODO: jen ty, co fakt existují

JOBS="translate_decs_tmorfsub_tmorfsub
translate_decs_tmorfsub_dersub
translate_decs_sub_dersub 
translate_decs_sub_tmorfsub 
translate_decs_tmorfsub_sub
translate_decs_tmorfsub_tmorfsub -2
translate_decs_tmorfsub_dersub -2
translate_decs_sub_dersub -2
translate_decs_sub_tmorfsub -2
translate_decs_tmorfsub_sub -2
translate_decs_subwords100k_fbb100m
translate_decs_subwords100k_fbb100m -2
translate_decs_bpe50kaaderzz
translate_decs_bpe50kaader
translate_decs_bpe50kaaderzz -2
translate_decs_bpe50kaader -2"



JOBS="translate_decs_tmorfsub_tmorfsub
translate_decs_tmorfsub_sub
translate_decs_sub_dersub
translate_decs_tmorfsub_dersub
translate_decs_sub_tmorfsub 
translate_encs_sub_dersub"


JOBS="`cat running_jobs`"


# exits with return code 0 (that means TRUE in bash), if file $1 is newer than $2 minutes
# otherwise it returns other code
is_newer_than() { # $1: file $2: how many minutes
	find $1 -mmin -$2 | grep . > /dev/null 2>/dev/null
}

LOG=bleu-loop.log

STAMP_DIR=stamp_dir


mkdir -p $STAMP_DIR

: > $LOG
#: > $LOG
#for i in `seq 80 3840`; do
while true; do
	#echo `date` iteration $i >> $LOG
	#echo `date` q-submitting job >> $LOG
	# hodně jobů
	cat running_jobs | while read problem iter rest; do
		running=$STAMP_DIR/stamp-$problem""$iter"".running
		finished=$STAMP_DIR/stamp-$problem""$iter"".finished
		if [ ! -f "$running" ] && ! is_newer_than $finished 60; then
			echo "`date` qsubmitting ./bleu.sh $problem $iter >&1 > bleu-logs/bleu-$problem""-$i"".out" >> $LOG
			touch $running
			echo -n "qsubmit -jobname=b$i-$problem -gpus=1 -gpumem=11G -logdir=bleu-logs "
			echo -n "\""
			echo -n " echo \`date\` qsjob: running bleu for $problem >> $LOG ;"
			echo -n "./bleu.sh $problem $iter >&1 > bleu-logs/bleu-$problem""-$i"".out ;"
			echo -n "echo \`date\` qsjob: t2t-bleu for $problem finished >> $LOG ;"
			echo " rm -f $running ; touch $finished ; \""
		fi
	# bash
	done | bash
	#echo `date` skipping job q-submitting >> $LOG
	sleep 10
done &

while true; do
	./refix-bleus.sh 
	./refix-bleus.sh | bash
	./bleu-detok.sh
	./bleu-detok.sh | bash
	sleep 1800
done &

wait


		# všechno postupně v jednom jobu
#		{
#			echo -n "qsubmit -jobname=bleu-$i -gpus=1 -gpumem=11G -logdir=bleu-logs "
#			echo -n "\" touch $STAMP;"
#			echo "$JOBS" | while read problem _; do
#				echo -n "echo \`date\` qsjob running bleu for $problem >> $LOG ;"
#				echo -n "./bleu.sh $problem 2>&1 > bleu-logs/bleu-$problem""-$i"".out ;"
#				echo -n "echo \`date\` qsjob: t2t-bleu for $problem finished >> $LOG ;"
#			done
#			echo -n "rm -f $STAMP ; \""
#		} > /dev/null

