---
title: 'Happy New Year – Resolution #1, Network & Data'
author: scottyob
type: post
date: 2011-01-01T12:02:53+00:00
url: /2011/01/01/happy-new-year-resolution-1-network-data/
categories:
  - nerd
  - Personal
tags:
  - fitpc
  - network
  - routing

---
<p style="clear: both;">
  It&#8217;s a new year and time to start getting new years resolutions into action. I&#8217;ve moved into my new area in the study so I&#8217;ve started setting it up how I like.
</p>

<p style="clear: both;">
  <div>
    The first step is to get my router set up. The router I&#8217;m using is a little &#8216;fit-pc&#8217; box with two ethernet cables. As you can see, it&#8217;s pretty tiny but <a href="http://www.fit-pc.com/fit-pc1/fit-pc-1-0-specifications.html" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.fit-pc.com']);" target="_blank">doesn&#8217;t pack much in terms of power</a>.
  </div>
  
  <p style="clear: both;">
    <a class="image-link" href="http://www.scottyob.com/wp-content/uploads/2011/01/IMG_0121-full.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="linked-to-original" style="text-align: center; display: block; margin: 0 auto 10px;" src="http://www.scottyob.com/wp-content/uploads/2011/01/IMG_0121-thumb.jpg" alt="" width="380" height="300" /></a><br /> I&#8217;ve put my router in bridge mode (so it just acts as a layer two modem/bridge) and let my router then establish a pppoe session with my ISP and do all the routing with iptables (I&#8217;ve got to update my firewall script and services running on the box and post up the how-to&#8217;s later on for that.) Now the little crappy d-link thing doesn&#8217;t fall over and die when torrenting (the router will do all the routing and torrenting without hogging up entries in the NAT table is always a good thing)
  </p>
  
  <p style="clear: both;">
    One of my new years resolutions is to digitise everything (and make it reliable to do so) so I don&#8217;t have to worry about any paper floating around in my life (I HATE paperwork). To do this, I want to add a few more features in my home network, whilst improving security (especially after my VoIP was hacked a while ago)
  </p>
  
  <p style="clear: both;">
    I&#8217;m splitting my network into &#8216;trusted&#8217; and &#8216;not so trusted&#8217; zones. The beauty is because my router now has two nicks, putting a small 8 port switch into the equation will allow me to route traffic between these zones in a nice firewalled way.
  </p>
  
  <p style="clear: both;">
    I&#8217;d generally be lazy and put WPA-PSK security on the access point.
  </p>
  
  <p style="clear: both;">
    I feel safe doing this, from <a href="http://www.zdnet.com/blog/ou/wireless-lan-security-myths-that-wont-die/454" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.zdnet.com']);" target="_blank">a zdnet article</a><span style="text-decoration: underline;"><br /> </span>
  </p>
  
  <blockquote style="clear: both;">
    <p>
      All you need to do is use WPA-PSK security with a random alpha-numeric pass-phrase that has a minimum of 10 characters. I estimated that a truly random alpha-numeric 10-character pass-phrase using modern single-core computers will take one thousand PCs working in parallel 500 years to crack
    </p>
  </blockquote>
  
  <p style="clear: both;">
    I lol&#8217;d a bit where it says &#8220;.. you could run WEP (104 bit AKA 128) security, which might take a semi-skilled script kiddy using two PCs in an active attack configuration 10 minutes to break.
  </p>
  
  <p style="clear: both;">
    At the moment, my wireless is secured by only a 64 bit WEP key (shock horror!) Why? Because I&#8217;ve got damn devices like the Nintendo DS sitting on here which I&#8217;ve been wasting a bit of time on lately that don&#8217;t support WPA.
  </p>
  
  <p style="clear: both;">
    I could hide my SSID, do MAC filtering and not run DHCP, all that jazz, but the end of the story is that this can all be hacked by people who know what they&#8217;re doing (Mac addresses can be spoofed, if you&#8217;re using your wireless network then you&#8217;re still broadcasting stuff.)
  </p>
  
  <p style="clear: both;">
    I&#8217;m not terribly worried at the moment if someone hacks in, they can steal some of my crappy 1.5Mbit internet, they can print to my printer (have fun). My workstations themselves are to some degree protected, but what about when I build my file server and start storing bank statements, tax file numbers? all that stuff? The more layers of security the better! (I learnt this the hard way, trust me)
  </p>
  
  <p style="clear: both;">
    As I&#8217;ve already said, the way I&#8217;m lessening my fear of these security problems is by splitting my network into trusted and not so trusted zones.
  </p>
  
  <p style="clear: both;">
    <a class="image-link" href="http://www.scottyob.com/wp-content/uploads/2011/01/Router_Config.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="linked-to-original" style="text-align: center; display: block; margin: 0 auto 10px;" src="http://www.scottyob.com/wp-content/uploads/2011/01/Router_Config-thumb1.jpg" alt="" width="380" height="285" /></a>
  </p>
  
  <p style="clear: both;">
    <a class="image-link" href="http://www.scottyob.com/wp-content/uploads/2011/01/Network_Map.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="linked-to-original" style="text-align: center; display: block; margin: 0 auto 10px;" src="http://www.scottyob.com/wp-content/uploads/2011/01/Network_Map-thumb.jpg" alt="" width="380" height="442" /></a>User Isolation security means that the wireless clients won&#8217;t be able to see each other on the network. I&#8217;ll allow traffic too and from certain devices on the trusted network (the printer for instance.) but to gain access to any of my secure boxes (Fileserver, other workstations) then wireless clients will have to first connect through WEP, then establish a secured VPN connection into the trusted zone. With this setup, even if someone breaks into my WiFi, good on them, they get crippled net (I might cripple WiFi net bandwidth to the net, not decided yet) and access to.. well, my printer again *sigh*
  </p>
  
  <p style="clear: both;">
    <a class="image-link" href="http://www.scottyob.com/wp-content/uploads/2011/01/Network_Stack.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="linked-to-original" style="text-align: center; display: block; margin: 0 auto 10px;" src="http://www.scottyob.com/wp-content/uploads/2011/01/Network_Stack-thumb.jpg" alt="" width="380" height="285" /></a>Network stack lol!
  </p>
  
  <p>
    <br class="final-break" style="clear: both;" />
  </p>
