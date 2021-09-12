#!/bin/bash

#print out usage
if [ $# -ne 2 ]
then
        echo "Usage: snapshot.sh [snapName] [max]"
        echo "  eg. snapshot.sh hour 24"
fi

#if the max snapshot already exists, just delete it
if [ `zfs list -t snapshot | grep datastore@$1.$2 | wc -l` -eq 1 ]
then
        zfs destroy -r datastore@$1.$2
fi

#
for ((i=$2-1; i >= 0; i--)); do
        if [ `zfs list -t snapshot | grep datastore@$1.$i | wc -l` -eq 1 ]
        then
                #this snapshot exists, so we want to move it up one
                zfs rename -r datastore@$1.$i @$1.$[$i+1]
        fi
done

zfs snapshot -r datastore@$1.0
