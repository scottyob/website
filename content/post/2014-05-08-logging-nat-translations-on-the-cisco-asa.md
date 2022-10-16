---
title: Logging NAT Translations on the Cisco ASA
author: scottyob
type: post
date: 2014-05-08T06:14:09+00:00
url: /2014/05/08/logging-nat-translations-on-the-cisco-asa/
categories:
  - Uncategorized

---
It&#8217;s often handy when dealing with infringement notices and the like to have NAT translations logged.  Sure a better way would be to record netflow from these devices (and include the translations) but for a quick syslog solution, you can always:

```
logging enable
logging list ToSyslog level critical
logging list ToSyslog message 305011
```

See <a href="http://www.cisco.com/c/en/us/td/docs/security/pix/pix63/system/message/63syslog/pixemsgs.html#wp1054604" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.cisco.com']);">http://www.cisco.com/c/en/us/td/docs/security/pix/pix63/system/message/63syslog/pixemsgs.html#wp1054604</a>

Messages will look something like:

```
May 08 13:01:20 freewifi-asa.net.uow.edu.au %ASA-6-305011: Built dynamic TCP translation from inside:10.64.37.96/53008 to outside:192.131.251.2/49520
```

&nbsp;
