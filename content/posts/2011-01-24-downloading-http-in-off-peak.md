---
title: Downloading HTTP in off-peak
author: scottyob
type: post
date: 2011-01-25T00:38:18+00:00
url: /2011/01/24/downloading-http-in-off-peak/
categories:
  - nerd
tags:
  - debian
  - linux
  - wget

---
I want to write a quick and dirty blog post to tell you a little solution on downloading HTTP files in your off-peak usage using linux.

The tools I’ll be using for this is my old favourite <a href="http://www.gnu.org/software/wget/" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.gnu.org']);">wget</a> and a new tool, <a href="http://linux.about.com/library/cmd/blcmdl1_at.htm" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://linux.about.com']);">“at”</a>.

The at daemon is required to be running first, so on debian or ubuntu

> <font color="#484848">/etc/init.d/atd start</font>

Then downloading your file at an off-peak time (4am for me) is as simple as

> <font color="#484848">echo “wget –c <a href="http://ubuntu.virginmedia.com/releases//maverick/ubuntu-10.10-desktop-i386.iso" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://ubuntu.virginmedia.com']);">http://ubuntu.virginmedia.com/releases//maverick/ubuntu-10.10-desktop-i386.iso</a>” | at 04:00</font>

Simple hey <img style="border-bottom-style: none; border-right-style: none; border-top-style: none; border-left-style: none" class="wlEmoticon wlEmoticon-smile" alt="Smile" src="http://www.scottyob.com/wp-content/uploads/2011/01/wlEmoticon-smile.png" />
