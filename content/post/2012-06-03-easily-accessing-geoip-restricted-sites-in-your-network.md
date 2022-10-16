---
title: Easily accessing GeoIP restricted sites in your network.
author: scottyob
type: post
date: 2012-06-03T11:05:05+00:00
url: /2012/06/03/easily-accessing-geoip-restricted-sites-in-your-network/
categories:
  - nerd

---
We all know the problem, some sites are restricted to certain countries based on the IP address you&#8217;re using to view them.  When trying to access over-seas, some solutions are HTTP proxies, Socks proxies and the like.  The problem I have with all of these is that they&#8217;re annoying to set up whenever you want to to view the site and I don&#8217;t want to have to do that for all my devices (iPad, computer, etc).

This solution will tunnel only the sites you want over a VPN connection to be NAT&#8217;d out the other end.

<a href="/img/old/2012/06/Network-Config.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="aligncenter size-full wp-image-176" title="Network Config" src="/img/old/2012/06/Network-Config.jpg" alt="" width="410" height="529" /></a>

First we want to set up OpenVPN on the remote host by issuing &#8220;openvpn &#8211;genkey &#8211;secret static.key&#8221; then creating a file in (/etc/openvpn/server.conf)

```# Network
port 1194
proto tcp-server
dev tun
ifconfig 10.0.6.1 10.0.6.2 

# Crypto
secret /etc/openvpn/static.key
comp-lzo
keepalive 10 120

# Security
persist-key
persist-tun

# Logging
status openvpn-status.log
```

One thing we need to do on the server is set up NAT on the outbound address (to make sure all traffic that passes our VPS destined for the internet looks like it&#8217;s from that US IP address)

```# Previously initiated and accepted exchanges bypass rule checking
# Allow unlimited outbound traffic
/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.0.6.0/24 -o eth0 -j MASQUERADE
echo 1 &gt; /proc/sys/net/ipv4/ip_forward
```

On the client side, things look very similar,

```remote vps.server.com 1194 tcp-client
persist-key
comp-lzo no
redirect-gateway def1
nobind
persist-tun
secret secret.key
dev tun
ifconfig 10.0.6.2. 10.0.6.1
```

On the client, I just also MASQUERADE&#8217;d data though (I know, double NAT&#8217;ing, easier then adjusting routing table on the VPS)

Now for the magic to happen. I just replaced the DNS server on my home router with a little Python script (<3 Twisted framework) to proxy requests, adding a tunnel for IP's that get returned by sites in my list (in this case I've chosen two fictious sites, HooLoo.com and pandoor.com 

```#!/usr/bin/python

from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
from twisted.names import dns
from twisted.names import client, server
import subprocess
from sys import exit
from os import fork

tunnelDomains = [
  &#8216;pandoor.com&#8217;,
  &#8216;hooloo.com&#8217;
]
dnsServers = [(&#8216;203.12.160.35&#8217;, 53), (&#8216;203.12.160.36&#8217;, 53)]

try:
	pid = fork()
	if pid &gt; 0:
		exit(0)
except OSError, e:
	exit(1)


def tunnel(address):
       subprocess.call(["route", "add", address + "/32", "tun0"])  

class SpelDnsReolver(client.Resolver):
  def filterAnswers(self, message):
    if message.trunc:
      return self.queryTCP(message.queries).addCallback(self.filterAnswers)
    else:
      for d in tunnelDomains:
        if str(message.queries[0].name).endswith(d):
          for answer in message.answers:
            if answer.type == 1: #A record
              tunnel(answer.payload.dottedQuad())

    return (message.answers, message.authority, message.additional)

verbosity = 0
resolver = SpelDnsReolver(servers=dnsServers)
f = server.DNSServerFactory(clients=[resolver], verbose=verbosity)
p = dns.DNSDatagramProtocol(f)
f.noisy = p.noisy = verbosity

reactor.listenUDP(53, p)
reactor.listenTCP(53, f)
reactor.run()
```
