# Specify for which vowels
element = "o"
fps = 25
factor = 1.50

# Input of countedFrames: [label, start, end, duration, frames, tempDur, tempFrames, startFrame, endFrame, midFrame]
pathOfInputTextfile = "./merkel/2021-01-09/vowels/"+element+"/video/countedFrames/1.00.txt"
# Output of modifiedFrames: [label, start, end, duration, frames, tempDur, tempFrames, startFrame, endFrame, midFrame]
pathOfOutputTextfile = "./merkel/2021-01-09/vowels/"+element+"/video/countedFrames/"+str(factor)+".txt"

# Start "counting" the frames of each vowel-appearance
def getModifiedFrames():
	# Read the "timestamps.txt"
	with open(pathOfInputTextfile) as f:
		countedFrames = f.readlines()

	# Gather the countedFrames in a list
	unModifiedFrames = [line.split() for line in countedFrames]

	modifiedFrames = []
	
	
	# Type-conversions and calculating of the new duration
	for phoneme in unModifiedFrames: 
		# From string to float
		#phoneme[1] = float(phoneme[1]) # Start-Time
		#phoneme[2] = float(phoneme[2]) # End-Time
		#phoneme[3] = float(phoneme[3]) # Duration
		#phoneme[4] = float(phoneme[4]) # Frames
		#phoneme[5] = float(phoneme[5]) # tempDur
		#phoneme[6] = float(phoneme[6]) # tempFrames
		#phoneme[7] = float(phoneme[7]) # startFrame
		#phoneme[8] = float(phoneme[8]) # endFrame
		#phoneme[9] = float(phoneme[9]) # midFrame
		
		# NewTempDuration = Duration * appliedFactor
		#phoneme[5] = phoneme[3] * factor # tempDur
		

		modifiedFrames.append([phoneme[0], float(phoneme[3]), float(phoneme[5]), float(phoneme[6]), 0.0, float(phoneme[9])])
		# modifiedFrames = [ [label, duration, tempDuration, tempFrames, tempEvalDuration, midFrame] ]
		
	# Calculate additional required frames and distribute them
	durationOfAll = 0.0 # Duration of whole video
	durationOfElements = 0.0 # Duration of all "element"-labeled phonemes 
	durationOfElementsNew = 0.0 # Duration of all "element"-labeled phonemes after modification
	for phoneme in modifiedFrames:
		if phoneme[0] == element:
			durationOfElements += phoneme[1] # Sum the original duration of phonemes
			newDurationOfThisPhoneme = phoneme[1] * factor 
			durationOfAll += newDurationOfThisPhoneme
			durationOfElementsNew += newDurationOfThisPhoneme # Sum all the new durations together
			phoneme[2] = newDurationOfThisPhoneme # Noting the new duration of this phoneme for now
			# durationOfElementsNew += phoneme[5] # Alternatively by multiplying old duration with factor
			phoneme[4] = newDurationOfThisPhoneme # Additional marker to evaluate distribution after addition of frames
		else:
			durationOfAll += phoneme[1]
	# modifiedFrames = [ [label, duration, tempDuration, tempFrames, tempEvalDuration ] ]
			
	addedDuration = durationOfElementsNew - durationOfElements
	framesToAdd = addedDuration * fps
	
	# Calculate ratio of new frame to newly added duration
	timePerFrame = addedDuration / framesToAdd #TODO: Weird "mathing"... These 3 lines in 1 line?

	for frame in range(int(framesToAdd)):
		# Finding phoneme with longest remaining "tempDuration"
		indexOfLongestPhoneme, maxValue = -1, -1
		for index in range(len(modifiedFrames)):
			if modifiedFrames[index][4] > maxValue:
				indexOfLongestPhoneme, maxValue = index, modifiedFrames[index][4]
		# Alternative with use of numpy-Arrays? 	
		# https://towardsdatascience.com/there-is-no-argmax-function-for-python-list-cd0659b05e49
		#import numpy as np
		#modifiedFramesNumpyArray = np.asarray(modifiedFrames)	
		#for i to int(framesToAdd):
		#	indexOfLongestPhoneme = modifiedFramesNumpyArray.argmax()
		modifiedFrames[indexOfLongestPhoneme][3] += 1 # One frame will be added to this phoneme
		modifiedFrames[indexOfLongestPhoneme][4] -= timePerFrame # Decrease tempEvalDuration to change frame-distribution-priority
		
	

	#################################################
	# Does this even help? 
	# How to get a more precise calculation instead?
	#################################################			
	# Count number of frames extracted from video
	import os, os.path

	dirOfDissectedFrames = "./merkel/2021-01-09/vowels/"+element+"/video/dissected/" # path joining version for other paths
	numberOfFrames = len([name for name in os.listdir(dirOfDissectedFrames) if os.path.isfile(os.path.join(dirOfDissectedFrames, name))])
	# print len([name for name in os.listdir('.') if os.path.isfile(name)]) # simple version for working with CWD



	# Open outputTextfile to write the countedFrames into it
	textFile = open(pathOfOutputTextfile, "w") # "w" = writing ; "a" = appending ; "r" = reading
		
	for phoneme in modifiedFrames:
		contentToWrite = str(phoneme[0])+" "+str(phoneme[1])+" "+str(phoneme[2])+" "+str(phoneme[3])+" "+str(phoneme[4])+" "+str(phoneme[5])+'\n'
		textFile.write(contentToWrite)

	# Close outputTextfile after writing
	textFile.close()


getModifiedFrames()
