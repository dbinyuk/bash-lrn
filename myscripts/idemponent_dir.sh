#!/bin/bash

function make_dir() {
	local DIR=${1?Directory name required}

	if test -d $DIR; then
		echo "This directory already exists";
	else 
		echo "Directory $DIR created successfully";
		mkdir $DIR;
	fi
}

make_dir "/home/svn/myproject"