#!/bin/bash

FOLDER=${1:-'.'}
DAYS_AGO=${2:-14}

find $FOLDER -type f -mtime "+$DAYS_AGO" -exec rm -f {} \; -exec echo {} \;
