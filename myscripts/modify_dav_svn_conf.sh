#!/bin/bash

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

modify_dav_svn_conf
