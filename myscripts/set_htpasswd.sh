#!/bin/bash

DIR='/etc/subversion/passwd2'
sudo htpasswd -b -c ${DIR} admin admin
sudo htpasswd -b ${DIR} demo demo

#output of file content
cat ${DIR} #/etc/subversion/passwd2