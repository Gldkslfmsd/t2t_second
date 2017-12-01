#!/bin/bash
echo qsubmit -jobname=dec-loop -queue=gpu.q -gpus=0 \""for i in \\\`seq 1 100\\\`; do sleep 7200; date; ./decode_all.sh | bash; done"\"
