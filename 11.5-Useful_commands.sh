#!/bin/bash

#before script running you must create this file
sed 's/to_be_replaced/replaced/g' /tmp/dummy

awk '/test/ {print}' /tmp/dummy

awk '/test/ {i=i+1} END {print i}' /tmp/dummy

wc --words --lines --bytes /tmp/dummy

#sort lines of text files
sort /tmp/dummy

#return true or false of compare
bc -q
# and than enter symbols to compare
# use quit to exit




