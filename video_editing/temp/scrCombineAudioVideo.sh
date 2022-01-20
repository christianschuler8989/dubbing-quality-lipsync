#LABELS="a e i o u y aI aU"
PATHIN='./merkel/2021-01-09/outputAudio'
PATHINVID='./merkel/2021-01-09/outputVideo'
PATHOUT='./merkel/2021-01-09/output'

# Format of audioOutputs:
# merkel2021-01-09vowelso1.50.wav
# videoclip phonemetyp phoneme stretchfactor .wav

# Format of videoOutputs:
# 
#

# TODO: Here a for-loop with two indexes? Or searching for corresponding file for each input "where might be the video for this audio?"
for filename in $(ls $PATHIN)
do
#	ffmpeg -i $PATHINVID/video.mp4 -i $PATHIN/$filename -c:v copy -map 0:v:0 -map i:a:0 $PATHOUT/$filename.mp4
	#ffmpeg -i $PATHINVID/video.mp4 -i $PATHIN/$filename -c:v copy -c:a aac $PATHOUT/$filename.mp4
	ffmpeg -i $PATHINVID/video.mp4 -i $PATHIN/$filename -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 $PATHOUT/$filename.mp4
done;


# This works!
#	ffmpeg -i video.mp4 -i snippet0.0_.wav -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 output.mp4
