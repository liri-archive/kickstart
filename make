#!/bin/bash

today=$(date +"%Y%m%d")
#releasever=f22
releasever=rawhide
title=Hawaii
product=hawaii

sudo livecd-creator --releasever=${releasever} -c live.ks -f hawaii-${today}-x86_64 --title=${title} --product=${product}
sudo setarch i386 livecd-creator --releasever=${releasever} -c live.ks -f hawaii-${today}-x86 --title=${title} --product=${product}
