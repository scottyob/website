---
title: 3. Setting up FileSystems and Snapshots (part 2)
author: scottyob
type: post
date: 2011-03-24T18:17:20+00:00
url: /2011/03/24/3-setting-up-filesystems-and-snapshots-part-2/
categories:
  - FileServer
tags:
  - fileserver
  - ZFS

---

  <strong>Note: This post is one in a series aimed to be a tutorial eventually, it’s not currently finalised and at the moment exists as a place for collating thought and collecting feedback</strong>


In <a href="http://www.scottyob.com/?p=88" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);">part 1</a> of this blog post, I showed you how I created a script that would, when run, rotate your snapshots on a ZFS filesystem. For this to be usable, we need to create a mechanism for having it be automatically ran. We&#8217;ll do this with a cronjob.


  On Unix systems, the cron daemon is used to execute scheduled commands. Picture it much like windows task scheduler for all you windows kiddies.



  I saved the backup script we wrote yesterday to /FileStore/backups.sh. The first thing I want to get running is my hourly backups. To do this, we&#8217;ll start editing our cron file


```
  
    sudo crontab -e
  
```


  The crontab utility is a program used to edit the tables that drive the cron daemon.



  On my OSX box, information about how to set up the cron file can be found in &#8216;man 5 crontab&#8217;



  Basically, cron examines cron entries once every minute. the fields that we&#8217;ve got to play with are (in this order)


```
  
    field allowed values<br /> &#8212;&#8211; &#8212;&#8212;&#8212;&#8212;&#8211;<br /> minute 0-59<br /> hour 0-23<br /> day of month 1-31<br /> month 1-12 (or names, see below)<br /> day of week 0-7 (0 or 7 is Sun, or use names)
  
```


  Having said that, it&#8217;s time to think about when we want to create our snapshots. Because I intend machines to do their backups to the server on the hour, I&#8217;ll be creating my snapshots at half past the hour. My cron file now looks like this (for hourly snapshots with 24 rotations, daily snapshots with 7 rotations, Weekly snapshots with 4 rotations.


```
  
    #**Snapshots for the Filesystem**<br />30 * * * * /bin/bash /FileSystem/backups.sh hourly 24<br />30 6 * * * /bin/bash /FileSystem/backups.sh daily 7<br />30 6 * * sun /bin/bash /FileSystem/backups.sh weekly 4
  
```


  Now that that concludes our section on setting up my rotating snapshots.



  <strong>Other posts to come in the series:<br /></strong>1. Selecting the hardware<br />2. Installing the Operating System<br />3. Setting up File systems &#038; Snapshots<br />4. Allowing access through NFS &#038; SAMBA<br />5. Setting up encrypted off-site backups<br />6. Configuring Windows &#038; Linux clients to dump backup info to the FileServer<br />7. My router setup, configuring IP tables &#038; torrents on a low-powered server.


<br class="final-break" style="clear: both" />
