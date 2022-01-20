PHONEM="a e o i u aI aU p b m f v"

MYPATH='../material/merkel/2021-01-09-0to13'

mkdir -p $MYPATH/mausG2P;
mkdir -p $MYPATH/mausGeneral;
mkdir -p $MYPATH/outputAudio;
mkdir -p $MYPATH/outputVideo;
mkdir -p $MYPATH/output;
mkdir -p $MYPATH/videoFrames;

mkdir -p $MYPATH/stretch/phonem;

for element in $PHONEM
do
	mkdir -p $MYPATH/stretch/phonem/$element/audio/dissected;
	mkdir -p $MYPATH/stretch/phonem/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/stretch/phonem/$element/audio/$factor;
		mkdir -p $MYPATH/stretch/phonem/$element/audio/adj$factor;
		mkdir -p $MYPATH/stretch/phonem/$element/video/$factor;
	done;
done;


mkdir -p $MYPATH/compress/phonem;

for element in $PHONEM
do
	mkdir -p $MYPATH/compress/phonem/$element/audio/dissected;
	mkdir -p $MYPATH/compress/phonem/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/compress/phonem/$element/audio/$factor;
		mkdir -p $MYPATH/compress/phonem/$element/audio/adj$factor;
		mkdir -p $MYPATH/compress/phonem/$element/video/$factor;
	done;
done;






