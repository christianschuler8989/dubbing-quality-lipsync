#!/bin/bash

######################################################################
# Creating audio-snippets based on the timestamps of a phonem[group] #
######################################################################

# Path to timestamps.txt of this specific phoneme
timestamps=$1/timestamps.txt
# Path to original audio.wav
audioFile=$2/preperation/audio.wav
# Path to directory of (newly created) audio-snippets
pathSnippets=$3

n=1
while read line; do
  LABEL=$(echo $line| cut -d' ' -f 1)
  START=$(echo $line| cut -d' ' -f 2)
  END=$(echo $line| cut -d' ' -f 3)
  DURATION=$(echo $line| cut -d' ' -f 4)
  sox ${audioFile} ${pathSnippets}`printf %04d $n`-${START}"-"${LABEL}.wav trim ${START} ${DURATION}
  n=$((n+1))
done < ${timestamps}
