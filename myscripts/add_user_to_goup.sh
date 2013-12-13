#!/bin/bash
function add_user_to_group() {
	USER=${1?Username required}
	GROUP=${2?Group name required}

if groups $USER | grep $GROUP >/dev/null; then
	echo "User ${USER} is already in the group: ${GROUP}"
else
	echo "User ${USER} added to group: ${GROUP}"
	sudo usermod -a -G ${GROUP} ${USER}
fi
}


add_user_to_group "www-data" "subversion"

