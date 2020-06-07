---
title: 2. Installing the Operating System
author: scottyob
type: post
date: 2011-03-16T11:09:50+00:00
url: /2011/03/16/2-installing-the-operating-system/
categories:
- FileServer
tags:
- fileserver
- ZFS
---
<strong><em>Note: This post is one in a series aimed to be a tutorial eventually, it’s not currently finalised and at the moment exists as a place for collating thought and collecting feedback</em></strong>
## Installing OS and setup Network
For the following set of posts, I have chosen to use VirtualBox to run through how to use ZFS in building your FileSystem. The first step is downloading and installing OpenIndiana. Get the latest build from <a href="http://openindiana.org/download/" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://openindiana.org']);">http://openindiana.org/download/</a> (at the time of writing, I’m using oi-dev-148-x86) and install it onto your system. In VirtualBox I chose to install onto a 64 bit Solaris setup.
Make a hard disk when you’re setting up your VM image (I called mine OS_SSD1 because the HD is eventually going to be installed onto a solid state drive.)
Now, the VM is booted, we can start having some fun (SSH into it and Away we go)
Our first step is to setup the address for the box. I must admit, I’m pretty new to Solaris but from what I’ve found, we’ll run these commands to disable Auto Configuration via DHCP then enable our static config.
```
svcadm disable physical:nwam <br />svcadm enable physical:default
```
My fileserver is currently not on a domain (I’ll change this later), so I’ve added the line into my /etc/hosts file
```
10.12.1.1 thumper.local thumper
```
Put your hostname that you want to use (‘thumper’ for me) in /etc/nodename
Your default gateway (routers) address should go in /etc/defaultrouter
The last thing to do is tell the host about what subnet it’s on, For me, I added (for my server subnet)
```
10.12.1.0 255.255.255.0
```
The next step is set up your nameserver for DNS (/etc/resolv.conf) mine looks like this
```
nameserver 10.12.1.254
```
Copy /etc/nsswitch.dns to /etc/nsswitch.conf &#8211; so dns is used.
Now so the adaptor comes up on boot, find out the status of your network I/O by running
```
dladm show-link
```
(for me was e1000g0). Once you have this, you need to ‘plumbe” to set up the software in the kernel to set this interface on the TCP/IP stack.
```
ifconfig e100g0 plumb <br />echo 10.12.1.1/24 > /etc/hostname.e100g0
```
Last but not least for your network stack,
```
svcadm restart milestone/network
```
From this point on, that concludes the base setup with networking that I’m using for the FileServer. If this happened to be a critical server for you, perhaps you’d consider setting up <a href="http://darkstar-solaris.blogspot.com/2008/09/zfs-root-mirror.html" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://darkstar-solaris.blogspot.com']);">redundant bootable drives with ZFS</a>. It looks pretty cool.
<h2>
Setting up the storage pool
</h2>
Now we can get into the fun part. The first thing I want to do with this server is be able to store my data on it, so lets set up our storage pool. In my VM I’m using to test this I’ve added the disks I want to include in my pool (1GB disks for this test)
<a href="http://www.scottyob.com/wp-content/uploads/2011/03/image.png" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);" class="image-link"><img src="http://www.scottyob.com/wp-content/uploads/2011/03/image_thumb.png" height="377" width="487" style=" text-align: center; display: block; margin: 0 auto 10px;" /></a>Once we’ve booted out VM (first thing I always do is ‘sudo bash’ because I’m evil in these silly little test environments).
I want to find out the device ID’s for these hard disks I just added
```
root@thumper:~# iostat -En | egrep Size\|Soft <br />c1t0d0 Soft Errors: 0 Hard Errors: 6 Transport Errors: 0 <br />Size: 0.00GB <0 bytes> <br />c1t1d0 Soft Errors: 0 Hard Errors: 0 Transport Errors: 0 <br />Size: 17.18GB <17179869184 bytes> <br />c1t2d0 Soft Errors: 0 Hard Errors: 0 Transport Errors: 0 <br />Size: 1.07GB <1073741824 bytes> <br />c1t3d0 Soft Errors: 0 Hard Errors: 0 Transport Errors: 0 <br />Size: 1.07GB <1073741824 bytes> <br />c1t4d0 Soft Errors: 0 Hard Errors: 0 Transport Errors: 0 <br />Size: 1.07GB <1073741824 bytes> <br />c1t5d0 Soft Errors: 0 Hard Errors: 0 Transport Errors: 0 <br />Size: 1.07GB <1073741824 bytes>
```
As we can see, c1t0d0 is my CD-ROM drive, c1t1d0 is my hard disk, so I’ll want to create a Raidz-2 (two redundant drive) storage pool with the drives c1t2d0 c1t3d0 c1t4d0 c1t5d0
```
root@thumper:~# <strong>zpool create datastore raidz2 c1t2d0 c1t3d0 c1t4d0 c1t5d0 <br /></strong>root@thumper:~# zpool list <br />NAME SIZE ALLOC FREE CAP DEDUP HEALTH ALTROOT <br /><strong>datastore 3.94G 256K 3.94G 0% 1.00x ONLINE</strong> &#8211; <br />rpool 15.9G 4.17G 11.7G 26% 1.00x ONLINE &#8211; <br />root@thumper:~# zfs list <br />NAME USED AVAIL REFER MOUNTPOINT <br /><strong>datastore 128K 1.93G 44.8K /datastore <br /></strong>rpool 4.52G 11.1G 45K /rpool <br />rpool/ROOT 3.61G 11.1G 31K legacy <br />rpool/ROOT/openindiana 3.61G 11.1G 3.58G / <br />rpool/dump 383M 11.1G 383M &#8211; <br />rpool/export 1002K 11.1G 32K /export <br />rpool/export/home 970K 11.1G 32K /export/home <br />rpool/export/home/scott 938K 11.1G 938K /export/home/scott <br />rpool/swap 544M 11.5G 187M &#8211;
```
We can see now we’ve created a pool of storage across our data (that’s zfs raided) that gives us double parity so we can loose two drives and still be running and we’ve got 2GB of usable space here (I’m using 1GB hard disks, in my real production box these will be 1TB disks).
Other posts to come in the series: <br />1. Selecting the hardware <br />2. Installing the Operating System <br />3. Setting up File systems &#038; Snapshots <br />4. Allowing access through NFS &#038; SAMBA <br />5. Setting up encrypted off-site backups <br />6. Configuring Windows &#038; Linux clients to dump backup info to the FileServer <br />7. My router setup, configuring IP tables &#038; torrents on a low-powered server.
<br class="final-break" style="clear: both" />

