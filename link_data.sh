#!/bin/bash
TMP_DIR=t2t_source_data
# copy data
if [ ! -f input_data.linked ]; then
	echo linking input data...
	cd $TMP_DIR
	ln -rs /net/work/people/machacek/morf-seg-nmt/de-cs/* .
	cd ..
	touch input_data.linked
else
	echo linking input data skipped
fi

# copy data
if [ ! -f zz_input_data.linked ]; then
	echo linking zz-input data...
	cd $TMP_DIR
	for i in /net/work/people/machacek/morf-seg-nmt/de-cs-zigzag/*; do
		ln -rs $i zz.`basename $i`
	done
	cd ..
	touch zz_input_data.linked
else
	echo linking zz-input data skipped
fi

# copy data
if [ ! -f aa_input_data.linked ]; then
	echo linking aa-input data...
	cd $TMP_DIR
	for i in /net/work/people/machacek/morf-seg-nmt/de-cs-atat/*; do
		ln -rs $i aa.`basename $i`
	done
	cd ..
	touch aa_input_data.linked
else
	echo linking aa-input data skipped
fi

# copy data
if [ ! -f aa_input_data.linked ]; then
	echo linking aa-input data...
	cd $TMP_DIR
	for i in /net/work/people/machacek/morf-seg-nmt/de-cs-atat/*; do
		ln -rs $i aa.`basename $i`
	done
	cd ..
	touch aa_input_data.linked
else
	echo linking aa-input data skipped
fi


# copy data
if [ ! -f en-cs_input_data.linked ]; then
	echo linking en-cs-input data...
	cd $TMP_DIR
	for i in /net/work/people/machacek/morf-seg-nmt/en-cs/*; do
		n=`basename $i`
		ln -rs $i ${n/./.en-cs.}
	done
	cd ..
	touch en-cs_input_data.linked
else
	echo linking en-cs-input data skipped
fi
