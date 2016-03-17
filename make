#!/bin/bash

today=$(date +"%Y%m%d")
releasever=$1
title=Hawaii
product=hawaii
imgname=hawaii-${today}-x86_64
isofilename=${imgname}.iso
checksumfilename=${imgname}-CHECKSUM

if [ -z "$releasever" ]; then
    echo "Usage: $0 <releasever>"
    exit 1
fi

kspath=/tmp/hawaii-livecd-$$.ks
ksflatten -c hawaii-livecd.ks -o $kspath || exit 1

sudo livecd-creator --releasever=${releasever} -c $kspath -f ${imgname} --title=${title} --product=${product}
#sudo setarch i386 livecd-creator --releasever=${releasever} -c $kspath -f hawaii-${today}-x86 --title=${title} --product=${product}

rm -f $kspath

if [ ! -f ${isofilename} ]; then
    echo "ERROR: Failed to create ISO!"
    exit 2
fi

sha256sum -b --tag ${isofilename} > ${checksumfilename}

sudo chown $SUDO_UID:$SUDO_GID ${isofilename}
