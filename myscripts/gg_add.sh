#!/bin/bash

# print_opts solution


while getopts "c:i:r:n:d:" OPT; do
    case $OPT in
	c) GGC=$OPTARG;;    
        i) IMAGE=$OPTARG;;
	r) RAM=$OPTARG;;
	n) NAME=$OPTARG;;
	d) DESCR=$OPTARG;;
    esac
done

GGC=${GGC:-"$HOME/.gg"}

echo gg_config: "$GGC"

source "$GGC"
DESCR=${DESCR:-""}
APIKEY=${APIKEY?"APIKEY is not defined"}
SECRET=${SECRET?"SECRET is not defined"}
NAME=${NAME?"NAME is not defined"}
IMAGE=${IMAGE?"IMAGE is not defined"}
RAM=${RAM?"RAM is not defined"}
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
        URL="$1$2&sig=$3&name=$4&image=$5&ram=$6&descr=$7&format=$8&v=$9&api_key=${10}"
}


function getURL {
        # have curl fail silently and spit out error code to STDERR
        curl -f $1
}

# Get to work

getMD5sum $APIKEY $SECRET $GTIME
buildBaseURL $SERVER $METHOD $SIG $NAME $IMAGE $RAM $DESCR $FORMAT $VERSION $APIKEY
echo $URL

