#!/bin/bash

#################################################################
# Modify audio-snippets by stretching / compressing by a factor #
#################################################################

# Audio-Snippet-File to be modified
fileInputAudio=$1
# Audio-Snippet-File after modification
fileOutputAudio=$2
# Factor to stretch/compress by
myFactor=$3

sox ${fileInputAudio} ${fileOutputAudio} tempo ${myFactor}
# "tempo" for pitch-correction, otherwise "speed"











# Cool way to get a sequence of floats for the for-loop-head:
# https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch06s13.html
# seq STARTING-VALUE INCREMENT ENDING-VALUE
# Helpful "bash seq" examples:
# https://wiki.ubuntuusers.de/seq/

# Old version

#PATHIN=$MYPATH
#PATHINTER=$MYPATH/../$FACTOR
#PATHOUT=$PATHINTER/snippets
#mkdir -p $PATHOUT # Creates directory and (-p) any necessary parent directories
#for filename in $(ls $PATHIN)
#do
#	if [[ $filename != *_.wav ]]
#	then
#		python ./scrAudioTimeStretcher.py -i $PATHIN/$filename -o $PATHOUT/$filename -f $FACTOR #-n 4096 #-n => num of FFT bins to use'
#	else
#		cp $PATHIN/$filename $PATHOUT/$filename
#	fi
#done;
