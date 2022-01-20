
GLOBPATTERN='./merkel/2021-01-09/vowels/o/video/1.50/*.png'
PATHOUTPUT='./merkel/2021-01-09/outputVideo/1.50.mp4'

ffmpeg -framerate 25 -pattern_type glob -i $GLOBPATTERN $PATHOUTPUT

