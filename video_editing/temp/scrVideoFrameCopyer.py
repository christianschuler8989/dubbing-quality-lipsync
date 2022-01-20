# Specify for which vowels
element = "o"
fps = 25
factor = 1.50

# Input of modifiedFrames: [label, duration, tempDur, tempFrames, tempEvalDur, midFrame]
pathOfInputTextfile = "./merkel/2021-01-09/vowels/"+element+"/video/countedFrames/"+str(factor)+".txt"

# Start copying the frames of each vowel-appearance
def copyFrames():
	# Read the "timestamps.txt"
	with open(pathOfInputTextfile) as f:
		countedFrames = f.readlines()

	# Gather the countedFrames in a list
	modifiedFrames = [line.split() for line in countedFrames]

	framesToCopy = []
	
	# Type-conversions and calculating of the new duration
	for phoneme in modifiedFrames: 
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
		
		if phoneme[0] == element:
			framesToCopy.append([round(float(phoneme[5])), round(float(phoneme[3]))]) # What frame to copy & how often to copy it 
		# framesToCopy = [ [midFrame, tempFrames] ]
	
	
	# Path to input-frames
	pathOfInputFrames = "./merkel/2021-01-09/vowels/"+element+"/video/dissected/"
	
	# Path to output-frames
#	pathOfOutputFrames = "./merkel/2021-01-09/vowels/"+element+"/video/"+str(factor)+"/"
# What the hell? "str(1.50)" = 1.5 . . . . Why the rounding?!
	pathOfOutputFrames = "./merkel/2021-01-09/vowels/"+element+"/video/"+"1.50"+"/"
	
	# Copying files with python
	# https://stackoverflow.com/questions/123198/how-can-a-file-be-copied
	from shutil import copyfile
	import os, os.path
	
	# Copy all the original frames into the output-directory
	for frame in os.listdir(pathOfInputFrames):
		copyfile(pathOfInputFrames+frame, pathOfOutputFrames+frame)
	
	# TODO: Add a trailing "0" to every filename for correct ordering while combining the frames with ffmpeg
	# Order of files is kinda weird:
	# 0001.png
	# 0001_.png
	# 0001a.png
	# 0002.png
	# 00010.png
	# 00011.png
	# namingCharSet = ['a', 'b', 'c', 'd', ...]
	# Range for chars 
	# https://stackoverflow.com/questions/7001144/range-over-character-in-python
	#def char_range(c1, c2):
    # """Generates the characters from `c1` to `c2`, inclusive."""
	#	for c in range(ord(c1), ord(c2)+1):
	#	    yield chr(c)
	#namingCharSet = char_range('a', 'z')
	namingCharSet = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
	
	
	# Add additional copies for the specified elements
	for phoneme in framesToCopy:
		identifierBasic = str(phoneme[0]) # e.g. 174
		identifier = identifierBasic.zfill(6) # e.g. 000174
		filenameInput = identifier + ".png"
		for numberToAdd in range(phoneme[1]):
			filenameOutput = identifier + namingCharSet[numberToAdd] + ".png"
			copyfile(pathOfInputFrames+filenameInput, pathOfOutputFrames+filenameOutput)
		


copyFrames()
