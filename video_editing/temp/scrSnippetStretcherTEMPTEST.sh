#LABELS=["a","e","i","o","u","y","aI","aU"]

# Working;
#LABELS="a e i o u y aI aU"

LABELS="o"

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

MYPATH='./merkel/2021-01-09/vowels'
for label in $LABELS
do
	PATHIN=$MYPATH/$label/dissected/
	PATHOUT=$MYPATH/$label/0.50/
	for filename in $(ls $PATHIN)
	do
		if [[ $filename == *$label.wav ]]
		then 
			python3 ./scrTimeStretcher.py -i $PATHIN/$filename -o $PATHOUT/$filename -f 0.5 #-n 4096 #-n => num of FFT bins to use'
		else
			cp $PATHIN/$filename $PATHOUT/$filename
		fi
	done;
done;

MYPATH='./merkel/2021-01-09/vowels'
for label in $LABELS
do
	PATHIN=$MYPATH/$label/dissected/
	PATHOUT=$MYPATH/$label/0.80/
	for filename in $(ls $PATHIN)
	do
		if [[ $filename == *$label.wav ]]
		then 
			python3 ./scrTimeStretcher.py -i $PATHIN/$filename -o $PATHOUT/$filename -f 0.8 #-n 4096 #-n => num of FFT bins to use'
		else
			cp $PATHIN/$filename $PATHOUT/$filename
		fi
	done;
done;

for label in $LABELS
do
	PATHIN=$MYPATH/$label/dissected/
	PATHOUT=$MYPATH/$label/1.50/
	for filename in $(ls $PATHIN)
	do
		if [[ $filename == *$label.wav ]]
		then 
			python3 ./scrTimeStretcher.py -i $PATHIN/$filename -o $PATHOUT/$filename -f 1.50 #-n 4096 
		else
			cp $PATHIN/$filename $PATHOUT/$filename
		fi
	done;
done;

for label in $LABELS
do
	PATHIN=$MYPATH/$label/dissected/
	PATHOUT=$MYPATH/$label/1.20/
	for filename in $(ls $PATHIN)
	do
		if [[ $filename == *$label.wav ]]
		then 
			python3 ./scrTimeStretcher.py -i $PATHIN/$filename -o $PATHOUT/$filename -f 1.20 #-n 4096 
		else
			cp $PATHIN/$filename $PATHOUT/$filename
		fi
	done;
done;
