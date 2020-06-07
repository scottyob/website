---
title: Backup your site!
author: scottyob
type: post
date: 2010-10-09T14:31:22+00:00
url: /2010/10/09/backup-your-site/
categories:
  - nerd
tags:
  - backups

---
In my previous post I mentioned how I didn&#8217;t back up or migrate any of my data before we stopped paying the hosting company, so it&#8217;s all lost.

This has me thinking how much of a shame it would be if I build a wealth of information or a blog that I can use to identify myself and my work, only to have it go if the machine it&#8217;s hosted on dies. That would be bad, so this post is a short tutorial on how perform nightly backups of your website without you having to lift a finger.
<strong>About</strong><br />This method uses <a href="http://en.wikipedia.org/wiki/Rsync" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://en.wikipedia.org']);" title="About Rsync">rsync</a> to transfer files (including a dump of the database) to another machine so you&#8217;ve got a live backup should things turn pear shaped. In this short tutorial, we&#8217;ll be transfering files from our &#8216;<em>webhost</em>&#8216; server to our <em>backuphost </em>server
<strong>Step 1. SSH RSA KEYS</strong><br />We will be using ssh to transfer, securely, the data between our two hosts. Because this is a scripted and automated method, we can&#8217;t be there to type in a password each time we wish to run the backups. So we&#8217;ll be using a <a href="http://en.wikipedia.org/wiki/RSA" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://en.wikipedia.org']);">RSA public/private</a> key pair for secure authentication. This will allow us password-less authentication for ssh sessions, transferring files with scp, etc.<br />First, log in to the <em>webhost</em> where we can generate the local public and private keys.
<blockquote style="clear: both">

$ ssh-keygen -t rsa

</blockquote>

This will prompt you for a location to save the key and a passphrase, you can just enter past those and accept all the defaults.

Our next step is to transfer the public key across to our backup server.

<blockquote style="clear: both">

$ ssh-copy-id -i ~/.ssh/id_rsa.pub backupUser@backupserver.com

</blockquote>


Site Note on using OSX or disto where you don&#8217;t have ssh-copy-id.. This will work just as well


<blockquote style="clear: both">

cat ~/.ssh/id_rsa.pub | ssh backups@backupserver.com &#8220;cat &#8211; >> ~/.ssh/authorized_keys&#8221;

</blockquote>

This will prompt you for the login password for the host, then copy the <br />keyfile for you, creating the correct directory and fixing the permissions as necessary.


Now test to make sure you can log into the <em>backupserver</em> without requiring a password.



<strong>Step 2. Creating the backup script</strong><br />I made a backup script (backup.sh, me sure to &#8216;chmod u+x backup.sh&#8217; once it&#8217;s been created) to run through these few backup procedures. The first step is to do a dump of the database to file. You could very well host an SQL server on the other side and mirror the database to get things up and running faster, but that was overkill for my needs.. Besides, always remember there are many ways to skin a cat and this one seemed to work nice for all intents and purposes.



The backup script has two parts in it, basically do a dump of the database, then copy that over to the server as well as all the public_html or htdocs or where you put your public hosted files.

```bash
echo "Running backup script"
echo "Running a dump of the database.."
mysqldump user=scottyob password=somePassword all-databases > /var/www/scottyob.com/backup/database.dump #backup of database
echo "Syncing the backup directory.."
rsync -a -e ssh /var/www/scottyob.com/backup/ backups@backuphost.com:backups/<br />rsync -a -e ssh /var/www/scottyob.com/htdocs/ backups@backuphost.com:htdocs/
echo "Backup made on " `date` >> /var/www/scottyob.com/backuplog.txt
```

And there you have it, a script to backup your website to a user &#8216;backups&#8217; on the server &#8216;backuphost.com&#8217;



<strong>Step 3. Automated..ness</strong>



This is no good for me unless it&#8217;s automated. I just ran this script under a <a href="http://www.unixgeeks.org/security/newbie/unix/cron-1.html" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.unixgeeks.org']);">cron job</a> to automate this procedure



Edit your cron file using


<blockquote style="clear: both">

$ crontab -e

</blockquote>


Then I told it that at one minute past midnight, it should backup my website every day (add the following line)


<blockquote style="clear: both">

1 0 * * * /var/www/scottyob.com/backup.sh

</blockquote>


And there we have it folks, my backup procedure now so my site will never have to be started from scratch again.



<br class="final-break" style="clear: both" />

