#!/bin/bash

#description: script to create snapshot of a folder

FOLDER=$1
PREFIX=$2

if [ -z "$FOLDER" ]; then
	echo "Specify Folder"
	exit 1
fi

if [ -z "$PREFIX" ]; then
	echo "Specify Prefix"
	exit 2
fi

if [ ! -d "$FOLDER" ]; then
	echo "Folder is not found: $FOLDER"
	exit 3
fi


SUFFIX=".tar.bz"
BACKUP_FOLDER="/tmp"
DATE=$(date +%Y%m%d%H%M%S)
FILENAME="$BACKUP_FOLDER/${PREFIX}_${DATE}${SUFFIX}"


tar -cjf $FILENAME $FOLDER && echo "$FILENAME created successfully"