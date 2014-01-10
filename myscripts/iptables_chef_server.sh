#!/bin/bash -evx

#part for iptables for server

#fisrt of all we flush iptables rules 
iptables -F INPUT

#we add rule to the beginning of iptabels rules chain, which allowing access for Established Sessions  
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#add rule which allows access from office ip by tcp protocol
iptables -A INPUT -s 89.22.6.3/32 -p tcp -j ACCEPT
#add rule which allows access from office ip by udp protocol
iptables -A INPUT -s 89.22.6.3 -p udp -j ACCEPT

#add rule for rejecting requects from all ip adresses which differs from office ip
iptables -A INPUT -j REJECT
