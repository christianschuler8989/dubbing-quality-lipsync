#!/bin/bash

######################################################################
# Creating audio-snippets based on the timestamps of a phonem[group] #
######################################################################

# Path to timestamps.txt
pathTimestamps=$1
timestamps=$pathTimestamps/timestamps.txt
# Path to audio.wav
pathAudioFile=$1/../../../../preperation
audioFile=$pathAudioFile/audio.wav
# Path to all the frames.png extracted from the video
pathVideoFrames=$1/../../../../preperation/videoFrames/
videoFrames=$pathVideoFrames/*.png

# Name (phonemeIdentifier) of the phoneme
phonemeName=$2
# FPS of video
myFPS=$3
# Samplesize (length of sequence in front and in back of phoneme)
mySize=$4
# Operation-mode regarding the frames like "shoft" or "copy"
myModeFrame=$5
# Factor to shift frames/phonemes in time
myShiftFactor=$6
# Name of clip for final sorting of results
myClipName=$7
# Duration of clip for later cutting
myVideoDuration=$8
# Name of "interesting" video
myVideoName=$9
# Mode of operation (audioMod, visualMod, ...)
myMode=${10}

# Path for final output.mp4
# Seperately for every phoneme in its own directory => #pathOutput=$1/../../finds
# All of them gathered in one directory per clip
pathOutput=$1/../../../../outputCombined
numberOfFoundPhoneme=${pathTimestamps: -3}
output=$pathOutput/${myMode}"_"${myClipName}"_"${myVideoName}"_"${phonemeName}"_"${numberOfFoundPhoneme}"_${myModeFrame}${myShiftFactor}_${myStretchFactor}.mp4"
outputCut=$pathOutput/${myMode}"_"${myClipName}"_"${myVideoName}"_"${phonemeName}"_"${numberOfFoundPhoneme}"_${myModeFrame}${myShiftFactor}_${myStretchFactor}cut.mp4"
outputSlow=$pathOutput/${myMode}"_"${myClipName}"_"${myVideoName}"_"${phonemeName}"_"${numberOfFoundPhoneme}"_${myModeFrame}${myShiftFactor}_${myStretchFactor}_slow.mp4"
outputSlowSuper=$pathOutput/${myMode}"_"${myClipName}"_"${myVideoName}"_"${phonemeName}"_"${numberOfFoundPhoneme}"_${myModeFrame}${myShiftFactor}_${myStretchFactor}_slowSuper.mp4"

########################################
# Create subdirectories for processing #
########################################
#echo "Create subdirectories for processing"
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
#echo "Sort the content of the timestamps.txt in accending order in regard to column 2"
sort -n -k 2 -o $timestamps $timestamps

#############################
# Create audio-snippets.wav #
#############################
#echo "Create audio-snippets.wav"
n=1
while read line; do
  LABEL=$(echo ${line}| cut -d' ' -f 1)
  START=$(echo ${line}| cut -d' ' -f 2)
  END=$(echo ${line}| cut -d' ' -f 3)
  DURATION=$(echo ${line}| cut -d' ' -f 4)
  sox ${audioFile} ${pathAudioSnippets}`printf %04d ${n}`-${START}${LABEL}.wav trim ${START} ${DURATION}
  n=$((n+1))
done < ${timestamps}

##############################################
# Combine audio-snippets to output-audio.wav #
##############################################
#echo "Combine audio-snippets to output-audio.wav"
for filename in $(ls $pathAudioSnippets)
do
	sox $(ls $pathAudioSnippets/*.wav | sort) $pathAudioOutput/audioOut.wav
done;

########################################
# Copy extracted frames from video.mp4 #
########################################
#echo "Copy extracted frames from video.mp4"
python visualPhonemeWindowAdjuster.py $pathTimestamps $pathVideoFrames $pathVideoNewFrames $myModeFrame $myShiftFactor

#################################################
# Rename frames.png into ffmpeg-friendly format #
#################################################
#echo "Rename frames.png into ffmpeg-friendly format"
n=0
for file in $pathVideoNewFrames/*; do
  newnumber=`printf "%0*d" 5 $n`
  n=$(( $n+1 ))
  mv $file $pathVideoNewFrames/$newnumber.png  # renaming
done

##################################################
# Combine sequence of images (.png) to video.mp4 #
##################################################
#echo "Combine sequence of images (.png) to video.mp4"
#
# The dimensions of the frames are different for some of the video-materials
# 2021: 1280x720   20??: 1920x1080
#ffmpeg -loglevel warning -r $myFPS -f image2 -s 1920x1080 -i $pathVideoNewFrames/%05d.png -vcodec libx264 -crf $myFPS -pix_fmt yuv420p $pathVideoOutput/videoOut.mp4
ffmpeg -loglevel warning -r $myFPS -f image2 -s 1280x720 -i $pathVideoNewFrames/%05d.png -vcodec libx264 -crf $myFPS -pix_fmt yuv420p $pathVideoOutput/videoOut.mp4

#################################################
# Combine audio.wav and video.mp4 to video-clip #
#################################################
echo "Combining video and audio into ${output}"
ffmpeg -loglevel warning -i $pathVideoOutput/videoOut.mp4 -channel_layout mono -i $pathAudioOutput/audioOut.wav -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 $output

######################################################
# Cut off the buffers in front and end of video-clip #
######################################################
#echo "Cut off the buffers in front and end of video-clip"
ffmpeg -loglevel warning -i ${output} -ss 00:00:0${mySize} -t 00:00:0${myVideoDuration} ${outputCut}
# Delete the buffered-video for conveniances sake
rm ${output}

######################################
# Slow down video-clips for sighting #
######################################
# Half the speed leads to double the duration
#ffmpeg -loglevel warning -i ${outputCut} -filter_complex "[0:v]setpts=2.0*PTS[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" ${outputSlow}
# The same again for a quarter of the speed and four times the duration
#ffmpeg -loglevel warning -i ${outputSlow} -filter_complex "[0:v]setpts=2.0*PTS[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" ${outputSlowSuper}
