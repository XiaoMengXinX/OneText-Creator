#!/bin/bash
file=$1
text=$2
by=$3
from=$4
collect_time=$5
write_time=$6

if [ -z "$1" ] || [ "$1" = '-h' ] || [ "$1" = '--help' ]
then
    echo "USAGE : bash $0 {infile} [text] [by] [from] [collect time] [write time]"
    echo 'If there is no "write time", skip.'
    echo 'Use -h or --help to get help.'
    exit 0
fi

function format() {
	cat "$file" | jq >"$file.bak"
	mv "$file.bak" "$file"
}

if [ "$1" = 'format' ]
then
	file=$2
		if [ ! -f "$file" ] || [ -z "$file" ]
		then
			echo "File doesn't exist."
			exit 1
		else
			format
			exit 1
		fi
fi

if [ -z "$2" ]
then
    read -p "Type in your text " text
fi

if [ -z "$3" ]
then
    read -p "Type in original author of the text " by
fi

if [ -z "$4" ]
then
    read -p "Type in where the text from " from
fi

if [ -z "$5" ]
then
    read -p "Type in when the text was collected (yyyy.mm.dd) " collect_time
    read -p "Type in when the text was written " write_time
fi

if [ -z "$write_time" ]
    then
        time="\"$collect_time\""
    else
        time="\"$collect_time\",\"$write_time\""
fi

if [ ! -f "$file" ]
then
	touch "$file"
	cat >> $file <<- EOF
	[
	{
	"text": "$text",
	"by": "$by",
	"from": "$from",
	"time": [$time]
	}
	]
	EOF
else
    sed -i '$d' $file
    sed -i '$d' $file
    echo '},' >> $file
	cat >> $file <<- EOF
	{
	"text": "$text",
	"by": "$by",
	"from": "$from",
	"time": [$time]
	}
	]
	EOF
fi
