#!/bin/bash

function user_add() {
	local PASS=${1?Username required}

	if getent passwd $PASS; then
		echo "This user already exist"
	else
		echo "User $1 created successfully"
		useradd $1
	fi
}

#user_add "www-test"
user_add