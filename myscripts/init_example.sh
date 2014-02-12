#!/bin/bash

NAME=my-app
USER=dbinyuk
LOGFILE=/tmp/init_log.log

while true; do
sudo -u "$USER" date; 
echo current user: $USER >> "$LOGFILE"
sleep 10
done &
