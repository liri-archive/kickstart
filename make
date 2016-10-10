#!/bin/bash

today=$(date +"%Y%m%d")
releasever=$1
title="Liri OS"
product="lirios"
imgname=${product}-${today}-x86_64
isofilename=${imgname}.iso
checksumfilename=${imgname}-CHECKSUM

if [ -z "$releasever" ]; then
    echo "Usage: $0 <releasever>"
    exit 1
fi

kspath=/tmp/${product}-livecd-$$.ks
ksflatten --config=${product}-livecd.ks -o $kspath || exit 1

livecd-creator --releasever=${releasever} --config=$kspath --fslabel="${imgname}" --title="${title}" --product="${product}"

rm -f $kspath

if [ ! -f ${isofilename} ]; then
    echo "ERROR: Failed to create ISO!"
    exit 2
fi

sha256sum -b --tag ${isofilename} > ${checksumfilename}

chown $SUDO_UID:$SUDO_GID ${isofilename}
