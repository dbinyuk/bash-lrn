#!/bin/bash

#test for directory exist

#if test -d "/home/svn/myproject" ; then echo This directory already exists; else echo directory created successfully; fi

#if dpkg -L | grep apache2 ; then This pachage already installed; else echo package installed successfully; fi

#if apt-get --only-upgrade |grep apache2 ; then This pachage already installed; else echo package installed successfully; fi
#unction del_package() {
#	echo apt-get remove libapache2-svn
#}
#del_package 
function install_pkg() {
	local PKG=$1

	if dpkg --get-selections|grep $PKG >/dev/null 2>/dev/null; then 
		echo "This package $PKG already exists"
	else 
		echo "Installing package: $PKG"
		sudo apt-get --assume-yes install $PKG
	fi
}

#function install_pkg2() {
#	local PKG=$1
#	echo $PKG
#}

#for PKG in pkg1 pkg2; do
#	install_pkg2 $PKG
#done

install_pkg "pdksh"


#install_pkg "package2"
#make_dir "/home/svn/myproject"

#function make_dir() {
#if test -d "/home/svn/myproject" ;
#then mkdir /home/svn/myproject echo This directory already exists;
#else echo directory created successfully; fi	
#}





