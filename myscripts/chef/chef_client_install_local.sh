#!/bin/bash -evx

# author: Dmitry Binyuk <dbinyuk@griddynamics.com>
# description: script for chef client install on local machine
# created: 24.01.2014 10:56
# last changed: 24.01.2014 17:33

CHEF_CLIENT_NAME=${1?"Specify CHEF_CLIENT_NAME to create"}
CHEF_ADMIN_CLIENT_NAME=${2?"Specify CHEF_ADMIN_CLIENT_NAME"}
SERVER_ADDR=${3?"Specify SERVER_ADDR like 173.1.205.67"}

CHEFUSER=${4:-"$USER"}

CHEFUSER_HOME=$(eval echo ~$CHEFUSER)
CHEF_PATH=$CHEFUSER_HOME/.chef
KNIFEFILE=$CHEF_PATH/knife.rb

#mkdir ~/.chef
sudo mkdir -p /var/chef
sudo chmod 777 /var/chef
#ssh $SERVER_ADDR "sudo su $CHEF_ADMIN_CLIENT_NAME -c 'knife client create $CHEF_CLIENT_NAME -d -a'" > $CHEFUSER_HOME/$CHEF_CLIENT_NAME.pem
ssh $SERVER_ADDR "sudo su $CHEF_ADMIN_CLIENT_NAME -c 'cat ~/.chef/validation.pem'" > $CHEFUSER_HOME/validation.pem

cat <<- EOH > $KNIFEFILE
log_level                :info
log_location             STDOUT

node_name                '$CHEF_CLIENT_NAME'
client_key               '$CHEF_PATH/$CHEF_CLIENT_NAME.pem'

validation_client_name   'chef-validator'
validation_key           '$CHEF_PATH/validation.pem'

chef_server_url          'http://$SERVER_ADDR:4000'
syntax_check_cache_path  '$CHEF_PATH/syntax_check_cache'
cookbook_path [ "$CHEFUSER_HOME/chef-repo/cookbooks" ]
cache_options({ :path => "/var/chef/cache/checksums", :skip_expires => true })

EOH

knife client list | grep "$CHEF_CLIENT_NAME" && echo SUCCESS