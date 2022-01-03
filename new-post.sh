#!/bin/bash

date="$(date +'%Y-%m-%d')"
mkdir "content/posts/$date-$1"
filename="content/posts/$date-$1/index.md"

echo "---" > $filename
echo "title: '$1'" >> $filename
echo "type: post" >> $filename
echo "author: scottyob" >> $filename
echo "date: $date" >> $filename
echo "categories:" >> $filename
echo " - nerd" >> $filename
echo "tags:" >> $filename
echo " - someTag" >> $filename
echo  >> $filename
echo "---" >> $filename
