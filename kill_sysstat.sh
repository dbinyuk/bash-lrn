#!/bin/bash

LOG=${LOG:-"/home/dbinyuk/log"}

for PID_FILE in $LOG/*.pid; do 
	if [ -e "$PID_FILE" ]; then
		echo "killing process: $(cat $PID_FILE)"
		kill $(cat $PID_FILE)
		echo "removing: $PID_FILE"
		rm $PID_FILE
	fi
done