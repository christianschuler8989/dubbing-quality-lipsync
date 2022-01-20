# Specify for which vowels
phonemes = ["a", "o", "u", "aI"]
fps = 25

def getVowelFrames():
	for element in phonemes:
		# Input of timestamps: "label, startTime, endTime, duration"
		pathOfInputTextfile = "../merkel/2021-01-09-0to13/vowels/"+element+"/timestamps.txt"
		
		for factor in 
		# Output of countedFrames: [label, start, end, duration, frames, tempDur, tempFrames, startFrame, endFrame, midFrame]
		pathOfOutputTextfile = "../merkel/2021-01-09-0to13/vowels/"+element+"/video/countedFrames/1.00.txt"

		# Start "counting" the frames of each vowel-appearance

		# Read the "timestamps.txt"
		with open(pathOfInputTextfile) as f:
		# read() – read all text from a file into a string. This method is useful if you have a small file and you want to manipulate the whole text of that file.
		# readline() – read the text file line by line and return all the lines as strings.
		# readlines() – read all the lines of the text file and return them as a list of strings.
			timestamps = f.readlines()

		# Gather the timestamps in a list
		vowelFrames = [line.split() for line in timestamps]

		# Open outputTextfile to write the countedFrames into it
		textFile = open(pathOfOutputTextfile, "w") # "w" = writing ; "a" = appending ; "r" = reading
				
		# Type-conversions and calculating/counting the number of frames
		for stamp in vowelFrames: 
			# From string to float
			stamp[1] = float(stamp[1]) # Start-Time
			stamp[2] = float(stamp[2]) # End-Time
			stamp[3] = float(stamp[3]) # Duration
			# Number of Frames = seconds * fps
			stamp.append(stamp[3] * fps) # Number of Frames
			stamp.append(0.0) # "tempDuration" for later processing of frame-distribution
			stamp.append(0) # "tempFrames" as number of added frames
			stamp.append(stamp[1] * fps) # startFrame : only calculated and might not be accurate enough
			stamp.append(stamp[2] * fps) # endFrame
			stamp.append(stamp[7] + (stamp[8] - stamp[7])/2 ) # midFrame = startFrame + (half of frames)
			# stamp = [label, start, end, duration, frames, tempDur, tempFrames, startFrame, endFrame, midFrame]

			contentToWrite = str(stamp[0])+" "+str(stamp[1])+" "+str(stamp[2])+" "+str(stamp[3])+" "+str(stamp[4])+" "+str(stamp[5])+" "+str(stamp[6])+" "+str(stamp[7])+" "+str(stamp[8])+" "+str(stamp[9])+'\n'
			textFile.write(contentToWrite)

		# Close outputTextfile after writing
		textFile.close()


getVowelFrames()
