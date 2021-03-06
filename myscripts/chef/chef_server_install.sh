#!/bin/bash -e

apt-get update
#use curl to get ruby version 1.9.3 from server
	\curl -sSL https://get.rvm.io  | bash -s stable --ruby=1.9.3

#To start using RVM you need to run
	source /usr/local/rvm/scripts/rvm

#Using RVM Ruby version 1.9.3
	rvm install 1.9.3

#make this version as default
	rvm use --default 1.9.3

# http://stackoverflow.com/questions/19579984/sinatra-server-wont-start-wrong-number-of-arguments
#remove thin, assuming it has 2.0.0pre version
	echo | gem uninstall thin -a -x -I --force
#install valid version of thin
	gem install thin --version 1.6.1 --no-ri --no-rdoc

#uninstalling bunny and install needed version
   echo | gem uninstall bunny -a -x -I --force
   gem install bunny --version 0.6.0 --no-ri --no-rdoc

# uninstall haml and installing needed version
   echo |gem uninstall haml -a -x -I --force
   gem install haml -v 3.1.8 --no-ri --no-rdoc


#install chef version 10.30.2
	gem install chef --version 10.30.2 --no-ri --no-rdoc

#install CouchDB
	apt-get install -y couchdb

#install rabbitmq-server
	apt-get install -y rabbitmq-server

#configure rabbitmq
	rabbitmqctl add_vhost /chef
	rabbitmqctl add_user chef testing
	sudo rabbitmqctl set_permissions -p /chef chef ".*" ".*" ".*"

#install openjdk
	apt-get  install -y openjdk-6-jre-headless

#install zlib libxml
	apt-get install -y zlib1g-dev libxml2-dev


#Add the Opscode APT Repository
	echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main"

mkdir -p /etc/apt/trusted.gpg.d
#based on https://tickets.opscode.com/browse/CHEF-2803
gpg --fetch-key http://apt.opscode.com/packages@opscode.com.gpg.key
gpg --export packages@opscode.com | sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null

	#curl -o /etc/apt/trusted.gpg.d/opscode-keyring.gpg http://apt.opscode.com/packages@opscode.com.gpg.key
	#gpg --import /etc/apt/trusted.gpg.d/opscode-keyring.gpg
#Add the GPG Key
	#mkdir -p /etc/apt/trusted.gpg.d
	#gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
	#gpg --export packages@opscode.com

	#gpg --export packages@opscode.com | sudo tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null


	echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" > /etc/apt/sources.list.d/opscode.list


#apt-get update to update package lists
	apt-get update

#install opscode-keyring which saves keys for last date 
#added from http://stackoverflow.com/questions/7798501/how-to-make-apt-get-accept-new-config-files-in-a-unattended-install-of-debian-fr
	apt-get install -y -o Dpkg::Options::="--force-confnew" opscode-keyring

	apt-get -y upgrade

	apt-get install -y libgecode-dev

#getting gecode 
	cd /tmp
	curl -O http://www.gecode.org/download/gecode-3.5.0.tar.gz

#unpacking archive
	tar zxvf gecode-3.5.0.tar.gz

	cd gecode-3.5.0 && ./configure

	make && make install

#install required gems
    

	gem install  chef-server chef-server-api chef-solr chef-server-webui --no-ri --no-rdoc
	

	#source /usr/local/rvm/scripts/rvm
	#gem install chef-server-webui --no-ri --no-rdoc

#install webui
#gem install chef-server-webui --no-ri --no-rdoc

#Creating directories which required for chef-server configuration file
mkdir -p /var/chef/ca /var/chef/cache /var/chef/nodes /var/chef/openid/store /var/chef/openid/cstore /var/chef/search_index /var/chef/roles /var/chef/support /var/log/chef/ /etc/chef/ /var/chef/cookbooks
IPADRR=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

OUTFILE=/etc/chef/server.rb

#writing chef-server configuration file
cat <<- EOH > $OUTFILE
log_level          :info
log_location       STDOUT
ssl_verify_mode    :verify_none
chef_server_url    "http://$IPADRR:4000"
 
signing_ca_path    "/var/chef/ca"
couchdb_database   'chef'
 
cookbook_path      [ "/var/chef/cookbooks" ]
 
file_cache_path    "/var/chef/cache"
node_path          "/var/chef/nodes"
openid_store_path  "/var/chef/openid/store"
openid_cstore_path "/var/chef/openid/cstore"
search_index_path  "/var/chef/search_index"
role_path          "/var/chef/roles"
 
validation_client_name "chef-validator"
validation_key         "/etc/chef/validation.pem"
client_key             "/etc/chef/client.pem"
web_ui_client_name     "chef-webui"
web_ui_key             "/etc/chef/webui.pem"
 
web_ui_admin_user_name "admin"
web_ui_admin_default_password "secret"

 
supportdir = "/var/chef"

solr_jetty_path File.join(supportdir, "solr", "jetty")
solr_data_path  File.join(supportdir, "solr", "data")
solr_home_path  File.join(supportdir, "solr", "home")
solr_heap_size  "256M"
 
umask 0022
 
Mixlib::Log::Formatter.show_time = false
EOH

#creating file for solr

#cat > /etc/chef/solr.rb
SOLRFILE=/etc/chef/solr.rb
cat <<- EOF > $SOLRFILE
supportdir = "/var/chef"
solr_jetty_path File.join(supportdir, "solr", "jetty")
solr_data_path  File.join(supportdir, "solr", "data")
solr_home_path  File.join(supportdir, "solr", "home")
solr_heap_size  "256M"
EOF

chef-solr-installer

nohup chef-expander -n1 2>./err_log.txt 1>&2 &
echo  $! > "/var/chef/chef-expander.pid"

nohup chef-solr 2>&1 > /var/log/chef/chef-solr.log &
echo  $! > "/var/chef/chef-solr.pid"

nohup chef-server --no-daemonize 2>&1 > /var/log/chef/chef-server.log &
echo  $! > "/var/chef/chef-server.pid"


sleep 60
nohup chef-server-webui -p 4040 2>&1 > /var/log/chef/chef-server-webui.log &
echo  $! > "/var/chef/webui.pid"

sleep 30
#Test
for PORT in 4000 4040 5984 5672 8983; do echo checking: $PORT $(lsof -i :$PORT || echo FAIL); done| grep FAIL  && echo "FAIL" || echo SUCCESS

