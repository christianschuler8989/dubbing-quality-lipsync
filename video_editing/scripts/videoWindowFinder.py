#!/usr/bin/env python

#############################################################
# Creation of timestamps.txt for phonem[group] localisation #
#############################################################
import textgrids
# https://pypi.org/project/praat-textgrids/

#########################################
# Handling Input- and Output-Parameters #
#########################################
import sys

pathVideoDirectory = sys.argv[1]
pathTimestampsVideo = pathVideoDirectory + '/timestampsVideo.txt'
# Like editing/material/movie/clip/phonemes/exploration/sec01
mySize = float(sys.argv[2]) # For "phoneme-windows" instead of "second-windows" this has to be int() instead!
# Like 2 or 3
pathToTimestampsAll = sys.argv[3]
pathTimestampsAll = pathToTimestampsAll + '/timestampsAll.txt'
# Like editing/material/movie/clip/preperation
videoStart = float(sys.argv[4])
# Like 179.9
videoEnd = float(sys.argv[5])
# Like 181.6

# Actual time-window for this video (some buffer for editing and shifting of frames/phonemes)
videoStartBuffer = videoStart - mySize
videoEndBuffer = videoEnd + mySize
print("VideoStartBuffer: " + str(videoStartBuffer) + " and VideoEndBuffer: " + str(videoEndBuffer))


#####################################################
# Extract timestampsVideo.txt with buffer around it #
#####################################################
def extractTimestamps():
	with open(pathTimestampsAll, "r") as timestampsAll:
		timestamps = timestampsAll.readlines()
		timestampsArray = [line.split() for line in timestamps]
		for timestamp in timestampsArray:
			if (videoStartBuffer < float(timestamp[1]) and float(timestamp[2]) < videoEndBuffer):
				with open(pathTimestampsVideo, "a") as newTimestamps:
					contentToWrite = str(timestamp[0])+" " \
					+str(round(float(timestamp[1]), 3))+" " \
					+str(round(float(timestamp[2]), 3))+" " \
					+str(round(float(timestamp[3]), 3))+" " \
					+str(round(float(timestamp[4]), 3))+" " \
					+str(round(float(timestamp[5]), 3))+" " \
					+str(round(float(timestamp[6]), 3))+'\n'
					# label
					# startTime
					# endTime
					# duration
					# startFrame
					# midFrame
					# endFrame
					newTimestamps.write(contentToWrite)


extractTimestamps()
