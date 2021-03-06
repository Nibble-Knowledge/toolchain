#!/bin/bash

RETCODE=0

if [ "$#" -lt 2 ]
then
	echo "Usage: $0 INPUT_BASIC OUTPUT_FILE"
	exit 1	
fi

./update.sh
./cute-basic/CB2Macro/CB2M.PY "$1" "out-macro"
RETCODE=$?
if [ $RETCODE -ne 0 ]
then
	echo "Incorrect CUTE BASIC:"
	echo ""
	cat $1
	exit 1
fi
./macro-assembler/NKMacroASM.py "out-macro" "out-lrasm"
RETCODE=$?
if [ $RETCODE -ne 0 ]
then
	echo "Incorrect macro assembly:"
	echo ""
	cat out-macro
	exit 1
fi
./label-replacer/lr4.py label-replacer/examples/deffiles/standard.def "out-lrasm" "out-llasm"
RETCODE=$?
if [ $RETCODE -ne 0 ]
then
	echo "Incorrect assembly:" 
	echo ""
	cat out-lrasm
	exit 1
fi
./cpu-assembler/as4 "out-llasm" "$2"
RETCODE=$?
if [ $RETCODE -ne 0 ]
then
	if [ $RETCODE -gt 128 ]
	then
		cd cpu-assembler
		make clean
		make debug
		cd ..
		gdb --args ./cpu-assembler/as4 "out-llasm" "$2"
		exit
	fi
	echo "Incorrect assembly:" 
	echo ""
	cat out-llasm
	exit 1
fi

