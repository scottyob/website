---
title: throttling guest internet on Apple Airport Extreme
author: scottyob
type: post
date: 2013-12-18T13:09:03+00:00
url: /2013/12/18/throttling-guest-internet-on-apple-airport-extreme/
categories:
  - Uncategorized

---
I&#8217;ve been happily running my Apple Airport Extreme as m home router for the past few years (since my debian router died, and I&#8217;ve been too lazy to replace it).  One of the cool features was the ability to create a guest network (SSID) to access the internet without being able to access your trusted network.  One feature I wanted was the ability to throttle the speed guests can access the internet at.  While I couldn&#8217;t do this with the Airport Extreme alone, Add a Juniper SRX100 into the mix that the awesome <a href="http://cooperlees.com" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://cooperlees.com']);">Cooper Lees</a> gave me into the mix and problem solved.

<a href="http://www.scottyob.com/wp-content/uploads/2013/12/apple-airport-extreme-base-station_1.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="aligncenter size-full wp-image-362" alt="apple-airport-extreme-base-station_1" src="http://www.scottyob.com/wp-content/uploads/2013/12/apple-airport-extreme-base-station_1.jpg" width="600" height="450" /></a>

<!--more-->

<div id="attachment_357" style="width: 499px" class="wp-caption aligncenter">
  <a href="http://www.scottyob.com/wp-content/uploads/2013/12/photo-1.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img aria-describedby="caption-attachment-357" class=" wp-image-357 " alt="SRX100, signed by the #1 Juniper Engineer" src="http://www.scottyob.com/wp-content/uploads/2013/12/photo-1.jpg" width="489" height="367" /></a>
  
  <p id="caption-attachment-357" class="wp-caption-text">
    SRX100, signed by the #1 Juniper Engineer
  </p>
</div>

<a href="http://www.scottyob.com/wp-content/uploads/2013/12/AirPort-Utility1.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="aligncenter size-full wp-image-353" alt="AirPort Utility" src="http://www.scottyob.com/wp-content/uploads/2013/12/AirPort-Utility1.jpg" width="697" height="667" /></a>

<a href="http://www.scottyob.com/wp-content/uploads/2013/12/AirPort-Utility-2.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="aligncenter size-full wp-image-356" alt="AirPort Utility-2" src="http://www.scottyob.com/wp-content/uploads/2013/12/AirPort-Utility-2.jpg" width="580" height="581" /></a>

In not so many words, performing these actions will do a number of things.  The gig ethernet switch on the back of the airport will be bridged with the WAN port.  Any traffic from your normal SSID(s) and switchports will be sent out the WAN port _untagged._  Traffic from your guest network will be sent .1q tagged with vlan 1003.

I popped this into fe-0/0/1 on my SRX100 and the following config works the magic.

```[interfaces]
    fe-0/0/1 {
        unit 0 {
            family ethernet-switching {
                port-mode trunk;
                vlan {
                    members vlan-guest;
                }
                native-vlan-id 3;
            }
        }
    }

    vlan {
        unit 0 {
            family inet {
                address 10.0.1.1/24;
            }
        }
        unit 1003 {
            family inet {
                filter {
                    input limit_guest_upload;
                    output limit_guest_download;
                }
                address 10.0.2.1/24;
            }
        }
    }

[system services]
        dhcp {
            pool 10.0.1.0/24 {
                address-range low 10.0.1.2 high 10.0.1.199;
                router {
                    10.0.1.1;
                }
            }
            pool 10.0.2.0/24 {
                address-range low 10.0.2.2 high 10.0.2.254;
                router {
                    10.0.2.1;
                }
            }
            propagate-settings fe-0/0/0.0;
        }

[security]
    nat {
        source {
            rule-set private-to-internet {
                from zone [ guest trust ];
                to zone untrust;
                rule source-nat-rule {
                    match {
                        source-address 0.0.0.0/0;
                    }
                    then {
                        source-nat {
                            interface;
                        }
                    }
                }
            }
        }
    }
    policies {
        from-zone trust to-zone untrust {
            policy trust-to-untrust {
                match {
                    source-address any;
                    destination-address any;
                    application any;
                }
                then {
                    permit;
                }
            }
        }
        from-zone guest to-zone untrust {
            policy guest-to-internet {
                description "Allows guest access to internet";
                match {
                    source-address any;
                    destination-address any;
                    application any;
                }
                then {
                    permit;
                }
            }
        }
    }

[security zones]
        security-zone guest {
            host-inbound-traffic {
                system-services {
                    dns;
                    ping;
                    traceroute;
                }
            }
            interfaces {
                vlan.1003;
            }
        }

firewall {
    policer guest-shaping {
        if-exceeding {
            bandwidth-limit 500k;
            burst-size-limit 300k;
        }
        then discard;
    }
    filter limit_guest_download {
        term guest-shaping {
            then {
                policer guest-shaping;
                accept;
            }
        }
    }
    filter limit_guest_upload {
        term guest-shaping {
            then {
                policer guest-shaping;
                accept;
            }
        }
    }
}
vlans {
    vlan-guest {
        vlan-id 1003;
        l3-interface vlan.1003;
    }
    vlan-trust {
        vlan-id 3;
        l3-interface vlan.0;
    }
}

```

And there you have it! A really simple way of limiting the bandwidth of guest users on your network using the power of Junos with an Airport Extreme!

&nbsp;

<p style="text-align: center;">
  <a href="http://www.scottyob.com/wp-content/uploads/2013/12/photo-2.png" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="aligncenter  wp-image-364" alt="Throttled Speed" src="http://www.scottyob.com/wp-content/uploads/2013/12/photo-2.png" width="384" height="576" /></a>
</p>
