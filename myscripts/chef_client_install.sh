#!/bin/bash -evx

CHEFUSER=${CHEFUSER:-"superdima"}

useradd $CHEFUSER

CHEFUSER_HOME=$(eval echo ~$CHEFUSER)
CHEF_PATH=$CHEFUSER_HOME/.chef
KNIFEFILE=$CHEF_PATH/knife.rb
IPADDR=$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

mkdir -p $CHEF_PATH

cp /etc/chef/validation.pem /etc/chef/webui.pem $CHEF_PATH

cat <<- EOH > $KNIFEFILE
log_level                :info
log_location             STDOUT
node_name                'chef-webui'
client_key               '$CHEF_PATH/webui.pem'
validation_client_name   'chef-validator'
validation_key           '$CHEF_PATH/validation.pem'
chef_server_url          'http://$IPADDR:4000'
cache_type               'BasicFile'
cache_options( :path => '$CHEF_PATH/checksums' )
EOH


knife  client create $CHEFUSER -c $KNIFEFILE -d -a -f $CHEF_PATH/$CHEFUSER.pem

cat <<- EOH > $KNIFEFILE
log_level                :info
log_location             STDOUT
node_name                '$CHEFUSER'
client_key               '$CHEF_PATH/$CHEFUSER.pem'
validation_client_name   'chef-validator'
validation_key           '$CHEF_PATH/validation.pem'
chef_server_url          'http://$IPADDR:4000'
cache_type               'BasicFile'
cache_options( :path => '$CHEF_PATH/checksums' )
EOH

chown -R $CHEFUSER $CHEFUSER_HOME

su $CHEFUSER -c 'knife client list' | grep "$CHEFUSER" && echo SUCCESS
