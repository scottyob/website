---
title: PDF Automator in OSX
author: scottyob
type: post
date: 2011-01-17T00:09:46+00:00
url: /2011/01/16/pdf-automator-in-osx/
categories:
  - nerd
tags:
  - OSX

---
<p style="clear: both;">
  As you may have been aware from my previous blog posts, I&#8217;ve been trying to make my life digital, that means any papers I get, I scan and file on a FileServer (with remote backups, etc, etc).
</p>

<p style="clear: both;">
  My scanner at home has a document feeder on it. The problem is that it doesn&#8217;t do duplex, only a set of sides. So far, I can scan one side of the document, flip the paper of, then scan the back pages. This will result two PDF&#8217;s with two sets of pages<br /> Set A: 1,3,5,7<br /> SET B: 8,6,4,2
</p>

<p style="clear: both;">
  To merge the two, I could open them both up in Adobe PDF, Preview and start clicking and dragging my time away, but that&#8217;s pointless. I&#8217;d like to introduce you to Automator in OSX.
</p>

<p style="clear: both;">
  <a class="image-link" href="http://www.scottyob.com/wp-content/uploads/2011/01/Merge_Duplex_PDFs.jpg" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.scottyob.com']);"><img class="linked-to-original" style="text-align: center; display: block; margin: 0 auto 10px;" src="http://www.scottyob.com/wp-content/uploads/2011/01/Merge_Duplex_PDFs-thumb.jpg" alt="" width="380" height="314" /></a>Using a <a href="http://fredericiana.com/2010/03/01/pdftk-1-41-for-mac-os-x-10-6/" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://fredericiana.com']);">pdftk binary for OSX</a> and the automator script above, all I need to do now is select my two pdf documents (Set A & B), right hand click, then select &#8216;Duplex Merge PDF&#8217;s&#8217;. After that, I&#8217;ll have a nice merged.pdf file on my desktop that&#8217;s the resulting page.
</p>

<p style="clear: both;">
  (the shell script uses pdftk to make a /tmp/2.pdf file that&#8217;s a set 2,4,6,8. Copies the Set A to /tmp/1.pdf and then pipes it through some pdf tools built into OSX to merge the sets into 1,2,3,4.. etc
</p>

<p style="clear: both;">
  Who needs to spend lots of money on a duplex scanner hey?
</p>

**EDIT:
  
** Please feel free to <a href="http://www.scottyob.com/wp-content/uploads/2011/01/osxDuplexAutomator.zip" onclick="javascript:_gaq.push(['_trackEvent','download','http://www.scottyob.com/wp-content/uploads/2011/01/osxDuplexAutomator.zip']);">download my automator scripts here </a>

&nbsp;
