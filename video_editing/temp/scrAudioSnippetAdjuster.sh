# Stretching of aduio changed the Samples rate and the Bit rate of the shorter snippets
# Samples rate 44100 Hz -> 22050 Hz
# Bit rate 705 kbps -> 352 kbps


# LABELS="a e i o u y aI aU"
LABELS="a o u aI"

MYPATH='../material/merkel/2021-01-09-0to13/vowels'

for label in $LABELS
do
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do	
		PATHIN=$MYPATH/$label/audio/$factor
		PATHOUT=$MYPATH/$label/audio/adj$factor
		for filename in $(ls $PATHIN)
		do
			sox $PATHIN/$filename -r 44100 $PATHOUT/$filename
		done;
	done;
done;


# echo $(ls ./merkel/2021-01-09/vowels/o/0.90/*.wav | sort -n)


