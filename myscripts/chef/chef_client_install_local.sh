#!/bin/bash -evx

#description
#author
#date

CHEF_CLIENT_NAME=${1?"Specify CHEF_CLIENT_NAME to create"}
#local account
CHEF_ADMIN_CLIENT_NAME=${2?"Specify CHEF_ADMIN_CLIENT_NAME"}
SERVER_ADDR=${3?"Specify SERVER_ADDR like 173.1.205.67"}

CHEFUSER=${4:-"$USER"}

CHEFUSER_HOME=$(eval echo ~$CHEFUSER)
CHEF_PATH=$CHEFUSER_HOME/.chef
KNIFEFILE=$CHEF_PATH/knife.rb

#mkdir ~/.chef

ssh $SERVER_ADDR "sudo su $CHEF_ADMIN_CLIENT_NAME -c 'knife client create $CHEF_CLIENT_NAME -d -a'" > ~/.chef/$CHEF_CLIENT_NAME.pem
ssh $SERVER_ADDR "sudo su $CHEF_ADMIN_CLIENT_NAME -c 'cat ~/.chef/validation.pem'" > ~/.chef/validation.pem

cat <<- EOH > $KNIFEFILE
log_level                :info
log_location             STDOUT

node_name                '$CHEF_CLIENT_NAME'
client_key               '$CHEF_PATH/$CHEF_CLIENT_NAME.pem'

validation_client_name   'chef-validator'
validation_key           '$CHEF_PATH/validation.pem'

chef_server_url          'http://$SERVER_ADDR:4000'
syntax_check_cache_path  '$CHEF_PATH/syntax_check_cache'
EOH

knife client list | grep "$CHEF_CLIENT_NAME" && echo SUCCESS

