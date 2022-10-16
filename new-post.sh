#!/bin/bash

Help()
{
    echo "Creates a new post given todays date"
    echo
    echo "Syntax: new-post.sh [postName]"
    echo
}

if [[ "$#" -ne 1 ||  $1 = \-* ]]
then
    Help
    exit 1
fi

date="$(date +'%Y-%m-%d')"
mkdir "content/post/$date-$1"
filename="content/post/$date-$1/index.md"

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
