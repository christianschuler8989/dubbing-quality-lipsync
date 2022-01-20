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

pathTimewindow = sys.argv[1]
# Like editing/material/movie/clip/phonemes/exploration/sec01
mySize = float(sys.argv[2]) # For "phoneme-windows" instead of "second-windows" this has to be int() instead!
# Like 2 or 3
pathToTimestampsAll = sys.argv[3]
pathTimestampsAll = pathToTimestampsAll + '/timestampsAll.txt'
# Like editing/material/movie/clip/preliminaries
phonemeName = sys.argv[4]
# Like a or f
operationalMode = sys.argv[5]
# Like "blind" or "sight"

##############################################################
# Read interesting-Phonemes from manually provided .txt file #
##############################################################
if operationalMode == "sight":
	currentInterestingPhonemesArray = []
	pathInterestingPhonemes = pathToTimestampsAll + "/.."
	fileInterestingPhonemes = pathInterestingPhonemes + "/interestingPhonemes.txt"

	with open(fileInterestingPhonemes, "r") as interestingPhonemesAll:
		# Read all the phonemes from interestingPhonemes.txt
		interestingPhonemes = interestingPhonemesAll.readlines()
		interestingPhonemesArray = [line.split() for line in interestingPhonemes]
		# Only keep the interestingPhonemes that correspond to the current phonemeName
		currentInterestingPhonemesArray = [phoneme for phoneme in interestingPhonemesArray if phoneme[0] == phonemeName]
		print(currentInterestingPhonemesArray)



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
def getPhonemeTimesSeconds():
    with open(pathTimestampsAll, "r") as timestampsAll:
        timestamps = timestampsAll.readlines()
        timestampsArray = [line.split() for line in timestamps]
        lineCounter = 0
        foundPhonemeCounter = 0
		# Look through all phoneme(timestamps)
        for timestamp in timestampsArray:
			# To find phonemes with label == phonemeName
            if timestamp[0] == phonemeName:
                foundPhonemeCounter += 1
				########################################################################################
				# Distinguishing between "blind" (all the phonemes) and "sight" (only the interesting) #
				########################################################################################
				# Boolean for testing for interestingPhoneme
                phonemeIsInteresting = [phonemeName, str(foundPhonemeCounter)] in currentInterestingPhonemesArray
                #print("My Boolean is " + str(phonemeIsInteresting)) #debugging
                if (operationalMode == "blind" or (operationalMode == "sight" and phonemeIsInteresting)):
	                # Create directory for timestamps.txt and subdirectories
	                phonemeIdentifier = str(foundPhonemeCounter).zfill(3)
	                newSubDirectory = pathTimewindow + "/" + phonemeIdentifier
	                createDir(newSubDirectory)
	                # Extract timestamps for phonemeTimeWindow and write them to new timestamps.txt
	                newTimestamps = newSubDirectory + "/timestamps.txt"
	                with open(newTimestamps, "w") as newTimestamps:
	                    minimumTimeOfWindow = round(float(timestamp[1]), 3) - mySize # startTime - mySize
	                    maximumTimeOfWindow = round(float(timestamp[2]), 3) + mySize # endTime + mySize

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
	                    # Set currentTimeCounter to the lower end of the found phoneme
	                    currentTimeCounter = float(timestampsArray[lineCounter][1])
	                    # New index to walk down from found phoneme until beginning of timewindow has been reached
	                    lineIndex = lineCounter - 1

	                    while (minimumTimeOfWindow < currentTimeCounter) & (lineIndex >= 0):
	                        contentToWrite = str(timestampsArray[lineIndex][0])+" " \
	                        +str(round(float(timestampsArray[lineIndex][1]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][2]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][3]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][4]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][5]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][6]), 3))+'\n'

	                        lineIndex -= 1
	                        newTimestamps.write(contentToWrite)
	                        if (lineIndex >= 0):
	                            currentTimeCounter = float(timestampsArray[lineIndex][1])

	#######################################
	# Extract phoneme(timestamps) in back #
	#######################################
	                    # Set currentTimeCounter to the higher end of the found phoneme
	                    currentTimeCounter = float(timestampsArray[lineCounter][2])
	                    # New index to walk up from found phoneme until ending of timewindow has been reached
	                    lineIndex = lineCounter + 1

	                    while (maximumTimeOfWindow > currentTimeCounter) & (lineIndex < len(timestampsArray) ):
	                        contentToWrite = str(timestampsArray[lineIndex][0])+" " \
	                        +str(round(float(timestampsArray[lineIndex][1]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][2]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][3]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][4]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][5]), 3))+" " \
	                        +str(round(float(timestampsArray[lineIndex][6]), 3))+'\n'

	                        lineIndex += 1
	                        newTimestamps.write(contentToWrite)
	                        if (lineIndex < len(timestampsArray) ):
	                            currentTimeCounter = float(timestampsArray[lineIndex][2])
            # Increase lineCounter to check the next timestamp-line in the read timestamps
            lineCounter += 1
    if (foundPhonemeCounter == 0):
        print("This videoclip contains zero occurences of the phoneme " + str(phonemeName))



###########################################################################################
# Extracting phoneme-times with a window of mySize many phonemes arount the found phoneme #
###########################################################################################
def getPhonemeTimesPhonemes():
    with open(pathTimestampsAll, "r") as timestampsAll:
        timestamps = timestampsAll.readlines()
        timestampsArray = [line.split() for line in timestamps]
        lineCounter = 0
        foundPhonemeCounter = 0
        for timestamp in timestampsArray:
            if timestamp[0] == phonemeName:
                if lineCounter < mySize:
                    print("Found phoneme is too close to begin of clip.")
                else:
                    foundPhonemeCounter += 1
                    # Create directory for timestamps.txt and subdirectories
                    phonemeIdentifier = str(foundPhonemeCounter).zfill(3)
                    newSubDirectory = pathTimewindow + "/" + phonemeIdentifier
                    createDir(newSubDirectory)
                    # Extract timestamps for phonemeTimeWindow and write them to new timestamps.txt
                    newTimestamps = newSubDirectory + "/timestamps.txt"
                    with open(newTimestamps, "w") as newTimestamps:
                        for index in range(lineCounter - mySize, lineCounter + mySize + 1): # A window of size mySize around the found phoneme
                            # Formatting of content to write (must be string, not list)
                            contentToWrite = str(timestampsArray[index][0])+" " \
                                            +str(round(float(timestampsArray[index][1]), 3))+" " \
                                            +str(round(float(timestampsArray[index][2]), 3))+" " \
                                            +str(round(float(timestampsArray[index][3]), 3))+" " \
                                            +str(round(float(timestampsArray[index][4]), 3))+" " \
                                            +str(round(float(timestampsArray[index][5]), 3))+" " \
                                            +str(round(float(timestampsArray[index][6]), 3))+'\n'
                                            # label
                                            # startTime
                                            # endTime
                                            # duration
                                            # startFrame
                                            # midFrame
                                            # endFrame
                            newTimestamps.write(contentToWrite)
            lineCounter += 1


#getPhonemeTimesPhonemes()
getPhonemeTimesSeconds()
