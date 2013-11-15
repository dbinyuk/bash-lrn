#!/bin/bash          

#man tar for details
#script to backup home folder

#tar -cvjf /tmp/home-backup.tgz $HOME

#date time output 
A=$(date +%Y_%e-%B_%H:%M:%S)
echo $A

#directory path
P=/home/dbinyuk/work/bash-lrn/
cat $P $A




