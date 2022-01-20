# Seperates video to single frames (25 fps assumed)

# Iterate over all the different videoclips ? Somehow?
MYPATH='../material/merkel/2021-01-09-0to13'

ffmpeg -i $MYPATH/video.mp4 -vf fps=25 $MYPATH/vowels/videoFrames/%04d.png
















#for phoneme in $PHONEMES
#do
#	mkdir -p $MYPATH/$phoneme/audio/dissected;
#	mkdir -p $MYPATH/$phoneme/video/dissected;
#done;


