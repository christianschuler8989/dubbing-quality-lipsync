
import textgrids
# https://pypi.org/project/praat-textgrids/

path = '../material/merkel/2021-01-09-0to13/'

tgFile = path + 'mausGeneral/audio.TextGrid'

try:
    myGrid = textgrids.TextGrid(tgFile)
except (textgrids.ParseError, textgrids.BinaryError):
    print('Not a recognized file format!')


def getPhonemTimes(vowels=["a","e","i","o","u","y","aI","aU"]):
	for element in vowels:
		#name_of_textfile = file + ".txt"
		path_of_textfile = path + "/phonem/" + element + "/"
		name_of_textfile = "timestamps.txt"
		argument = path_of_textfile + name_of_textfile
		text_file = open(argument, "w")

		interval_min = 0.0
		interval_max = 0.0
		interval_dur = 0.0
		print("Reading from TextGrid: interval points of " + element)
		for interval in myGrid['MAU']:
			if interval.text.transcode() != element:
				interval_max = interval.xmax
				interval_dur += interval.dur
			else:
		    	# interval.text.transcode() == element:
				# Add all the intervals until here- in combined form
				label = "_"
				print('{} {} {} {}'.format(label, interval_min, interval_max, interval_dur))
				content_to_write = str(label)+" "+str(interval_min)+" "+str(interval_max)+" "+str(interval_dur)+'\n'
				text_file.write(content_to_write)
				
				# Add the interval of found 'element'
				# Convert Praat to Unicode in the label
				label = interval.text.transcode()
				# Print label and interval duration, CSV-like
				interval_min = interval.xmin
				interval_max = interval.xmax
				interval_dur = interval.dur
				print('{} {} {} {}'.format(label, interval_min, interval_max, interval_dur))
				content_to_write = str(label)+" "+str(interval_min)+" "+str(interval_max)+" "+str(interval_dur)+'\n'
				text_file.write(content_to_write)
				
				# 'Reset' the values for the next loop
				interval_min = interval_max
				interval_max = interval_max
				interval_dur = 0.0
			
		if myGrid['MAU'][-1] != element:
		    # Add the last intervals
			label = "_"
			print('{} {} {} {}'.format(label, interval_min, interval_max, interval_dur))
			content_to_write = str(label)+" "+str(interval_min)+" "+str(interval_max)+" "+str(interval_dur)+'\n'
			text_file.write(content_to_write)
			
		text_file.close()

# Get a list of all phonemes contained in the used TextGrid
def getPhonemNames():
	phonemNames = []
	for interval in myGrid['MAU']:
		if interval.text.transcode() in phonemNames:
			pass
		else:
			phonemNamens.append(interval.text.transcode())
	return phonemNames
		
	
phonemNames = getPhonemNames()

getPhonemTimes(phonemNames)



