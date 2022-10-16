---
title: Home networking is back
author: scottyob
type: post
date: 2010-11-07T13:09:51+00:00
url: /2010/11/07/home-networking-is-back/
categories:
  - nerd
tags:
  - iptables
  - network
  - routing

---
<p style="clear: both">
  so, since I had the scare with my Asterisk VoIP box being hacked and a telephone call to Antarctica having being made, I decided to do something about it.
</p>

<p style="clear: both">
  My home network now consists of my D-Link Wireless router being put into Bridge mode, with all services pretty much turned off on the thing.
</p>

<p style="clear: both">
  My internal network is 10.12.0.0/16. I plan to sub-divide up this address space later, but for now, I&#8217;m pretty much just keeping it in one big heap until I set up my servers and want to separate them further from the wireless workstations, for this reason though, I&#8217;m keeping my setup pretty simple all pretty much in a 10.12.1.0/24 space..
</p>

<p style="clear: both">
  Anyway, I&#8217;m doing what I should have done a long, long time ago. I&#8217;ve set up <a href="http://iptables" >iptables</a> to block all traffic (except ICMP for now, and ssh inbound.)
</p>

<p style="clear: both">
  I&#8217;m being a bit lighter on resources on this cheap little router (the <a href="http://www.productwiki.com/compulab-fit-pc/" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.productwiki.com']);">Fit-PC</a>) so I&#8217;m using dnsmasq for DNS and DHCP.
</p>

<p style="clear: both">
  Plans for the future. I want to have a pool of ipv6 addresses that my DHCP server can assign and make them publicly addressable through some ipv6 trunk somewhere. That&#8217;d be pretty sick.
</p>

<br class="final-break" style="clear: both" />
