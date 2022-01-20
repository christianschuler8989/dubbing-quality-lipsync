#!/usr/bin/env python

#####################################################
# Adjusting the frames for the modified audio-files #
#####################################################

import sys

pathTimestamps = sys.argv[1] + '/timestamps.txt'
# /..../editing/scripts/../material/mind/pizzaEnglish/phonemes/p/exploration/sec01/001
pathVideoFrames = sys.argv[2]
# /..../editing/scripts/../material/mind/pizzaEnglish/preliminaries/videoFrames
pathVideoNewFrames = sys.argv[3]
# /..../editing/scripts/../material/mind/pizzaEnglish/phonemes/p/exploration/sec01/001/video/newFrames
myModeFrame = sys.argv[4]
# Like "copy" or "shift"
myShiftFactor = int(sys.argv[5])
# Like 4 or 5

# Debugging
#print("pathTimestamps: " + str(pathTimestamps))
#print("pathVideoFrames: " + str(pathVideoFrames))
#print("pathVideoNewFrames: " + str(pathVideoNewFrames))
#print("myModeFrame: " + str(myModeFrame))
#print("myShiftFactor: " + str(myShiftFactor))


# Copying files with python
# https://stackoverflow.com/questions/123198/how-can-a-file-be-copied
from shutil import copyfile
import os, os.path

###############################################################################################################
# Copy frames for the phonemes inside the timewindow (all phonemes from timestamps.txt) without modifications #
###############################################################################################################
def copyFrames():
	with open(pathTimestamps, "r") as timestamps:
		phonemesNeedingFrames = timestamps.readlines()
		linesOfTimestamps = [line.split() for line in phonemesNeedingFrames]
		# Frame for start and end of timewindow as zero-padded-str e.g., 00069
		#print(linesOfTimestamps[0][4]) # Debugging
		startFrameOfTimewindow = str(int(round(float(linesOfTimestamps[0][4])))).zfill(5).split(".")[0]
		endFrameOfTimewindow = str(int(round(float(linesOfTimestamps[-1][4])))).zfill(5).split(".")[0]

		for frame in os.listdir(pathVideoFrames):
			frameIdentifier = frame.split(".")[0]
			if int(startFrameOfTimewindow) < int(frameIdentifier) & int(frameIdentifier) < int(endFrameOfTimewindow):
				copyfile(pathVideoFrames+frame, pathVideoNewFrames+"/"+frame)


#########################################################################################################
# Copy frames for the phonemes inside the timewindow (all phonemes from timestamps.txt)                 #
# But delete every second frame before the phoneme in a range of shift-factor and compensate in the end #
#########################################################################################################
def shiftLeftFrames():
	with open(pathTimestamps, "r") as timestamps:
		phonemesNeedingFrames = timestamps.readlines()
		linesOfTimestamps = [line.split() for line in phonemesNeedingFrames]
		# Frame for start and end of timewindow as zero-padded-str e.g., 00069
		#print(linesOfTimestamps[0][4]) # Debugging
		startFrameOfTimewindow = str(int(round(float(linesOfTimestamps[0][4])))).zfill(5).split(".")[0]
		endFrameOfTimewindow = str(int(round(float(linesOfTimestamps[-1][4])))).zfill(5).split(".")[0]

		# Copy all the frames for video-generation
		for frame in os.listdir(pathVideoFrames):
			frameIdentifier = frame.split(".")[0]
			if int(startFrameOfTimewindow) <= int(frameIdentifier) & int(frameIdentifier) <= int(endFrameOfTimewindow):
				copyfile(pathVideoFrames+frame, pathVideoNewFrames + "/" + frame)
				########################################
				# TODOD: Overengineering of markers??? #
				########################################
				# Frame is part of the phoneme and marker is added
				#if int(frameIdentifier)
				# Frame is part of the time-window but not the phoneme itself

		if myShiftFactor > 0: # For shiftFactor of 0 no modifications are needed
			# Once all the frames have been copied, the adjustments take place:
			numberOfPhonemesNeedingFrames = len(phonemesNeedingFrames)		# The number of frames inside this timewindow/clip

	        ################################################
	        # Locate the correct phoneme and get its index #
	        ################################################
			indexOfMiddlePhoneme = 0
			counterToFindCorrectPhonemeIndex = 0
			for phonemeTimestamp in phonemesNeedingFrames:
				if (phonemeTimestamp[0] == "_"):         # Check for this label to find the correct phoneme
					indexOfMiddlePhoneme = counterToFindCorrectPhonemeIndex
				counterToFindCorrectPhonemeIndex += 1

	        # Process only good for numberOfPhonemes but not for numberOfSeconds as limits for timewindow
	        #indexOfMiddlePhoneme = int(numberOfPhonemesNeedingFrames / 2) 	# For accessing the middle of the phoneme
			# This should be correct in 50% of the cases in which the phoneme has only one single frame of duration
			# or is too close to the boarder of the original video to actually fill the allocated timewindow around the phoneme

			indexOfStartFrame = int(round(float(linesOfTimestamps[indexOfMiddlePhoneme][4])))	# Start-
			indexOfMiddleFrame = int(round(float(linesOfTimestamps[indexOfMiddlePhoneme][5])))	# Middle-
			indexOfEndFrame = int(round(float(linesOfTimestamps[indexOfMiddlePhoneme][6])))	# End- of the phoneme in question

			numberOfFramesToBeReplaced = indexOfEndFrame - indexOfStartFrame + 1 # Number of frames making up the phoneme
			#numberOfFramesToBeReplaced = int(round(float(linesOfTimestamps[indexOfMiddlePhoneme][6]) / 0.04)) # Number of frames making up the phoneme

			if numberOfFramesToBeReplaced < 1:
				print("The number of frames to be replaced is smaller than 1 and therefor nothing can be done.")
			currentFrame = indexOfStartFrame

			frameLocator = myShiftFactor 	# (Formerly called countdown)
			frameRelocator = 0 				# (Formerly called countup)
			firstFrame = 1
			if (currentFrame - (frameLocator * 2) < 1):
				firstFrame = 1
			else:
				firstFrame = currentFrame - (frameLocator * 2)

			###############################################
			# Modifying the frame in front of the phoneme #
			###############################################
			while frameLocator > 0: # As long as the location is in front of the phoneme:
				# Remove Frame on the left
				currentFrame = firstFrame + frameRelocator
				frameRelocator += 1		# The next frame should be taken from further on the right
				currentFrameIdentifier = str(currentFrame).zfill(5) + ".png"
				print("Frame (Shift) to be removed (left): " + currentFrameIdentifier)
				os.remove(pathVideoNewFrames + "/" + currentFrameIdentifier)
				# Replace missing frame with correspoding right neighbour (which might not be a direct neighbour)
				currentFrameRight = currentFrame + frameRelocator
				currentFrameRightIdentifier = str(currentFrameRight).zfill(5) + ".png"
				print("Frame (Shift) to be repositioned (left): " + currentFrameRightIdentifier)
				copyfile(pathVideoNewFrames + "/" + currentFrameRightIdentifier, pathVideoNewFrames + "/" + currentFrameIdentifier)
				#################################################################
				# Add some marker to locate the phoneme while watching the clip #
				#################################################################
				myCommandToAddMarker = "composite -geometry +20+20 " + pathVideoFrames + "/../../../../../images/markTimoB.jpg" + " " + pathVideoNewFrames + "/" + currentFrameIdentifier + " " + pathVideoNewFrames + "/" + currentFrameIdentifier
				os.system(myCommandToAddMarker)

				# Move index (frameLocator) closer to the phoneme in the middle of the timewindow
				frameLocator -= 1

			#############################################
			# Modifying the frame of the phoneme itself #
			#############################################
			frameRelocator = 0
			numberOfFramesToBeReplacedTemp = numberOfFramesToBeReplaced
			while numberOfFramesToBeReplacedTemp > 0: # Frames of the phoneme to be moved
				# Move the frame to the left:
				if (indexOfStartFrame - myShiftFactor < 1):
					currentFrame = 1
				else:
					currentFrame = indexOfStartFrame - myShiftFactor # How far to the left to move
				currentFrame += frameRelocator # Displacement for moving to the right with the index
				currentFrameIdentifier = str(currentFrame).zfill(5) + ".png"
				print("Frame (Shift) to be removed (middle): " + currentFrameIdentifier)
				os.remove(pathVideoNewFrames + "/" + currentFrameIdentifier)
				# Replace missing frame with right direct neighbour
				currentFrameRight = indexOfStartFrame + frameRelocator
				#print("indexOfStartFrame: " + str(indexOfStartFrame))
				#print("frameRelocator: " + str(frameRelocator))
				currentFrameRightIdentifier = str(currentFrameRight).zfill(5) + ".png"
				print("Frame (Shift) to be repositioned (middle): " + currentFrameRightIdentifier)
				copyfile(pathVideoNewFrames + "/" + currentFrameRightIdentifier, pathVideoNewFrames + "/" + currentFrameIdentifier)
				#################################################################
				# Add some marker to locate the phoneme while watching the clip #
				#################################################################
				myCommandToAddMarker = "composite -geometry +20+20 " + pathVideoFrames + "/../../../../../images/markChristian.jpg" + " " + pathVideoNewFrames + "/" + currentFrameIdentifier + " " + pathVideoNewFrames + "/" + currentFrameIdentifier
				os.system(myCommandToAddMarker)

				frameRelocator += 1		# Move index of frame for replacement by one
				numberOfFramesToBeReplacedTemp -= 1 # Keep going until the end of the phoneme has been reached

			############################################
			# Modify the frames right after he phoneme #
			############################################
			frameLocator = myShiftFactor 		# Where to remove frames from- wrt. startFrame
			frameRelocator = 0					# How far to move frames to replace just removed frames
			firstFrame = indexOfStartFrame - (myShiftFactor) + numberOfFramesToBeReplaced # Starting position of operation to the right
			# Beginning at the indexOfStartFrame, subtracting the number of frames that have been removed, adding the size of the phoneme to end up right behind the last modified frame

			# Modify the frames after the phoneme
			positionOfReplacementFrameCounter = 0
			while frameLocator > 0: # Number of frames right behind the phoneme that have to be copied
				# Remove Frame on the left
				currentFrame = firstFrame + frameRelocator
				frameRelocator += 2 # Move index to the right by 2 more than before
				# This way the index (frameRelocator) will skip the second to be replace frame
				###########################################
				# First frame of the loop to be replaced #
				###########################################
				currentFrameIdentifier = str(currentFrame).zfill(5) + ".png"
				print("Frame (Shift) to be removed (right): " + currentFrameIdentifier)
				os.remove(pathVideoNewFrames + "/" + currentFrameIdentifier)
				# Replace missing frame with a frame from the right
				currentFrameRight = currentFrame + myShiftFactor - positionOfReplacementFrameCounter # The frame to be copied is as far away to the right as the number of frames of the shift
				currentFrameRightIdentifier = str(currentFrameRight).zfill(5) + ".png"
				currentFrameRightPlus = currentFrame + myShiftFactor - positionOfReplacementFrameCounter + 1 # The frame to be copied is as far away to the right as the number of frames of the shift
				currentFrameRightIdentifierPlus = str(currentFrameRightPlus).zfill(5) + ".png"
				print("Frame (Shift) to be repositioned (right): " + currentFrameRightIdentifier + " and " + currentFrameRightIdentifierPlus)
				# Instead of plainly copying the frame twice, the first "copy" is a combination of two neighbouring frames to make the transition more smooth
				myCommandToBlendImages = "composite -blend 50 -gravity South " + pathVideoNewFrames + "/" + currentFrameRightIdentifier + " " + pathVideoNewFrames + "/" + currentFrameRightIdentifierPlus + " -alpha Set " + pathVideoNewFrames + "/" + currentFrameIdentifier
				os.system(myCommandToBlendImages)
				# Base-command: composite -blend 50 -gravity South 00016.png 00017.png -alpha Set 0001617.png
				# Plain-Copy-Version without blending: copyfile(pathVideoNewFrames + "/" + currentFrameRightIdentifier, pathVideoNewFrames + "/" + currentFrameIdentifier)
				#################################################################
				# Add some marker to locate the phoneme while watching the clip #
				#################################################################
				myCommandToAddMarker = "composite -geometry +20+20 " + pathVideoFrames + "/../../../../../images/markTimoG.jpg" + " " + pathVideoNewFrames + "/" + currentFrameIdentifier + " " + pathVideoNewFrames + "/" + currentFrameIdentifier
				os.system(myCommandToAddMarker)

				###########################################
				# Second frame of the loop to be replaced #
				###########################################
				# Same procedure for the direct neighbour of the just processed frame
				# (this way the number of frames, removed from right in front of the shifted phoneme
				# and the number of frames added right behind the phoneme will be ballancing each other out)
				if frameLocator > 1: # Prevent the removal of the last frame and then trying to replace it with itself
					currentFrame += 1
					currentFrameIdentifier = str(currentFrame).zfill(5) + ".png"
					print("Frame (Shift) to be removed (right): " + currentFrameIdentifier)
					os.remove(pathVideoNewFrames + "/" + currentFrameIdentifier)
					# Again replace the missing frame with the same frame from the right as before (copying this frame)
					#currentFrameRight = currentFrame + numberOfFramesToBeReplaced # The frame to be copied is as far away to the right as the number of frames of the shift
					#currentFrameRightIdentifier = str(currentFrameRight).zfill(5) + ".png"
					print("Frame (Shift) to be repositioned (right): " + currentFrameRightIdentifier)
					copyfile(pathVideoNewFrames + "/" + currentFrameRightIdentifier, pathVideoNewFrames + "/" + currentFrameIdentifier)
					#################################################################
					# Add some marker to locate the phoneme while watching the clip #
					#################################################################
					myCommandToAddMarker = "composite -geometry +20+20 " + pathVideoFrames + "/../../../../../images/markTimoG.jpg" + " " + pathVideoNewFrames + "/" + currentFrameIdentifier + " " + pathVideoNewFrames + "/" + currentFrameIdentifier
					os.system(myCommandToAddMarker)

				# Take care of counting
				frameLocator -= 1

				# Ugly fix for the problem that the "currentFrameRightIdentifier" jumps by 2 every loop and only every second frame after the phoneme gets copied
				positionOfReplacementFrameCounter += 1


def shiftRightFrames():
	print("This functionality is not yet implemented.")


################################################
# Format of the read lines from timestamps.txt #
################################################
# [label,	startTime,	endTime,	duration,	startFrame,		midFrame,	endFrame]

###############################################
# Bash-version of marker-location calculation #
###############################################
# Get dimensions of the frames for marker positioning
#frameWidth=$(identify -format "%w" $clipDirectory"/preliminaries/videoFrames/00002.png")> /dev/null
#frameHeight=$(identify -format "%h" $clipDirectory"/preliminaries/videoFrames/00002.png")> /dev/null
#frameWidth=$(expr $frameWidth - 10)
#frameHeight=$(expr $frameHeight - 10)



if myModeFrame == "copy":
	copyFrames()
elif myModeFrame == "shiftLeft":
	shiftLeftFrames()
elif myModeFrame == "shiftRight":
	shiftRightFrames()
