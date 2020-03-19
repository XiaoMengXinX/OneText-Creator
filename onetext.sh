#!/bin/sh
if [ -z "$1" ] || [ "$1" = '-h' ] || [ "$1" = '--help' ]
then
    echo 'USAGE : ./onetext.sh {infile} [text] [by] [from] [collect time] [write time]'
    echo 'If there is no "write time", skip.'
    echo 'Use -h or --help to get help.'
    exit 0
fi

file=$1
text=$2
by=$3
from=$4
collect_time=$5
write_time=$6
mark='"'

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

#if [ -z "$6" ]
#then
#    if [ "$6" != none ]
#    then
#        read -p "Type in when the text was written " write_time
#    fi
#fi

if [ ! -f "$file" ]
then
    touch "$file"
    echo '[' >> $file
    echo '{' >> $file
    echo "${mark}text${mark}:${mark}${text}${mark}," >> $file
    echo "${mark}by${mark}:${mark}${by}${mark}," >> $file
    echo "${mark}from${mark}:${mark}${from}${mark}," >> $file

    if [ -z "$write_time" ]
    then
        echo "${mark}time${mark}:[${mark}${collect_time}${mark}]" >> $file
    else
        echo "${mark}time${mark}:[${mark}${collect_time}${mark},${mark}${write_time}${mark}]" >> $file
    fi

    echo "}" >> $file
    echo "]" >> $file
else
    sed -i '$d' $file
    sed -i '$d' $file
    echo '},' >> $file
    echo '{' >> $file
    echo "${mark}text${mark}:${mark}${text}${mark}," >> $file
    echo "${mark}by${mark}:${mark}${by}${mark}," >> $file
    echo "${mark}from${mark}:${mark}${from}${mark}," >> $file

    if [ -z "$write_time" ]
        then
	echo "${mark}time${mark}:[${mark}${collect_time}${mark}]" >> $file
    else
	echo "${mark}time${mark}:[${mark}${collect_time}${mark},${mark}${write_time}${mark}]" >> $file
    fi

    echo "}" >> $file
    echo "]" >> $file
fi
