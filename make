#!/bin/bash

today=$(date +"%Y%m%d")
releasever=$1
title=Hawaii
product=hawaii

if [ -z "$releasever" ]; then
    echo "Usage: $0 <releasever>"
    exit 1
fi

kspath=/tmp/hawaii-livecd-$$.ks
ksflatten -c hawaii-livecd.ks -o $kspath || exit 1

sudo livecd-creator --releasever=${releasever} -c $kspath -f hawaii-${today}-x86_64 --title=${title} --product=${product}
#sudo setarch i386 livecd-creator --releasever=${releasever} -c $kspath -f hawaii-${today}-x86 --title=${title} --product=${product}

rm -f $kspath
