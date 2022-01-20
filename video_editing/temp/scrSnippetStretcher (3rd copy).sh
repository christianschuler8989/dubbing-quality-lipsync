#LABELS=["a","e","i","o","u","y","aI","aU"]
LABELS="a e i o u y aI aU"
MAINLABLE='o'
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
	PATHOUT=$MYPATH/$label/0.90/
	for filename in $(ls $PATHIN)
	do
		if [[ $filename == *$label.wav ]]
		then 
			sox $PATHIN/$filename $PATHOUT/$filename speed 0.90
		else
			cp $PATHIN/$filename $PATHOUT/$filename
		fi
	done;
done;

for label in $LABELS
do
	PATHIN=$MYPATH/$label/dissected/
	PATHOUT=$MYPATH/$label/0.95/
	for filename in $(ls $PATHIN)
	do
		if [[ $filename == *$label.wav ]]
		then 
			sox $PATHIN/$filename $PATHOUT/$filename speed 0.95
		else
			cp $PATHIN/$filename $PATHOUT/$filename
		fi
	done;
done;

for label in $LABELS
do
	PATHIN=$MYPATH/$label/dissected/
	PATHOUT=$MYPATH/$label/1.05/
	for filename in $(ls $PATHIN)
	do
		if [[ $filename == *$label.wav ]]
		then 
			sox $PATHIN/$filename $PATHOUT/$filename speed 1.05
		else
			cp $PATHIN/$filename $PATHOUT/$filename
		fi
	done;
done;


for label in $LABELS
do
	PATHIN=$MYPATH/$label/dissected/
	PATHOUT=$MYPATH/$label/1.10/
	for filename in $(ls $PATHIN)
	do
		if [[ $filename == *$label.wav ]]
		then 
			sox $PATHIN/$filename $PATHOUT/$filename speed 1.10
		else
			cp $PATHIN/$filename $PATHOUT/$filename
		fi
	done;
done;
