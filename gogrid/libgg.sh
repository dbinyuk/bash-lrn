#!/bin/bash

#file for reused code and functions
GGC=${GGC:-"$HOME/.gg"}
source "$GGC"

APIKEY=${APIKEY?"APIKEY is not defined"}
SECRET=${SECRET?"SECRET is not defined"}
SERVER='https://api.gogrid.com/api'
VERSION='1.0'
FORMAT=csv

#function for 
function getMD5sum {
	#calculate signature for gg rest api request
	
	#$1 - gogrid api key 
        #$2 - gogrid secret key
	#$3 - time returned by $(date +%s) - gmt local time

	# sets SIG env variable value
	HASH=$1$2$3

	SIG=`echo -n $HASH | md5sum | cut -d' ' -f1`
}

function getURL {
	# have curl fail silently and spit out error code to STDERR
	#taking data from internet resource by URL
	
	#$1 - URL from which takes data for current script
	
	curl -s -f $1
}


