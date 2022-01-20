#LABELS=["a","e","i","o","u","y","aI","aU"]
LABELS="a e i o u y aI aU"
MAINLABLE='o'
#FACTORS={0.90,0.95,1.05,1.10}
FACTORS=($(seq 0.90 0.05 1.10)) # seq FIRST STEP LAST
STRETCHFACTOR=1.01
#PATH='./vowels/$MAINLABEL/dissected'
#PATHSTRETCH='$PATH''/''$STRETCHFACTOR'
#for filename in $(ls $PATH'/')
#do
#if [[ filename == *"$MAINLABEL"* ]]
#then sox $PATH/filename $PATHSTRETCH/filename speed $STRETCHFACTOR 
#fi
#done;
PATH='./merkel/2021-01-09/vowels'
for label in $LABELS
do
	for factor in $FACTORS
	do
		PATHIN=$PATH/$label/dissected/
		PATHOUT=$PATH/$label/$label$factor/
		echo $PATHIN
		echo $PATHOUT
		mkdir "$PATHOUT"
		for filename in $(ls $PATHIN)
		do
			if [[ $filename == *$label* ]]
				echo "Found one"
				then sox $PATHIN/$filename $PATHOUT/$filename speed $factor
			fi
		done;
	done;
done;

# You can use (* wildcards) outside a case statement, too, if you use double brackets:


