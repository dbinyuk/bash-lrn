#!/bin/bash
function add_user_to_group() {
if groups www-data | grep  subversion2; then
	echo "This user is already in the group"
else
	echo "User added to group"
	sudo usermod -a -G subversion dbinyuk
fi
}

add_user_to_group

