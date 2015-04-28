#!/bin/bash

today=$(date +"%Y%m%d")
#releasever=f22
releasever=rawhide
title=Hawaii
product=hawaii

kspath=/tmp/hawaii-livecd-$$.ks
ksflatten -c hawaii-livecd.ks -o $kspath >& /dev/null

sudo livecd-creator --releasever=${releasever} -c $kspath -f hawaii-${today}-x86_64 --title=${title} --product=${product}
sudo setarch i386 livecd-creator --releasever=${releasever} -c $kspath -f hawaii-${today}-x86 --title=${title} --product=${product}

rm -f $kspath
