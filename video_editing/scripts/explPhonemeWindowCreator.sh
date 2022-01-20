#!/bin/bash

######################################################################
# Creating audio-snippets based on the timestamps of a phonem[group] #
######################################################################

# Take first input parameter and create (path to timestamps.txt) and (path to audio.wav) and (path to frames.png)
pathTimestamps=$1
timestamps=$pathTimestamps/timestamps.txt

pathAudioFile=$1/../../../../preperation
audioFile=$pathAudioFile/audio.wav

pathVideoFrames=$1/../../../../preperation/videoFrames/
videoFrames=$pathVideoFrames/*.png

# Take second input parameter for phonemeIdentifier
phonemeName=$2
# Take third input parameter for FPS of video
myFPS=$3
# Take fourth input parameter for samplesize
mySize=$4
# Take fifth input parameter for operation-mode regarding the frames
myModeFrame=$5
# Take sixth input parameter for factor to shift frames/phonemes in time
myShiftFactor=$6
# Take seventh input parameter for name of clip for final sorting of results
myClipName=$7
# Mode of operation (audioMod, visualMod, ...)
myMode=${8}

# Path for output.mp4
# Seperately for every phoneme in its own directory
#pathOutput=$1/../../finds
# All of them gathered in one directory per clip
pathOutput=$1/../../../../outputCombined
numberOfFoundPhoneme=${pathTimestamps: -3}
output=$pathOutput/${myMode}"_"${myClipName}"_"${phonemeName}${mySize}"s_"${numberOfFoundPhoneme}"_${myShiftFactor}.mp4"
outputSlow=$pathOutput/${myMode}"_"${phonemeName}${mySize}"s_"${numberOfFoundPhoneme}"_${myShiftFactor}_slow.mp4"
outputSlowSuper=$pathOutput/${myMode}"_"${phonemeName}${mySize}"s_"${numberOfFoundPhoneme}"_${myShiftFactor}_slowSuper.mp4"


########################################
# Create subdirectories for processing #
########################################
pathAudioSnippets=$pathTimestamps/audio/snippets/
pathAudioOutput=$pathTimestamps/audio/outputAudio
pathVideoNewFrames=$pathTimestamps/video/newFrames
pathVideoOutput=$pathTimestamps/video/outputVideo
if [ -d "$pathAudioSnippets" ]; then
  # Take action if the directory (and therefore the others) already exists. #
  rm -r $pathAudioSnippets
  rm -r $pathAudioOutput
  rm -r $pathVideoNewFrames
  rm -r $pathVideoOutput
fi
mkdir -p $pathAudioSnippets
mkdir -p $pathAudioOutput
mkdir -p $pathVideoNewFrames
mkdir -p $pathVideoOutput


###################################################################################
# Sort the content of the timestamps.txt in accending order in regard to column 2 #
###################################################################################
sort -n -k 2 -o $timestamps $timestamps


#############################
# Create audio-snippets.wav #
#############################
n=1
while read line; do
  LABEL=$(echo $line| cut -d' ' -f 1)
  START=$(echo $line| cut -d' ' -f 2)
  END=$(echo $line| cut -d' ' -f 3)
  DURATION=$(echo $line| cut -d' ' -f 4)
  sox $audioFile $pathAudioSnippets`printf %04d $n`-$START$LABEL.wav trim $START $DURATION
  n=$((n+1))
done < $timestamps


##############################################
# Combine audio-snippets to output-audio.wav #
##############################################
for filename in $(ls $pathAudioSnippets)
do
	sox $(ls $pathAudioSnippets/*.wav | sort) $pathAudioOutput/audioOut.wav
done;


########################################
# Copy extracted frames from video.mp4 #
########################################
python explPhonemeWindowAdjuster.py $pathTimestamps $pathVideoFrames $pathVideoNewFrames $myModeFrame $myShiftFactor


#################################################
# Rename frames.png into ffmpeg-friendly format #
#################################################
n=0
for file in $pathVideoNewFrames/*; do
  newnumber=`printf "%0*d" 5 $n`
  n=$(( $n+1 ))
  mv $file $pathVideoNewFrames/$newnumber.png  # renaming
done

##################################################
# Combine sequence of images (.png) to video.mp4 #
##################################################
ffmpeg -loglevel warning -r $myFPS -f image2 -s 1920x1080 -i $pathVideoNewFrames/%05d.png -vcodec libx264 -crf $myFPS -pix_fmt yuv420p $pathVideoOutput/videoOut.mp4


#################################################
# Combine audio.wav and video.mp4 to video-clip #
#################################################
echo "Combining video and audio into ${output}"
ffmpeg -loglevel warning -i $pathVideoOutput/videoOut.mp4 -channel_layout mono -i $pathAudioOutput/audioOut.wav -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 $output


######################################
# Slow down video-clips for sighting #
######################################
# Half the speed leads to double the duration
#ffmpeg -loglevel warning -i $output -filter_complex "[0:v]setpts=2.0*PTS[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" $outputSlow
# The same again for a quarter of the speed and four times the duration
#ffmpeg -loglevel warning -i $outputSlow -filter_complex "[0:v]setpts=2.0*PTS[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" $outputSlowSuper
