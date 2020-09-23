#!/bin/bash
file=$1
text=$2
text0=$2
by=$3
from=$4
collect_time=$5

if [ -z "$1" ] || [ "$1" = '-h' ] || [ "$1" = '--help' ]
then
    echo "USAGE : bash $0 {infile}"
    echo "        bash $0 {infile} [text] [by] [from] [collect time] [-w write time] [-u uri]"
    echo "        bash $0 format {infile}"
    echo 'Use -h or --help to get help.'
    exit 0
fi

function format() {
	cat "$file" | jq . > "$file.tmp"
	if [ ! -s "$file.tmp" ]
	then
		echo "Invaid json format.File unchanged."
		rm "$file.tmp"
		exit 0
	else
		mv "$file.tmp" "$file"
	fi
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
    read -p "Type in when the text was written.(Press enter to skip) " write_time
fi

shift 5
while getopts ":u:w:" opt
do
	case $opt in
		u)
		uri="$OPTARG";;
		w)
		write_time="$OPTARG";;
	esac
done

if [ -z "$write_time" ]
    then
        time="\"$collect_time\""
    else
        time="\"$collect_time\",\"$write_time\""
fi

if [ -z "$text0" ]
    then
	read -p "Type in the uri of the sentence.(Press enter to skip) " uri
fi

if [ "$uri" ]
    then
	uri_json="\"uri\": \""$uri"\","
fi

if [ ! -f "$file" ] || [ ! -s "$file" ]
then
	touch "$file"
	cat >> $file <<- EOF
	[
	{
	"text": "$text",
	"by": "$by",
	"from": "$from",
	$uri_json
	"time": [$time]
	}
	]
	EOF
    format
else
    format
    sed -i '$d' $file
    sed -i '$d' $file
    echo '},' >> $file
	cat >> $file <<- EOF
	{
	"text": "$text",
	"by": "$by",
	"from": "$from",
	$uri_json
	"time": [$time]
	}
	]
	EOF
    format
fi
