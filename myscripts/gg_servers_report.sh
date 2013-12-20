#!/bin/bash

INFILE=${1?'Specify file with hosts list'}
ERROR_LOG=${ERROR_LOG:-'/tmp/ssh_stderr.log'}
REMOTE_CMD="cat /proc/cpuinfo |grep processor|wc -l; cat /proc/meminfo | head -n1|awk '{print \$2}'; uptime" 

[ -e "$ERROR_LOG" ] && rm -f "$ERROR_LOG"

cat $INFILE | while read IP; do 
	[ -z "$IP" ] && continue
	RESULT=$(ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=no -n $IP $REMOTE_CMD 2>>$ERROR_LOG)
	if [ -n "$RESULT" ]; then
		echo $IP $RESULT
	else
		echo $IP ERROR
	fi
done


