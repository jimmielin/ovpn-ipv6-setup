# OpenVPN via IPv6 Setup Scripts
These are Ubuntu-compatible setup scripts / instructions to setup a IPv6-routed (TCP6) OpenVPN tunnel on a OpenVZ-based VPS.
I set this up for various reasons and to take advantage of China's Next Generation Internet (CERNET-CNGI6X).

## Compatibility
This was set up on a OpenVZ VPS running Ubuntu (14.04.4 LTS, Kernel 2.6.32).

## Basic Setup
(A detailed guide will be written soon.)

### Installing OpenVPN on Ubuntu
* Install using `apt-get install openvpn` ...
* Generate certificates & keys using `easy-rsa`
* Configure `/etc/openvpn/server.conf` and `client.ovpn`

### Configuring iptables
* Route all traffic through VPN
* General Security Practices

## Credits
Thanks to the following resources I've found on the internet (links working as of June 2016)
* 16 Tips on OpenVPN Security - blog.g3rt.nl - https://blog.g3rt.nl/openvpn-security-tips.html
* How to Install and Configure OpenVPN on OpenVZ - http://lintut.com/how-to-install-and-configure-openvpn-on-openvz/
* Route All Traffic Through OpenVPN - http://askubuntu.com/questions/462533/route-all-traffic-through-openvpn
* Getting OpenVPN to work on an OpenVZ VPS - https://kyle.io/2012/09/getting-openvpn-to-work-on-an-openvz-vps/
* Obfuscated SSH Tunnel - http://blog.anthonywong.net/2015/09/26/obfuscated-ssh-tunnel/
* Obfuscate SSH Traffic with obfsproxy - http://compulsive-evasion.blogspot.com/2012/11/obfuscate-ssh-traffic-with-obfsproxy.html
* Hide OpenVPN Traffic obfsproxy on Windows and Linux (EC2) - https://www.comparitech.com/blog/vpn-privacy/hide-openvpn-traffic-obfsproxy-on-windows-and-linux-ec2/