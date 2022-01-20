#LABELS=["a","e","i","o","u","y","aI","aU"]

# Working;
# LABELS="a e i o u y aI aU"
LABELS="a o u aI"
#FACTORS=0.50 0.55 0.60 0.65 0.70 0.75 0.80 0.85 0.90 0.95 1.05 1.10 1.15 1.20 1.25 1.30 1.35 1.40 1.45 1.50
#LABELS="a"

#MAINLABLE='o'
#FACTORS={0.90,0.95,1.05,1.10}
#FACTORS=($(seq 0.90 0.05 1.10)) # seq FIRST STEP LAST
#echo FACTORS
#echo $FACTORS
#STRETCHFACTOR=1.01
#PATH='./vowels/$MAINLABEL/dissected'
#PATHSTRETCH='$PATH''/''$STRETCHFACTOR'
#for filename in $(ls $PATH'/')
#do
#if [[ filename == *"$MAINLABEL"* ]]
#then sox $PATH/filename $PATHSTRETCH/filename speed $STRETCHFACTOR 
#fi
#done;


# Cool way to get a sequence of floats for the for-loop-head:
# https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch06s13.html
# seq STARTING-VALUE INCREMENT ENDING-VALUE
# Helpfuls "bash seq" examples:
# https://wiki.ubuntuusers.de/seq/

MYPATH='../material/merkel/2021-01-09-0to13/vowels'
for label in $LABELS
do
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do
		PATHIN=$MYPATH/$label/audio/dissected
		PATHOUT=$MYPATH/$label/audio/$factor
		for filename in $(ls $PATHIN)
		do
			if [[ $filename == *$label.wav ]]
			then 
				python3 ./scrAudioTimeStretcher.py -i $PATHIN/$filename -o $PATHOUT/$filename -f $factor #-n 4096 #-n => num of FFT bins to use'
			else
				cp $PATHIN/$filename $PATHOUT/$filename
			fi
		done;
	done;
done;

