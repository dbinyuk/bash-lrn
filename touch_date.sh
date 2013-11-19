#!/bin/bash

MAX_FILE=${MAX_FILE:-10}
MAX_DAY=${MAX_DAY:-31}

DAYS=$(eval echo {1..$MAX_DAY})
FILES=$(eval echo {1..$MAX_FILE})

FOLDER=${FOLDER:-'/tmp'}

for I in $DAYS; do 
	#echo touch $I
	for J in $FILES; do
		echo creating $FOLDER/${I}days_ago${J}
		touch $FOLDER/${I}days_ago${J} --date="${I} day ago"
	done
done
