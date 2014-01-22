#!/bin/bash

#getopt usage sample code


while getopts "u:p:" OPT; do
    case $OPT in
        u) echo u switch;;
        p)  VAR=$OPTARG;;
    esac
done

echo OPTIND = $OPTIND

echo VAR = $VAR

i=1
for arg in $*; do
	echo command \#${i} = $arg
	i=$((i+1))
done

shift $(($OPTIND - 1))

echo "****** after shift *****" #Commands

i=1
for arg in $*; do
	echo arg${i} = $arg
	i=$((i+1))
done
