#!/bin/bash

function group_add() {
	local GRP=${1?Group name required}

	if getent group $GRP >/dev/null; then
		echo "This group is already exist"
	else
		echo "Group $GRP created successfully"
		groupadd $GRP
	fi
}

group_add "test"