#!/usr/bin/env python

#################################################################
# Modify audio-snippets by stretching / compressing by a factor #
#################################################################
import sys

pathTimestamps = sys.argv[1]
# /..../editing/scripts/../material/mind/pizzaEnglish/visualMod/Tempo/a/001
pathAudioSnippets = sys.argv[2]
# /..../editing/scripts/../material/mind/pizzaEnglish/preperation/videoFrames
pathAudioAdjusted = sys.argv[3]
# /..../editing/scripts/../material/mind/pizzaEnglish/visualMod/Tempo/a/001/video/newFrames
myModeFrame = sys.argv[4]
# Like "copy" or "shiftLeft" or "shiftRight"
myStretchFactor = float(sys.argv[5])
# Like 0.8 or 0.9
myFPS = int(sys.argv[6])
# Like 25
myShiftFactor = int(sys.argv[7])
# Like 0 or 2 or 5


# Copying files with python
# https://stackoverflow.com/questions/123198/how-can-a-file-be-copied
from shutil import copyfile
import os, os.path

##############
# For "copy" #
##############
# Copying the audio-snippets without any modifications
def copySnippets():
	from os import listdir
	from os.path import isfile, join

	# Read all the audio-snippet input-files into a list
	snippetsInputFiles = [f for f in listdir(pathAudioSnippets) if isfile(join(pathAudioSnippets, f))]
	# Copy every single one of them into the directory for adjusted audio-snippets
	for audioSnippet in snippetsInputFiles:
		copyfile(pathAudioSnippets + "/" + audioSnippet, pathAudioAdjusted + audioSnippet)


###################
# For "shiftLeft" #
###################
# Copy audio-snippet of phoneme without modifications into new directory
def shiftLeftSnippets():
	from os import listdir
	from os.path import isfile, join

	# Read all the audio-snippet input-files into a list
	snippetsInputFiles = [f for f in listdir(pathAudioSnippets) if isfile(join(pathAudioSnippets, f))]

	with open(pathTimestamps, "r") as timestamps:
		phonemesNeedingFrames = timestamps.readlines()
		linesOfTimestamps = [line.split() for line in phonemesNeedingFrames]

		# Adding the corresponding filename of the audio-snippet to the timestamp-line
		for audioFileName in snippetsInputFiles:
			startTime = audioFileName.split("-")[1]
			for timestampLine in linesOfTimestamps:
				if timestampLine[1] == startTime:
					timestampLine.append(audioFileName)
				else:
					pass

		################################################
		# Locate the correct phoneme and get its index #
		################################################
		indexOfMiddlePhoneme = 0
		counterToFindCorrectPhonemeIndex = 0
		for phonemeTimestamp in phonemesNeedingFrames:
			if (phonemeTimestamp[0] == "_"): # Check for this label to find the correct phoneme
				indexOfMiddlePhoneme = counterToFindCorrectPhonemeIndex
			counterToFindCorrectPhonemeIndex += 1
		#print("Index Of Middle Phoneme: " + str(indexOfMiddlePhoneme))
		#print("Line of timestamps at this index: " + str(linesOfTimestamps[indexOfMiddlePhoneme]))
		currentPhonemeFilename = linesOfTimestamps[indexOfMiddlePhoneme][7]
		copyfile(pathAudioSnippets + "/" + currentPhonemeFilename, pathAudioAdjusted + currentPhonemeFilename )
		################################################################################
		# Move (in timestamps.txt) backward starting from just copied phoneme position #
		################################################################################
		currentPosition = indexOfMiddlePhoneme - 1
		timeWindowLeft = myShiftFactor * ( 1 / myFPS ) # myFPS = 25 => 0.04
		myCounterStretchFactor = abs(myStretchFactor - 2)

		while timeWindowLeft > 0 and currentPosition >= 0:
			#print("Processing phoneme index: " + str(currentPosition) + " and timeWindowLeft: " + str(timeWindowLeft))
			currentPhonemeFilename = linesOfTimestamps[currentPosition][7]
			currentFileInput = pathAudioSnippets + "/" + currentPhonemeFilename
			currentFileOutput = pathAudioAdjusted + currentPhonemeFilename

			# Copy audio-snippet but stretch by counter-value of myStretchFactor
			# "counter-value" = ( abs( myStretchFactor - 2 ) )
			# [Bonus] Extra check how long this phoneme is and how much it could/should be modified
			myCommandToStretch = "sox " + currentFileInput + " " + currentFileOutput + " tempo " + str(myCounterStretchFactor)
			os.system(myCommandToStretch)

			############################################################
			# Take removed duration and subtract it from myShiftFactor #
			############################################################
			currentPhonemeDurationBefore = float(linesOfTimestamps[currentPosition][3])
			currentPhonemeDurationAfter = currentPhonemeDurationBefore * myStretchFactor # Opposite of actual operation for calculation needed
			currentPhonemeDurationDifference = currentPhonemeDurationBefore - currentPhonemeDurationAfter
			print("Shift: LEFT - Side: LEFT - Current Phoneme Duration Difference: " + str(currentPhonemeDurationDifference))
			print("Shift: LEFT - Side: LEFT - Current Phoneme Filename: " + str(currentPhonemeFilename))
			timeWindowLeft -= currentPhonemeDurationDifference
			###################################################################################
			# If timeWindowLeft (myShiftFactor) reaches 0- no further compressing is required #
			###################################################################################
			currentPosition -= 1
		#####################################################################
		# Remaining audio-snippets (in front) get copied into new directory #
		#####################################################################
		while currentPosition >= 0:
			#print("Processing phoneme index: " + str(currentPosition))
			currentPhonemeFilename = linesOfTimestamps[currentPosition][7]
			copyfile(pathAudioSnippets + "/" + currentPhonemeFilename, pathAudioAdjusted + currentPhonemeFilename )
			currentPosition -= 1
		##########################################
		# Notification if parameters not fitting #
		##########################################
		if currentPosition <= 0 and timeWindowLeft > 0:
			print("The phoneme-index ran out of (left) buffer-window but the required duration of (leftShift)(audio-)modification has not been reached yet.")

		############################################################################################
		# Move (in timestamps.txt) backward starting from the first (middle/main) phoneme position #
		############################################################################################
		currentPosition = indexOfMiddlePhoneme + 1
		timeWindowRight = myShiftFactor * ( 1 / myFPS ) # myFPS = 25 => 0.04

		while timeWindowRight > 0 and currentPosition < len(linesOfTimestamps):
			#print("Processing phoneme index: " + str(currentPosition) + " and timeWindowRight: " + str(timeWindowRight))
			currentPhonemeFilename = linesOfTimestamps[currentPosition][7]
			currentFileInput = pathAudioSnippets + "/" + currentPhonemeFilename
			currentFileOutput = pathAudioAdjusted + currentPhonemeFilename

			# Copy audio-snippet but compressed by myStretchFactor
			# [Bonus] Extra check how long this phoneme is and how much it could/should be modified
			myCommandToCompress = "sox " + currentFileInput + " " + currentFileOutput + " tempo " + str(myStretchFactor)
			os.system(myCommandToCompress)

			##########################################################
			# Take added duration and subtract it from myShiftFactor #
			##########################################################
			currentPhonemeDurationBefore = float(linesOfTimestamps[currentPosition][3])
			currentPhonemeDurationAfter = currentPhonemeDurationBefore * myCounterStretchFactor # Opposite of actual operation for calculation needed
			currentPhonemeDurationDifference = currentPhonemeDurationAfter - currentPhonemeDurationBefore
			print("Shift: LEFT - Side: RIGHT - Current Phoneme Duration Difference: " + str(currentPhonemeDurationDifference))
			print("Shift: LEFT - Side: RIGHT - Current Phoneme Filename: " + str(currentPhonemeFilename))
			timeWindowRight -= currentPhonemeDurationDifference
			###################################################################################
			# If timeWindowRight (myShiftFactor) reached 0- no further stretching is required #
			###################################################################################
			currentPosition += 1
		####################################################################
		# Remaining audio-snippets (in back) get copied into new directory #
		####################################################################
		while currentPosition < len(linesOfTimestamps):
			#print("Processing phoneme index: " + str(currentPosition))
			currentPhonemeFilename = linesOfTimestamps[currentPosition][7]
			copyfile(pathAudioSnippets + "/" + currentPhonemeFilename, pathAudioAdjusted + currentPhonemeFilename )
			currentPosition += 1
		##########################################
		# Notification if parameters not fitting #
		##########################################
		if currentPosition >= len(linesOfTimestamps) and timeWindowRight > 0:
			print("The phoneme-index ran out of (right) buffer-window but the required duration of (leftShift)(audio-)modification has not been reached yet.")

####################
# For "shiftRight" #
####################
# Copy audio-snippet of phoneme without modifications into new directory
def shiftRightSnippets():
	from os import listdir
	from os.path import isfile, join

	# Read all the audio-snippet input-files into a list
	snippetsInputFiles = [f for f in listdir(pathAudioSnippets) if isfile(join(pathAudioSnippets, f))]

	with open(pathTimestamps, "r") as timestamps:
		phonemesNeedingFrames = timestamps.readlines()
		linesOfTimestamps = [line.split() for line in phonemesNeedingFrames]

		# Adding the corresponding filename of the audio-snippet to the timestamp-line
		for audioFileName in snippetsInputFiles:
			startTime = audioFileName.split("-")[1]
			for timestampLine in linesOfTimestamps:
				if timestampLine[1] == startTime:
					timestampLine.append(audioFileName)
				else:
					pass

		################################################
		# Locate the correct phoneme and get its index #
		################################################
		indexOfMiddlePhoneme = 0
		counterToFindCorrectPhonemeIndex = 0
		for phonemeTimestamp in phonemesNeedingFrames:
			if (phonemeTimestamp[0] == "_"):         # Check for this label to find the correct phoneme
				indexOfMiddlePhoneme = counterToFindCorrectPhonemeIndex
			counterToFindCorrectPhonemeIndex += 1
		#print("START Index Of Middle Phoneme: " + str(indexOfMiddlePhoneme))
		#print("Line of timestamps at this index: " + str(linesOfTimestamps[indexOfMiddlePhoneme]))
		currentPhonemeFilename = linesOfTimestamps[indexOfMiddlePhoneme][7]
		copyfile(pathAudioSnippets + "/" + currentPhonemeFilename, pathAudioAdjusted + currentPhonemeFilename )
		###############################################################################
		# Move (in timestamps.txt) forward starting from just copied phoneme position #
		###############################################################################
		currentPosition = indexOfMiddlePhoneme + 1
		timeWindowRight = myShiftFactor * ( 1 / myFPS ) # myFPS = 25 => 0.04
		myCounterStretchFactor = abs(myStretchFactor - 2)
		#print("MOVE Index Of Middle Phoneme: " + str(currentPosition))
		#print("Line of timestamps at this index: " + str(linesOfTimestamps[currentPosition]))
		while timeWindowRight > 0 and currentPosition < len(linesOfTimestamps):
			#print("Processing phoneme index: " + str(currentPosition) + " and timeWindowLeft: " + str(timeWindowLeft))
			#print("WHILE Index Of Middle Phoneme: " + str(currentPosition))
			#print("Line of timestamps at this index: " + str(linesOfTimestamps[currentPosition]))
			currentPhonemeFilename = linesOfTimestamps[currentPosition][7]
			currentFileInput = pathAudioSnippets + "/" + currentPhonemeFilename
			currentFileOutput = pathAudioAdjusted + currentPhonemeFilename

			# Copy audio-snippet but compressed by myStretchFactor
			# [Bonus] Extra check how long this phoneme is and how much it could/should be modified
			myCommandToCompress = "sox " + currentFileInput + " " + currentFileOutput + " tempo " + str(myCounterStretchFactor)
			os.system(myCommandToCompress)

			############################################################
			# Take removed duration and subtract it from myShiftFactor #
			############################################################
			currentPhonemeDurationBefore = float(linesOfTimestamps[currentPosition][3])
			currentPhonemeDurationAfter = currentPhonemeDurationBefore * myStretchFactor # Opposite of actual operation for calculation needed
			currentPhonemeDurationDifference = currentPhonemeDurationBefore - currentPhonemeDurationAfter
			#print("Current Phoneme Duration Before: " + str(currentPhonemeDurationBefore))
			#print("Current Phoneme Duration After: " + str(currentPhonemeDurationAfter))
			print("Shift: RIGHT - Side: RIGHT - Current Phoneme Duration Difference: " + str(currentPhonemeDurationDifference))
			print("Shift: RIGHT - Side: RIGHT - Current Phoneme Filename: " + str(currentPhonemeFilename))
			timeWindowRight -= currentPhonemeDurationDifference
			###################################################################################
			# If timeWindowLeft (myShiftFactor) reaches 0- no further compressing is required #
			###################################################################################
			currentPosition += 1
		#####################################################################
		# Remaining audio-snippets (in front) get copied into new directory #
		#####################################################################
		while currentPosition < len(linesOfTimestamps):
			#print("Processing phoneme index: " + str(currentPosition))
			currentPhonemeFilename = linesOfTimestamps[currentPosition][7]
			copyfile(pathAudioSnippets + "/" + currentPhonemeFilename, pathAudioAdjusted + currentPhonemeFilename )
			currentPosition += 1
		##########################################
		# Notification if parameters not fitting #
		##########################################
		if currentPosition >= len(linesOfTimestamps) and timeWindowRight > 0:
			print("The phoneme-index ran out of (left) buffer-window but the required duration of (rightShift)(audio-)modification has not been reached yet.")


		############################################################################################
		# Move (in timestamps.txt) forward starting from the first (middle/main) phoneme position #
		############################################################################################
		currentPosition = indexOfMiddlePhoneme - 1
		timeWindowLeft = myShiftFactor * ( 1 / myFPS ) # myFPS = 25 => 0.04

		while timeWindowLeft > 0 and currentPosition >= 0:
			#print("Processing phoneme index: " + str(currentPosition) + " and timeWindowRight: " + str(timeWindowRight))
			currentPhonemeFilename = linesOfTimestamps[currentPosition][7]
			currentFileInput = pathAudioSnippets + "/" + currentPhonemeFilename
			currentFileOutput = pathAudioAdjusted + currentPhonemeFilename

			# Copy audio-snippet but stretch by counter-value of myStretchFactor
			# "counter-value" = ( abs( myStretchFactor - 2 ) )
			# [Bonus] Extra check how long this phoneme is and how much it could/should be modified
			myCommandToStretch = "sox " + currentFileInput + " " + currentFileOutput + " tempo " + str(myStretchFactor)
			os.system(myCommandToStretch)

			##########################################################
			# Take added duration and subtract it from myShiftFactor #
			##########################################################
			currentPhonemeDurationBefore = float(linesOfTimestamps[currentPosition][3])
			currentPhonemeDurationAfter = currentPhonemeDurationBefore * myCounterStretchFactor # Opposite of actual operation for calculation needed
			currentPhonemeDurationDifference = currentPhonemeDurationAfter - currentPhonemeDurationBefore
			print("Shift: RIGHT - Side: LEFT - Current Phoneme Duration Difference: " + str(currentPhonemeDurationDifference))
			print("Shift: RIGHT - Side: LEFT - Current Phoneme Filename: " + str(currentPhonemeFilename))
			timeWindowLeft -= currentPhonemeDurationDifference
			###################################################################################
			# If timeWindowRight (myShiftFactor) reached 0- no further stretching is required #
			###################################################################################
			currentPosition -= 1
		####################################################################
		# Remaining audio-snippets (in back) get copied into new directory #
		####################################################################
		while currentPosition >= 0:
			#print("Processing phoneme index: " + str(currentPosition))
			currentPhonemeFilename = linesOfTimestamps[currentPosition][7]
			copyfile(pathAudioSnippets + "/" + currentPhonemeFilename, pathAudioAdjusted + currentPhonemeFilename )
			currentPosition -= 1
		##########################################
		# Notification if parameters not fitting #
		##########################################
		if currentPosition <= 0 and timeWindowLeft > 0:
			print("The phoneme-index ran out of (right) buffer-window but the required duration of (rightShift)(audio-)modification has not been reached yet.")



if myModeFrame == "copy":
	copySnippets()
elif myModeFrame == "shiftLeft":
	shiftLeftSnippets()
elif myModeFrame == "shiftRight":
	shiftRightSnippets()
