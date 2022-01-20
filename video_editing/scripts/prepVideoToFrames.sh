#!/bin/bash

####################################
# Seperates video to single frames #
####################################

myPath=$1
myFPS=$2

# Create the directory for storing the videoFrames
mkdir -p $myPath/preperation/videoFrames
#mkdir -p $myPath/preliminaries/videoFramesZero

# Extract video-Frames from video-File
ffmpeg -loglevel warning -i $myPath/video.mp4 -vf fps=$myFPS $myPath/preperation/videoFrames/%05d.png
#ffmpeg -loglevel warning -i $myPath/video.mp4 -vf fps=$myFPS $myPath/preliminaries/videoFramesZero/%05d0.png
