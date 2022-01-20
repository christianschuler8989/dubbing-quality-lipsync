
VOWELOPEN="a"
VOWELCLOSEMID="e o"
VOWELCLOSE="i u"
VOWELDIPHTHONG="aI aU"

CONSONANTBILABIAL="p b m"
CONSONANTLABIODENTAL="f v"

MYPATH='../material/merkel/2021-01-09-0to13'

mkdir -p $MYPATH/mausG2P;
mkdir -p $MYPATH/mausGeneral;
mkdir -p $MYPATH/outputAudio;
mkdir -p $MYPATH/outputVideo;
mkdir -p $MYPATH/output;
mkdir -p $MYPATH/videoFrames;

mkdir -p $MYPATH/stretch;
mkdir -p $MYPATH/stretch/vowel;
mkdir -p $MYPATH/stretch/consonant;

for element in $VOWELOPEN
do
	mkdir -p $MYPATH/stretch/vowel/open/$element/audio/dissected;
	mkdir -p $MYPATH/stretch/vowel/open/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/stretch/vowel/open/$element/audio/$factor;
		mkdir -p $MYPATH/stretch/vowel/open/$element/audio/adj$factor;
		mkdir -p $MYPATH/stretch/vowel/open/$element/video/$factor;
	done;
done;

for element in $VOWELCLOSEMID
do
	mkdir -p $MYPATH/stretch/vowel/closemid/$element/audio/dissected;
	mkdir -p $MYPATH/stretch/vowel/closemid/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/stretch/vowel/closemid/$element/audio/$factor;
		mkdir -p $MYPATH/stretch/vowel/closemid/$element/audio/adj$factor;
		mkdir -p $MYPATH/stretch/vowel/closemid/$element/video/$factor;
	done;
done;

for element in $VOWELCLOSE
do
	mkdir -p $MYPATH/stretch/vowel/close/$element/audio/dissected;
	mkdir -p $MYPATH/stretch/vowel/close/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/stretch/vowel/close/$element/audio/$factor;
		mkdir -p $MYPATH/stretch/vowel/close/$element/audio/adj$factor;
		mkdir -p $MYPATH/stretch/vowel/close/$element/video/$factor;
	done;
done;

for element in $VOWELDIPHTHONG
do
	mkdir -p $MYPATH/stretch/vowel/diphthong/$element/audio/dissected;
	mkdir -p $MYPATH/stretch/vowel/diphthong/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/stretch/vowel/diphthong/$element/audio/$factor;
		mkdir -p $MYPATH/stretch/vowel/diphthong/$element/audio/adj$factor;
		mkdir -p $MYPATH/stretch/vowel/diphthong/$element/video/$factor;
	done;
done;

for element in $CONSONANTBILABIAL
do
	mkdir -p $MYPATH/stretch/consonant/bilabial/$element/audio/dissected;
	mkdir -p $MYPATH/stretch/consonant/bilabial/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/stretch/consonant/bilabial/$element/audio/$factor;
		mkdir -p $MYPATH/stretch/consonant/bilabial/$element/audio/adj$factor;
		mkdir -p $MYPATH/stretch/consonant/bilabial/$element/video/$factor;
	done;
done;

for element in $CONSONANTLABIODENTAL
do
	mkdir -p $MYPATH/stretch/consonant/labiodental/$element/audio/dissected;
	mkdir -p $MYPATH/stretch/consonant/labiodental/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/stretch/consonant/labiodental/$element/audio/$factor;
		mkdir -p $MYPATH/stretch/consonant/labiodental/$element/audio/adj$factor;
		mkdir -p $MYPATH/stretch/consonant/labiodental/$element/video/$factor;
	done;
done;




mkdir -p $MYPATH/compress;
mkdir -p $MYPATH/compress/vowel;
mkdir -p $MYPATH/compress/consonant;

for element in $VOWELOPEN
do
	mkdir -p $MYPATH/compress/vowel/open/$element/audio/dissected;
	mkdir -p $MYPATH/compress/vowel/open/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/compress/vowel/open/$element/audio/$factor;
		mkdir -p $MYPATH/compress/vowel/open/$element/audio/adj$factor;
		mkdir -p $MYPATH/compress/vowel/open/$element/video/$factor;
	done;
done;

for element in $VOWELCLOSEMID
do
	mkdir -p $MYPATH/compress/vowel/closemid/$element/audio/dissected;
	mkdir -p $MYPATH/compress/vowel/closemid/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/compress/vowel/closemid/$element/audio/$factor;
		mkdir -p $MYPATH/compress/vowel/closemid/$element/audio/adj$factor;
		mkdir -p $MYPATH/compress/vowel/closemid/$element/video/$factor;
	done;
done;

for element in $VOWELCLOSE
do
	mkdir -p $MYPATH/compress/vowel/close/$element/audio/dissected;
	mkdir -p $MYPATH/compress/vowel/close/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/compress/vowel/close/$element/audio/$factor;
		mkdir -p $MYPATH/compress/vowel/close/$element/audio/adj$factor;
		mkdir -p $MYPATH/compress/vowel/close/$element/video/$factor;
	done;
done;

for element in $VOWELDIPHTHONG
do
	mkdir -p $MYPATH/compress/vowel/diphthong/$element/audio/dissected;
	mkdir -p $MYPATH/compress/vowel/diphthong/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/compress/vowel/diphthong/$element/audio/$factor;
		mkdir -p $MYPATH/compress/vowel/diphthong/$element/audio/adj$factor;
		mkdir -p $MYPATH/compress/vowel/diphthong/$element/video/$factor;
	done;
done;

for element in $CONSONANTBILABIAL
do
	mkdir -p $MYPATH/compress/consonant/bilabial/$element/audio/dissected;
	mkdir -p $MYPATH/compress/consonant/bilabial/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/compress/consonant/bilabial/$element/audio/$factor;
		mkdir -p $MYPATH/compress/consonant/bilabial/$element/audio/adj$factor;
		mkdir -p $MYPATH/compress/consonant/bilabial/$element/video/$factor;
	done;
done;

for element in $CONSONANTLABIODENTAL
do
	mkdir -p $MYPATH/compress/consonant/labiodental/$element/audio/dissected;
	mkdir -p $MYPATH/compress/consonant/labiodental/$element/video/countedFrames;
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		mkdir -p $MYPATH/compress/consonant/labiodental/$element/audio/$factor;
		mkdir -p $MYPATH/compress/consonant/labiodental/$element/audio/adj$factor;
		mkdir -p $MYPATH/compress/consonant/labiodental/$element/video/$factor;
	done;
done;








