#!/bin/bash

LOG=${LOG:-"/home/dbinyuk/log"}
INTERVAL=${INTERVAL:-10}

#[ ! -d $LOG ] && mkdir -p $LOG && echo "$LOG created"

if [ ! -d $LOG ]; then
	mkdir -p $LOG
	if [ $? -eq 0 ]; then
		echo "$LOG created"
	fi
fi


nohup vmstat $INTERVAL > "$LOG/vmstat.log" 2>"$LOG/vmstat.err" &
echo  $! > "$LOG/vmstat.pid"

nohup iostat $INTERVAL > "$LOG/iostat.log" 2>"$LOG/iostat.err" &
echo  $! > "$LOG/iostat.pid"

nohup mpstat -P ALL $INTERVAL > "$LOG/mpstat.log" 2>"$LOG/mpstat.err" &
echo  $! > "$LOG/pmstat.pid"