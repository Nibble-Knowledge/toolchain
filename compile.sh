#!/bin/bash

if [ "$#" -lt 2 ]
then
	echo "Usage: $0 INPUT_BASIC OUTPUT_FILE"
	exit 1	
fi

./update.sh
./cute-basic/CB2Macro/CB2M.PY "$1" "out-macro" || { rm out-macro out-lrasm out-llasm; exit 1; }
./macro-assembler/NKMacroASM.py "out-macro" "out-lrasm" || { rm out-macro out-lrasm out-llasm; exit 1; }
./label-replacer/lr4.exe label-replacer/examples/deffiles/standard.def "out-lrasm" "out-llasm" || { rm out-macro out-lrasm out-llasm; exit 1; }
./cpu-assembler/as4.exe "out-llasm" "$2" || { rm out-macro out-lrasm out-llasm; exit 1; }
rm out-macro out-lrasm out-llasm
