LABELS="a e i o u y aI aU"
FACTOR1=0.90
FACTOR2=0.95
FACTOR3=1.05
FACTOR4=1.10
MYPATHONE='./merkel/2021-01-09'
MYPATHTWO='/vowels'
MYPATH=$MYPATHONE$MYPATHTWO
for label in $LABELS
do
	PATHIN=$MYPATH/$label/$FACTOR1/
	PATHOUT=$MYPATHONE/outputAudio
	sox $PATHIN/*.wav $PATHOUT/merkel2021-01-09vowels$label$FACTOR1\.wav
done;

for label in $LABELS
do
	PATHIN=$MYPATH/$label/$FACTOR2/
	PATHOUT=$MYPATHONE/outputAudio
	sox $PATHIN/*.wav $PATHOUT/merkel2021-01-09vowels$label$FACTOR2\.wav
done;

for label in $LABELS
do
	PATHIN=$MYPATH/$label/$FACTOR3/
	PATHOUT=$MYPATHONE/outputAudio
	sox $PATHIN/*.wav $PATHOUT/merkel2021-01-09vowels$label$FACTOR3\.wav
done;

for label in $LABELS
do
	PATHIN=$MYPATH/$label/$FACTOR4/
	PATHOUT=$MYPATHONE/outputAudio
	sox $PATHIN/*.wav $PATHOUT/merkel2021-01-09vowels$label$FACTOR4\.wav
done;
