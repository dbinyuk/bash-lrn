iptables -t nat -i eth0 -A PREROUTING -s 172.18.199.191 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -i eth0 -A PREROUTING -s 172.18.199.195 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -i eth0 -A PREROUTING -s 172.18.199.0/24 -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -i eth0 -A PREROUTING -s 172.18.0.0/16 -p tcp --dport 80 -j REDIRECT --to-port 8080


