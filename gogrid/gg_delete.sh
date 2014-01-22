#!/bin/bash

# print_opts solution


while getopts "c:i:" OPT; do
    case $OPT in
	c) GGC=$OPTARG;;    
        i) IMAGE=$OPTARG;;
    esac
done

GGC=${GGC:-"$HOME/.gg"}

echo gg_config: "$GGC"

source "$GGC"
APIKEY=${APIKEY?"APIKEY is not defined"}
SECRET=${SECRET?"SECRET is not defined"}
IMAGE=${IMAGE?"IMAGE is not defined"}
GTIME=`date +%s`

SERVER='https://api.gogrid.com/api'
VERSION='1.0'
FORMAT=xml
METHOD='/grid/server/add?'

function getMD5sum {
        HASH=$1$2$3
        SIG=`echo -n $HASH | md5sum | cut -d' ' -f1`
}


function buildBaseURL {
        #without array, cleaner in bash
        URL="$1$2&sig=$3&image=$4&format=$5&v=$6&api_key=$7"
}


function getURL {
        # have curl fail silently and spit out error code to STDERR
        curl -f $1
}

# Get to work

getMD5sum $APIKEY $SECRET $GTIME
buildBaseURL $SERVER $METHOD $SIG $IMAGE $FORMAT $VERSION $APIKEY
echo $URL

