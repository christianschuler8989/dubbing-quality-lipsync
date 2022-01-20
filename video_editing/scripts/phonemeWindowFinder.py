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

pathToTimestampsNew = sys.argv[1]
# Path to directory of currently searched phoneme

#pathTimewindow = sys.argv[1]

mySize = float(sys.argv[2]) # For "phoneme-windows" instead of "second-windows" this has to be int() instead!
# Like 2 or 3

#pathToTimestampsAll = sys.argv[3]
#pathTimestampsAll = pathToTimestampsAll + '/timestampsAll.txt'

pathVideoDirectory = sys.argv[3]
pathTimestampsVideo = pathVideoDirectory + '/timestampsVideo.txt'

# Like editing/material/movie/clip/preliminaries
phonemeName = sys.argv[4]
# Like a or f
operationalMode = sys.argv[5]
# Like "blind" or "sight"

# Start and End of timewindow inside the video-clip (excluding the buffers)
videoStart = float(sys.argv[6])
videoEnd = float(sys.argv[7])

##############################################################
# Read interesting-Phonemes from manually provided .txt file #
##############################################################
#if operationalMode == "sight":
#	currentInterestingPhonemesArray = []
#	pathInterestingPhonemes = pathToTimestampsAll + "/.."
#	fileInterestingPhonemes = pathInterestingPhonemes + "/interestingPhonemes.txt"
#
#	with open(fileInterestingPhonemes, "r") as interestingPhonemesAll:
#		# Read all the phonemes from interestingPhonemes.txt
#		interestingPhonemes = interestingPhonemesAll.readlines()
#		interestingPhonemesArray = [line.split() for line in interestingPhonemes]
#		# Only keep the interestingPhonemes that correspond to the current phonemeName
#		currentInterestingPhonemesArray = [phoneme for phoneme in interestingPhonemesArray if phoneme[0] == phonemeName]
#		print(currentInterestingPhonemesArray)



####################
# Create directory #
####################
import os
# Detect the current working directory and print it
path = os.getcwd()
print ("Extracting timestamps(-window) for phoneme: %s " % phonemeName)

# Creation of a single directory
def createDir(dirPath):
	# Define the access rights.
	# The default setting is 777, which means it is readable and writable by the owner,
	# group members, and all other users as well.
	accessRights = 0o755
	#access_rights = 777
	try:
		os.mkdir(dirPath, accessRights)
	except OSError:
		pass
		#print ("Creation of the directory %s failed" % dir_path)
	else:
		print ("Successfully created the directory %s" % dirPath)



##########################################################################################
# Extracting phoneme-times with a window of mySize many seconds around the found phoneme #
##########################################################################################
def getPhonemeTimestamps():
	with open(pathTimestampsVideo, "r") as timestampsVideo:
		timestamps = timestampsVideo.readlines()
		timestampsArray = [line.split() for line in timestamps]
		lineCounter = 0
		foundPhonemeCounter = 0
		# Look through all phoneme(timestamps)
		for timestamp in timestampsArray:
			# To find phonemes with label == phonemeName
			if timestamp[0] == phonemeName:
				# But exclude the ones in the buffer- outside the actual timewindow
				if ( (videoStart < float(timestamp[1])) & (float(timestamp[2]) < videoEnd) ):
					foundPhonemeCounter += 1
					# Create directory for timestamps.txt and subdirectories
					# If this is the first found phoneme of this kind, then the main-phoneme-directory has to be created
					if foundPhonemeCounter == 1:
						createDir(pathToTimestampsNew)
					phonemeCountIdentifier = str(foundPhonemeCounter).zfill(3)
					newSubDirectory = pathToTimestampsNew + "/" + phonemeCountIdentifier
					createDir(newSubDirectory)
					# Extract timestamps for phonemeTimeWindow and write them to new timestamps.txt
					newTimestamps = newSubDirectory + "/timestamps.txt"
					with open(newTimestamps, "w") as newTimestamps:
						####################################
						# Extract found phoneme(timestamp) #
						####################################
						contentToWrite = "_"+" " \
						+str(round(float(timestampsArray[lineCounter][1]), 3))+" " \
						+str(round(float(timestampsArray[lineCounter][2]), 3))+" " \
						+str(round(float(timestampsArray[lineCounter][3]), 3))+" " \
						+str(round(float(timestampsArray[lineCounter][4]), 3))+" " \
						+str(round(float(timestampsArray[lineCounter][5]), 3))+" " \
						+str(round(float(timestampsArray[lineCounter][6]), 3))+'\n'
						# label
						# startTime
						# endTime
						# duration
						# startFrame
						# midFrame
						# endFrame
						newTimestamps.write(contentToWrite)
						########################################
						# Extract phoneme(timestamps) in front #
						########################################
						indexOfFoundPhoneme = lineCounter
						# Set currentTimeCounter to the lower end of the found phoneme
						#currentTimeCounter = float(timestampsArray[lineCounter][1])
						# New index to walk down from found phoneme until beginning of timewindow has been reached
						lineIndex = lineCounter - 1

						while (lineIndex >= 0):
							contentToWrite = str(timestampsArray[lineIndex][0])+" " \
							+str(round(float(timestampsArray[lineIndex][1]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][2]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][3]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][4]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][5]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][6]), 3))+'\n'
							lineIndex -= 1
							newTimestamps.write(contentToWrite)
							#if (lineIndex >= 0):
							#	currentTimeCounter = float(timestampsArray[lineIndex][1])
						#######################################
						# Extract phoneme(timestamps) in back #
						#######################################
						# Set currentTimeCounter to the higher end of the found phoneme
						#currentTimeCounter = float(timestampsArray[lineCounter][2])
						# New index to walk up from found phoneme until ending of timewindow has been reached
						lineIndex = lineCounter + 1
						while (lineIndex < len(timestampsArray) ):
							contentToWrite = str(timestampsArray[lineIndex][0])+" " \
							+str(round(float(timestampsArray[lineIndex][1]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][2]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][3]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][4]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][5]), 3))+" " \
							+str(round(float(timestampsArray[lineIndex][6]), 3))+'\n'
							lineIndex += 1
							newTimestamps.write(contentToWrite)
						#if (lineIndex < len(timestampsArray) ):
						#	currentTimeCounter = float(timestampsArray[lineIndex][2])
			# Increase lineCounter to check the next timestamp-line in the read timestamps
			lineCounter += 1
		if (foundPhonemeCounter == 0):
			print("This videoclip contains zero occurences of the phoneme " + str(phonemeName))


getPhonemeTimestamps()
