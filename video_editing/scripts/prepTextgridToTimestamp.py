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

# /..../editing/scripts/../material/mind/pizzaEnglish/
myPathTextgrid = sys.argv[1]
textgridFile = myPathTextgrid + 'audio.TextGrid'

# /..../editing/scripts/../material/mind/pizzaEnglish/preliminaries/
myPathTimestamps = sys.argv[2]
timestampsFile = myPathTimestamps + 'timestampsAll.txt'

myFPS = int(sys.argv[3])

# Read TextGrid of this video-clip
try:
    myGrid = textgrids.TextGrid(textgridFile)
except (textgrids.ParseError, textgrids.BinaryError):
    print('Not a recognized file format!')


def getPhonemTimes():
    text_file = open(timestampsFile, "w")

    interval_min = 0.0
    interval_max = 0.0
    interval_dur = 0.0

    print("Reading from audio.TextGrid and writing in timestampsAll.txt:")
    for interval in myGrid['MAU']:
        # Add the interval of found 'element'
        # Convert Praat to Unicode in the label
        label = interval.text.transcode()
        # Print label and interval duration, CSV-like
        interval_min = round(interval.xmin, 5)
        interval_max = round(interval.xmax, 5)
        interval_dur = round(interval.dur, 5)
        startFrame   = round( (interval.xmin * myFPS), 5)
        midFrame     = round( ((interval.xmin + (interval_dur / 2)) * myFPS), 5)
        endFrame     = round( (interval.xmax * myFPS), 5)

        print('{} {} {} {} {} {} {}'.format(label, interval_min, interval_max, interval_dur, startFrame, midFrame, endFrame))
        content_to_write = str(label)+" "+str(interval_min)+" "+str(interval_max)+" "+str(interval_dur)+" "+str(startFrame)+" "+str(midFrame)+" "+str(endFrame)+'\n'
        text_file.write(content_to_write)

        # 'Reset' the values for the next loop
        interval_min = interval_max
        interval_max = interval_max
        interval_dur = 0.0
    text_file.close()


getPhonemTimes()
