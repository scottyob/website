---
title: 'Allowing access through NFS & SAMBA'
author: scottyob
type: post
date: 2011-04-04T11:53:32+00:00
url: /2011/04/04/allowing-access-through-nfs-samba/
categories:
  - FileServer
  - nerd
tags:
  - CIFS
  - NFS
  - ZFS
---
## 
<h2>
Cifs Share
</h2>

CIFS (Common Internet File System), the protocol windows users for all it’s ‘windows file sharing’ is the method I’ll allow for my desktops and roaming computers to access files on the file server.

Before we begin, Make sure we install the CIFS kernal modules
``` 
# pkg install SUNWsmbs # pkg install SUNWsmbskr
```
next we issue this command to make sure it auto starts
```
# svcadm enable -r smb/server
```
I&#8217;ve decided for every day use, I want a data store on the server, so..
```
# zfs create datastore/homes # zfs create datastore/homes/scott
```
now, set up compression on my home directory
```
# zfs set compression=on datastore/homes
```
Time to do some setup so we can log into this share, I&#8217;ll make the box join the workgroup &#8216;home
```
# smbadm join -w home
```
To start sharing with windows boxes, I need to change the pam.conf file to generate windows passwords too. Add the line below /etc/pam.conf
```
other password required pam_smb_passwd.so.1 nowarn
```
reset the password for my user scott, then I&#8217;ll be able to authenticate with him
```
# passwd scott
```
The next step is setting up guest access. You may remember we created a media share datastore/media. We want to share that with guests to the network (on the trusted subnet anyway). Before we go ahead and set that up, we want to map the windows Guest user to the unix user nobody.
```
# idmap add winname:Guest unixuser:nobody
```
then we&#8217;ll allow guest access to our media box
```
# zfs set sharesmb=name=media,guestok=true datastore/media
```
I also want to make my home directory only accessible by me, so I’m going to own the directory
```
chown scott /datastore/homes/scott chgrp staff /datastore/homes/scott chmod 700 /datastore/homes/scott
```
and share it
```
# zfs set sharesmb=name=scott datastore/homes/scott
```
So there we have it, a media folder anyone can access, and a ‘scott’ share that I’ll need to authenticate with (HOME\scott user)

<a href="/img/old/2011/03/image1.png" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);" class="image-link"><img src="/img/old/2011/03/image_thumb1.png" height="355" width="480" style=" text-align: center; display: block; margin: 0 auto 10px;" /></a>
<h2>
NFS Shares
</h2>

Now we’ve got CIFS set up for our clients, I want to set up NFS shares for other Linux boxes on the network (at this point, only my router) to be able to access. The idea is that my router will have all the home directories on the FileServer (so it’ll get the advantages of snapshots, etc) we well as not being limited to the dying 60GB hard disk for torrenting and such things.

As mentioned, I’m only interested in NFS shares with my router at this point, so we’ll make sure my routers IP address (10.12.1.254) is restricted in the shares.

The first thing we want to try is setting up the nfs mount on our homes directory.
```
# zfs set <a href="mailto:sharenfs=root=@10.12.1.254,rw=@10.12.1.254">sharenfs=root=@10.12.1.254,rw=@10.12.1.254</a> datastore/homes
```
Now, <strong>on my debian router box</strong> I want to see if I can mount this (assuming the directory /home2/scott exists on the client)

sudo mount -t nfs -o nfsvers=3 10.12.1.1:/datastore/homes/scott /home2/scott

and Ta-Da! My home directory is mounted. What I want to do now is to set up auto-mounts. That is, when a directory is accessed for my users home directory, it’d mount it on the fly.

First, install the autofs package
```
apt-get install autofs
```
Add the following line into <strong>/etc/auto.master</strong>
```
/home2 /etc/auto.home -–timeout=60
```
and the following into the file <strong>/etc/auto.home</strong>
```
* -fstype=nfs,rw,nosuid,soft,vers=3 server:/datastore/homes/&#038;
```
the <strong>*</strong> and /datastore/homes/&#038; do their magic by automatically mounting the required directory when needed (as long as the /etc/init.d/autofs is started)

Now lets add a place for our downloads
```
# zfs create datastore/media/downloads # zfs set sharenfs=root=router,rw=router datastore/media/downloads
```
I chose to just mount this using the automounter under the home2 directory, I added this to the <strong>/etc/auto.home</strong> file
```
downloads -fstype=nfs,rw,nosuid,soft,vers=3 10.12.1.1:/datastore/media/downloads
```
Pretty neat, now when you head to a directory that&#8217;s not mounted yet (like /home2/scott/) in the linux client, it will auto mount the required NFS volume and presto, we&#8217;ve got ourselves network storage.
<strong>Other posts to come in the series:</strong><br />1. Selecting the hardware<br />2. Installing the Operating System<br />3. Setting up File systems &#038; Snapshots<br />4. Allowing access through NFS &#038; SAMBA<br />5. Setting up encrypted off-site backups<br />6. Configuring Windows &#038; Linux clients to dump backup info to the FileServer<br />7. My router setup, configuring IP tables &#038; torrents on a low-powered server.
<br class="final-break" style="clear: both" />

