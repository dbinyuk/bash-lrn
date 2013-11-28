#!/bin/bash

function install_pkg() {
	local PKG=$1

	if dpkg --get-selections|grep $PKG >/dev/null 2>/dev/null; then
		echo "Package already installed: $PKG"
	else
		echo "Installing package: $PKG"
		apt-get --assume-yes install $PKG
	fi
}

function group_add() {
	local GRP=${1?Group name required}

	if getent group $GRP >/dev/null; then
		echo "This group is already exist: $GRP"
	else
		echo "Group $GRP created successfully"
		groupadd $GRP
	fi
}

function make_dir() {
	local DIR=${1?Directory name required}

	if test -d $DIR; then
		echo "This directory already exists: $DIR"
	else
		echo "Creating directory: $DIR"
		mkdir -p $DIR
		echo "Directory created successfully: $DIR"
	fi
}

function user_add() {
	local USER=${1?Username required}
	
	if getent passwd $USER >/dev/null; then
		echo "This user already exist"
	else
		echo "User $USER created successfully"
		useradd $USER
	fi
}

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

function modify_dav_svn_conf() {
	local FILE=${1:-'/etc/apache2/mods-available/dav_svn.conf'}
	local LOCATION=${2:-'/svn/myproject'}

	if grep "<Location ${LOCATION}>" ${FILE} >/dev/null; then
		echo "All right"
	else
		echo "<Location $LOCATION>
	     DAV svn
	     SVNPath /home${LOCATION}
	     AuthType Basic
	     AuthName 'myproject subversion repository'
	     AuthUserFile /etc/subversion/passwd
	     <LimitExcept GET PROPFIND OPTIONS REPORT>
	        Require valid-user
	     </LimitExcept>
	  </Location>" >> $FILE
	fi
}

REPO=${REPO:-'myproject'}
DIR=${DIR:-"/home/svn/$REPO"}

install_pkg "subversion"
install_pkg "libapache2-svn"
install_pkg "apache2-mpm-prefork"
group_add "subversion"
#create directory

if test -d $DIR; then
	rm -rf $DIR
	echo "Dir removed: $DIR"
fi

make_dir "$DIR"
svnadmin create "$DIR"
#ls -l $DIR
chown -R www-data:subversion $DIR
chmod -R g+rws $DIR
cd /tmp
rm -rf $REPO
#checking repo
svn co file://$DIR
#add user to group for giving him perms of this group
add_user_to_group "www-data" "subversion"
#add permissions to directory
chmod -R g+rws $DIR
chown -R www-data:subversion $DIR
chmod -R g+rws $DIR
#list perms
ls -la $DIR

modify_dav_svn_conf "/etc/apache2/mods-available/dav_svn.conf" "/svn/$REPO"
PASSWD=${PASSWD:-'/etc/subversion/passwd'}
#apache users setting
htpasswd -b -c ${PASSWD} admin admin
htpasswd -b ${PASSWD} demo demo
cat ${PASSWD}
#restarting apache
/etc/init.d/apache2 restart