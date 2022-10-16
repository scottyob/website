---
title: Symfony not sortable in CRUD
author: scottyob
type: post
date: 2011-01-01T12:15:37+00:00
url: /2011/01/01/symfony-not-sortable-generate-admin-crud/
categories:
  - nerd
tags:
  - AdminGenerator
  - Symfony

---
<p style="clear: both">
  I&#8217;ve recently come up across some problems with the CRUD generator in Symfony, so in case anyone is googling for a solution out there, I&#8217;ll try and help you along (or at least bump up the page references to the articles that helped me 😉 )
</p>

<p style="clear: both">
  I had a problem today where I was trying to use Symfony&#8217;s (1.4) generate-admin <a href="http://en.wikipedia.org/wiki/Create,_read,_update_and_delete#User_interface" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://en.wikipedia.org']);">CRUD</a> generator. The issue was that my titles were not sortable when adjusting the fields to display in the generator.yml file
</p>

<blockquote style="clear: both">
  <p>
    config:<br /> actions: ~<br /> fields: ~<br /> list:<br /> batch_actions: {}<br /> object_actions: {}<br /> display: [pin, <strong>firstName</strong>, <strong>lastName</strong>, location, institution]<br /> filter:<br /> display: [firstName, lastName]<br /> form: ~<br /> edit: {}<br /> new: {}
  </p>
</blockquote>

<p style="clear: both">
  The issue with the firstName and lastName fields is that, if written like <strong>first_name</strong> and <strong>last_name</strong> it will fail to become sortable. I found a solution as to why in a <a href="http://oldforum.symfony-project.org/index.php/t/22636/" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://oldforum.symfony-project.org']);">blog post</a> from a man with the same issue (Symfony 1.2)
</p>

<p style="clear: both">
  <strong>Foreign keys not Sortable:<br /></strong>Another issue I had was where there is a foreign key in Symfony, the CRUD generator won&#8217;t know how to make this sortable. I solved this by moving to <a href="http://www.symfony-project.org/plugins/ahAdminGeneratorThemesPlugin" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.symfony-project.org']);" title="">ahAdminGeneratorThemesPlugin</a> for the generate-admin modules.. Read the read-me in that guide and you&#8217;ll be sweet! 🙂
</p>

<p style="clear: both">
  <strong>Also See</strong>
</p>

<ul style="clear: both">
  <li>
    An interesting post on doing more with the admin generator <a href="http://blog.centresource.com/2010/01/13/code-that-saves-the-day-symfony-admin-generator/" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://blog.centresource.com']);">http://blog.centresource.com/2010/01/13/code-that-saves-the-day-symfony-admin-generator/</a>
  </li>
  <li>
    Jobeet Backend Modules page (Very useful) <a href="http://www.symfony-project.org/jobeet/1_4/Doctrine/en/12" onclick="javascript:_gaq.push(['_trackEvent','outbound-article','http://www.symfony-project.org']);">http://www.symfony-project.org/jobeet/1_4/Doctrine/en/12</a>
  </li>
</ul>

<br class="final-break" style="clear: both" />
