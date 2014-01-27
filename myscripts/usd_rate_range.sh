#!/bin/bash

# author: Dmitry Binyuk <dbinyuk@griddynamics.com>
# description: script for taking dollar rate from finance.ua by year range
# created: 24.01.2014 10:56
# last changed: 26.01.2014 12:28

CMD=${CMD:-'./usd_rate.sh'}

for y in 2013; do
    for m in {1..12}; do
        for d in {1..31}; do
             $CMD "$y/$m/$d"
		done
	done
done