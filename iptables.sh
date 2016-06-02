# DO NOT CLEAR EXISTING RULES IF YOU ALREADY HAVE
# PREVIOUS IPTABLES RULES. This is your only warning.
iptables -F

iptables -P OUTPUT ACCEPT
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 10.8.0.0/24 -j ACCEPT
iptables -A FORWARD -j REJECT

# OpenVZ does not support MASQUERADE, so use SNAT instead
# http://serverfault.com/questions/307059/openvpn-server-running-on-openvz-how-to-write-iptables-rule-without-masquerade
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to-source 0.0.0.0 # change --to-source
iptables -A INPUT -p tcp --dport 1194 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT