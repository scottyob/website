---
title: Address Book For the Blind
author: scottyob
type: post
date: 2012-11-09T00:32:51+00:00
url: /2012/11/08/address-book-for-a-the-blind/
categories:
  - nerd
tags:
  - asterisk
  - voip

---
This article is about using the <a href="http://www.asterisk.org" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.asterisk.org']);">Asterisk PBX</a> and exploiting <a href="http://www.google.com/insidesearch/features/voicesearch/index.html" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.google.com']);">Google&#8217;s voice recognition </a>API built for voice search in Chrome to build an address book that technology inept people (my grandmother) can use to place cheap telephone calls over VoIP.

This tool is built for my grandmother; a lady who has <a href="http://www.mdfoundation.com.au" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.mdfoundation.com.au']);">macular degeneration</a> making her legally blind.  She doesn&#8217;t want to invest a great deal of money in this solution or have much of a learning curve, it took long enough to get her using the two button audio book solution on the iPod.  <!--more-->The basic idea is to purchase a direct inward dialing (DID) number and program it into her speed dial, this will connect to an Asterisk virtual machine that will launch the voice recognition to listen to who she wants to dial, look up the number in her address book then connect the call through, all at the rate of about $0.11 for a national call (actually saving her money!).

I&#8217;m using the <a href="http://zaf.github.com/asterisk-speech-recog/" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://zaf.github.com']);">Speech Recognition for Asterisk</a> module to convert the spoken recording to a string.  The problem with the method using this library for an address books is different words being returned that are pronounced very similar to the names in the book, for instance trying to find the name &#8216;elmer&#8217; returned &#8216;Alma&#8217;.  With a bit of python scripting to use <a href="http://www.doughellmann.com/articles/how-tos/phonetic-hashing/index.html" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.doughellmann.com']);">fuzzy matching to search by sound with python</a> we can start to compare what our speech recognition engine returned with what we actually have in our address book. It must be noted that this method only works for a small set of different numbers in an address book, which although fits my grandmother fine, I plan to script the server so I can always make that magic button (DID speed dial) re-direct the call to anywhere I like.

``` import fuzzy
 dmetaphone = fuzzy.DMetaphone(3)
 dmetaphone('Alma')
['ALM', None]
 dmetaphone('Elmer')
['ALM', None]
 dmetaphone('Toss')
['TS', None]
 dmetaphone('Scott')
['SKT', None]
 dmetaphone('Troy')
['TR', None]
 dmetaphone('Sue')
['S', None]
 dmetaphone('Janet')
['JNT', 'ANT']
```

So, to execute the plan, I&#8217;m using an account on <a href="https://www.mynetfone.com.au" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.mynetfone.com.au']);">Mynetfone</a>.  The extensions.conf has a script to answer the call on my purchased DID, prompt for who she wants to talk to, run it through speech recognition, then call the number in her address book through a python script.  The extensions.conf that makes this magic happen looks like this:

```[MyNetFone]
; Phone call is made to the service, welcome user and get their speech
exten = 0920xxxx,1,Answer()
exten = 0920xxxx,1,Wait(2)
exten = 0920xxxx,n,agi(googletts.agi, "Hello Miss Duckworth", en)
exten = 0920xxxx,n,agi(googletts.agi, "I am here to attempt to make your social life easier.", en)
exten = 0920xxxx,n(intro),agi(googletts.agi, "Who would you like to talk to?", en)
exten = 0920xxxx,n,agi(speech-recog.agi, en-US)

; Look up number in address book, write debug information then go to the required section
exten = 0920xxxx,n,agi(address-book.agi,${utterance})
exten = 0920xxxx,n,Verbose(1,The text you just said is: ${utterance})
exten = 0920xxxx,n,Verbose(1,The probability to be right is: ${confidence})
exten = 0920xxxx,n,Verbose(1, ${foundname})
exten = 0920xxxx,n,Verbose(1, ${todial})
exten = 0920xxxx,n,GotoIf($["${foundname}" = "1"]?success:fail)

; Name not found in the address book
exten = 0920xxxx,n(fail),agi(googletts.agi,"Sorry, I could not find the person ${utterance} in the address book", en)
exten = 0920xxxx,n,agi(googletts.agi, "Please feel free to try again",en)
exten = 0920xxxx,n,Goto(intro)

; Connect the user through the MyNetFone service.
exten = 0920xxxx,n(success),agi(googletts.agi, "Please hold while I connect you to", en)
exten = 0920xxxx,n,agi(googletts.agi, "${utterance}", en)
exten = 0920xxxx,n,Dial(SIP/MyNetFone/${todial}, 30)
exten = 0920xxxx,n,Hangup()
```

and the python script address-book.agi file:

```#!/usr/bin/python

import sys
import fuzzy

# Read and ignore AGI environment (read until blank line)

addressBook = {
   'scott': '0415xxxxxx',
   'susan': '98xxxxxx',
   'support': '181'
}

dmetaphone = fuzzy.DMetaphone(3)

env = {}
tests = 0;

while 1:
   line = sys.stdin.readline().strip()

   if line == '':
      break
   key,data = line.split(':')
   if key[:4] &lt; 'agi_':
      #skip input that doesn't begin with agi_
      sys.stderr.write("Did not work!\n");
      sys.stderr.flush()
      continue
   key = key.strip()
   data = data.strip()
   if key &lt; '':
      env[key] = data

spokenWord = dmetaphone(env['agi_arg_1'])

for name in addressBook:
   if dmetaphone(name) == spokenWord:
      print 'SET VARIABLE todial "%s"' % addressBook[name]
      print 'SET VARIABLE foundname "1"'
      sys.exit(0)
print 'SET VARIABLE foundname "0"'
```
