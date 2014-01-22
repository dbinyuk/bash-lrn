#!/bin/bash

# print_opts solution


while getopts "u:p:h:" OPT; do
    case $OPT in
        u) USR=$OPTARG;;
        p) PASSWD=$OPTARG;;
        h) HOST=$OPTARG;;
    esac
done

HOST=${HOST:-'localhost'}
USR=${USR?'You must specify user'}


shift $(($OPTIND - 1))

echo USR: $USR
echo PASSWD: $PASSWD
echo HOST: $HOST

echo Commands:

i=1
for arg in $*; do
	echo command \#${i} = $arg
	i=$((i+1))
done


