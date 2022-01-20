# LABELS="a e i o u y aI aU"

LABELS="a o u aI"

MYPATH='../material/merkel/2021-01-09-0to13/vowels'

for label in $LABELS
do
	LANG=en seq -f '%1.2f' 0.50 0.05 1.50 | \
	while read factor
	do
		PATHIN=$MYPATH/$label/audio/adj$factor
		PATHOUT=$MYPATH/../outputAudio
		for filename in $(ls $PATHIN)
		do
			sox $(ls $PATHIN/*.wav | sort) $PATHOUT/merkel2021-01-09-0to13vowels$label$factor\.wav
		done;
	done;
done;
