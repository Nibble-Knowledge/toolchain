#!/bin/bash


if [ "$1" = "refresh" -o "$1" = "clean" ]
then
	rm -rf cpu-assembler label-replacer macro-assembler asm-library cute-basic out-*
	if [ "$1" = "clean" ]
	then
		exit 0
	fi
fi

python -V > /dev/null 2>&1 || { echo "Please install Python before using this toolchain!"; exit 1; }
git --version > /dev/null 2>&1 || { echo "Please install Git before using this toolchain!"; exit 1; }
gcc --version > /dev/null 2>&1 || { echo "Please install GCC before using this toolchain!"; exit 1; }
make --version > /dev/null 2>&1 || { echo "Please install Make before using this toolchain!"; exit 1; }

if [ ! -d cpu-assembler ]
then
	git clone git://github.com/nibble-knowledge/cpu-assembler || { echo "Could not retrieve low level assembler!"; exit 1; }
fi
if [ ! -d label-replacer ]
then
	git clone git://github.com/nibble-knowledge/label-replacer || { echo "Could not retrieve label replacer!"; exit 1; }
fi
if [ ! -d macro-assembler ]
then
	git clone git://github.com/nibble-knowledge/macro-assembler || { echo "Could not retrieve macro assembler!"; exit 1; }

fi
if [ ! -d asm-library ]
then
	git clone git://github.com/nibble-knowledge/asm-library || { echo "Could not retrieve assembly library!"; exit 1; }

fi
if [ ! -d cute-basic ]
then
	git clone git://github.com/nibble-knowledge/cute-basic || { echo "Could not retrieve Cute BASIC compiler!"; exit 1; }

fi

cd cpu-assembler
if [ ! -z "$(git fetch --dry-run)" ]
then
	make clean
	git pull
fi
make
cd ..
cd label-replacer
if [ ! -z "$(git fetch --dry-run)" ]
then
	make clean
	git pull
fi
make
cd ..
cd macro-assembler
if [ ! -z "$(git fetch --dry-run)" ]
then
	git pull
fi
cd ..
cd asm-library
if [ ! -z "$(git fetch --dry-run)" ]
then
	git pull
fi
cd ..
cd cute-basic
if [ ! -z "$(git fetch --dry-run)" ]
then
	git pull
fi
cd ..

