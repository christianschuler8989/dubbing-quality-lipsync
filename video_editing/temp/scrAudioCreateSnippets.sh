#LABELS=["a","e","i","o","u","y","aI","aU"]
LABELS=["a"]
LABELMAIN='aI'
# timestamps='timestamps.txt'
timestamps=../material/merkel/2021-01-09-0to13/vowels/$LABELMAIN/timestamps.txt
n=1
while read line; do
#echo "Line No. $n : $line"
LABEL=$(echo $line| cut -d' ' -f 1)
START=$(echo $line| cut -d' ' -f 2)
END=$(echo $line| cut -d' ' -f 3)
DURATION=$(echo $line| cut -d' ' -f 4)
sox ../material/merkel/2021-01-09-0to13/audio.wav ../material/merkel/2021-01-09-0to13/vowels/$LABELMAIN/audio/dissected/`printf %04d $n`-$START$LABEL.wav trim $START $DURATION
n=$((n+1))
done < $timestamps

# timestamps=$(cat timestamps.txt)
# for interval in $timestamps; do
# echo $interval
# done
