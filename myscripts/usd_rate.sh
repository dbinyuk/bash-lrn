#!/bin/bash

# author: Dmitry Binyuk <dbinyuk@griddynamics.com>
# description: script for taking dollar rate from finance.ua
# created: 24.01.2014 10:56
# last changed: 24.01.2014 17:33

DATE=${1:-"2014/1/1"}

#URL of internet resource of dollar rate
URL="http://tables.finance.ua/ru/currency/cash/~/ua/USD/0/${DATE}"

# len('8.2650 8.2450 8.3000 8.3086 7.9930') == 34
VALID_LEN=${VALID_LEN:-34}

#command for taking info by URL and converting it to readable form by sed
RESULT=$(curl -s "${URL}" | grep 'id="select-table"' | sed -r 's/^.*(<thead>)(.*)(<\/thead>).*$/\2/g'| sed 's/<[^>]*>//g'|sed 's/&nbsp;/ /g'| awk '{print $2,$3,$4,$5,$7}')

if [ ${#RESULT} -eq $VALID_LEN ]; then
	echo $DATE $RESULT
else
	echo $DATE "ERROR"
	exit 1
fi