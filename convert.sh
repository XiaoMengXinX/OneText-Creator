file=$1
out=$2
i=0
nub=$(cat "$file" | grep -o hitokoto | wc -l)
today=$(date +%Y.%m.%d)

while [ $i -lt $nub ]
do

text0=$(cat $file | jq -r .[$i].hitokoto | tr -d "\n" )
text=$(echo ${text0//'"'/'\"'})

by=$(cat $file | jq -r .[$i].from)

from=$(cat $file | jq -r .[$i].creator)

time_unix=$(cat $file | jq -r .[$i].created_at | sed $'s/\"//g')

if [ -z $time_unix ]
then
time="$today"
else
time=$(date -d @$time_unix "+%Y.%m.%d")
fi

bash onetext.sh $2 "$text" "$by" "$from" "$time"

echo $i.$text $time_unix $time

i=$(($i+1))

done