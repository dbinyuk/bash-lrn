#!/bin/bash


    DBS=`mysql -uroot  -e"show databases"`
    for b in $DBS ;
    do
        mysql -uroot -e"show tables from $b"
    done