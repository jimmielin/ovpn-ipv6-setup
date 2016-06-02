# OpenVPN on VPS (via IPv6) Setup Scripts
These are Ubuntu-compatible setup scripts / instructions to setup a IPv6-routed (TCP6) OpenVPN tunnel on a OpenVZ-based VPS.
I set this up for various reasons and to take advantage of China's Next Generation Internet (CNGI-CERNET2/6x), as the IPv6 tubes are less clogged. Note that IPv6 is only used on the tunnel level, and the exits are IPv4. I designed this especially to maintain a CNGI-CERNET2/6x connection via IPv6 while masking my IPv4 connection with the VPN. This is obviously not a security-savvy option; it is purely for convenience. If this does not match your usage need, you need to look up how to use IPv6 at the transport level with OpenVPN, too. (This is possible.)

## Compatibility
This was set up on a OpenVZ VPS running Ubuntu (14.04.4 LTS, Kernel 2.6.32).

## Basic Setup
(Information will be added as time progresses.)

### Installing OpenVPN on Ubuntu
* Install using `apt-get install openvpn` ...

Notice that the default `openvpn` package on the Ubuntu/Debian repo is seriously out of date (2.3.2/2.3.3), and does not support TLSv1.0+ and more strong TLS ciphers. You should follow the instructions in the OpenvpnSoftwareRepos Wiki page at the OpenVPN Community. For Ubuntu Trusty:

~~~~
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add -
echo "deb http://swupdate.openvpn.net/apt trusty main" > /etc/apt/sources.list.d/swupdate.openvpn.net.list
apt-get update && apt-get install openvpn
~~~~

* Generate certificates & keys using `easy-rsa` (https://github.com/OpenVPN/easy-rsa)
I'm using 2.0, but you can also follow the instructions in their `README.quickstart` for 3.0.
~~~~
cd /tmp
wget https://github.com/OpenVPN/easy-rsa/archive/release/2.x.zip
unzip 2.x.zip
cp -R easy-rsa-release-2.x/easy-rsa /etc/openvpn
cd /etc/openvpn/easy-rsa/
chmod -R 777 2.0
cd 2.0
~~~~

Edit the vars -- configure the country, province and all that stuff if you like. (`vi vars` or whatever editor you like)

~~~~
source vars
./clean-all
./pkitool -initca
./pkitool -server server
~~~~
Don't just enter enter through -- there are two "yes"s you need to answer at the end.

~~~~
./pkitool client1
~~~~
Create as many client certificates you need.

Build the Diffie-Hellman Parameters.
~~~~
./build-dh
~~~~

Retrieve the necessary client keys from your server (using whatever method you like.)

* Configure `/etc/openvpn/server.conf` and `client.ovpn`

It is advisable to harden the security of the encryption, key exchange, and message validation. DNS servers should also be pushed to the client due to DNS poisoning.

### Configuring iptables
* Route all traffic through VPN

If you are not on OpenVZ and can handle kernel modules, and your IPv4 address changes frequently, then you can use the MASQUERADE option in iptables:

~~~~
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
~~~~

Otherwise if you're on OpenVZ and your server IPv4 address doesn't change much, you can use SNAT instead (credit serverfault link below). Change the 0.0.0.0 below to your server's IPv4 address:
~~~~
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to-source 0.0.0.0
~~~~

* Other possibly useful commands, see `iptables.sh`

### Extras
* General Security Practices

See the "16 Tips on OpenVPN Security" below for a good reference. In the `server.conf` and `client.ovpn` examples I included, I restricted the TLS version, TLS cipher suites, HMAC algorithm & the cipher suite settings.

* Circumventing censorship & DPI

Currently it seems like CNGI-CERNET2/6x does not do as much blocking as the IPv4 China Internet or CERNET does, as reportedly SSH connections in IPv4 will trigger warnings and result in automated IP bans, depending on the region. In the future, it would be wise to run `obfs4proxy` (Go) or `obfsproxy` (Python) and use a more "common" port (443, as encrypted via 80 is certainly suspicious).

Running vanilla TLS OpenVPN via port 443 is not advisable since it is known that deep-packet inspection (DPI) is being employed, and SSH, OpenVPN/TLS have very distinct handshakes that will certainly trigger DPI. However, right now, it is not a concern for me as supposedly IPv6 address blocking is still not active in CERNET2, except for the big target -- Google. (And I thought we were promised Google Scholar in CERNET?)

## Credits
Thanks to the following resources I've found on the internet (links working as of June 2016)
* 16 Tips on OpenVPN Security - blog.g3rt.nl - https://blog.g3rt.nl/openvpn-security-tips.html
* How to Install and Configure OpenVPN on OpenVZ - http://lintut.com/how-to-install-and-configure-openvpn-on-openvz/
* Route All Traffic Through OpenVPN - http://askubuntu.com/questions/462533/route-all-traffic-through-openvpn
* Getting OpenVPN to work on an OpenVZ VPS - https://kyle.io/2012/09/getting-openvpn-to-work-on-an-openvz-vps/
* Obfuscated SSH Tunnel - http://blog.anthonywong.net/2015/09/26/obfuscated-ssh-tunnel/
* Obfuscate SSH Traffic with obfsproxy - http://compulsive-evasion.blogspot.com/2012/11/obfuscate-ssh-traffic-with-obfsproxy.html
* Hide OpenVPN Traffic obfsproxy on Windows and Linux (EC2) - https://www.comparitech.com/blog/vpn-privacy/hide-openvpn-traffic-obfsproxy-on-windows-and-linux-ec2/
* How to write iptables rule without masquerade - http://serverfault.com/questions/307059/openvpn-server-running-on-openvz-how-to-write-iptables-rule-without-masquerade

OpenVPN Documentation Pages
* Ubuntu/Debian Software Repos - https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos
* Hardening OpenVPN Security - https://community.openvpn.net/openvpn/wiki/Hardening
