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



STAMP=bleu-is-running
LOG=bleu-loop.log


#: > $LOG
#: > $LOG
for i in `seq 80 3840`; do
	echo `date` iteration $i >> $LOG
	if [ ! -f $STAMP ]; then
		echo `date` q-submitting job >> $LOG
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
		# hodně jobů
		echo "$JOBS" | while read problem iter rest; do
			touch $STAMP
			echo -n "qsubmit -jobname=b$i-$problem -gpus=1 -gpumem=11G -logdir=bleu-logs "
			echo -n "\" echo \`date\` qsjob-$i running bleu for $problem >> $LOG ;"
			echo -n "./bleu.sh $problem $iter >&1 > bleu-logs/bleu-$problem""-$i"".out ;"
			echo -n "echo \`date\` qsjob-$i: t2t-bleu for $problem finished >> $LOG ;"
			if echo "$rest" | grep 'stamp' > /dev/null; then
				echo " rm -f $STAMP ; \""
			else
				echo "\""
			fi
			echo
		# bash
		done | bash
	else
		echo `date` skipping job q-submitting >> $LOG

	fi
#	sleep 
	sleep 2400 # 40 minutes
done


