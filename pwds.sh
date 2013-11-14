#!/bin/bash

if test "$PWD" != "$HOME" 
then 
	echo "Current dir is not home" 
	exit 1
fi