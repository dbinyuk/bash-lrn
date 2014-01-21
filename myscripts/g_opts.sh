#!/bin/bash

#getopt usage sample code


while getopts "ab:" OPT; do
    case $OPT in
        a) echo a switch;;
        b)  VAR=$OPTARG;;
    esac
done

echo OPTIND = $OPTIND

echo VAR = $VAR

i=1
for arg in $*; do
	echo arg${i} = $arg
	i=$((i+1))
done

shift $(($OPTIND - 1))

echo "****** after shift *****"

i=1
for arg in $*; do
	echo arg${i} = $arg
	i=$((i+1))
done
