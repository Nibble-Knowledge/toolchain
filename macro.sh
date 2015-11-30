#!/bin/bash

RETCODE=0

if [ "$#" -lt 2 ]
then
	echo "Usage: $0 INPUT_MACRO OUTPUT_FILE"
	exit 1	
fi

./update.sh
./macro-assembler/NKMacroASM.py "$1" "out-lrasm"
RETCODE=$?
if [ $RETCODE -ne 0 ]
then
	echo "Incorrect macro assembly:"
	echo ""
	cat out-macro
	exit 1
fi
./label-replacer/lr4 label-replacer/examples/deffiles/standard.def "out-lrasm" "out-llasm"
RETCODE=$?
if [ $RETCODE -ne 0 ]
then
	if [ $RETCODE -gt 128 ]
	then
		cd label-replacer
		make clean
		make debug
		cd ..
		gdb --args ./label-replacer/lr4 label-replacer/examples/deffiles/standard.def "out-lrasm" "out-llasm"
		exit
	fi
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

