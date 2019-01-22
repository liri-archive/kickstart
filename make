#!/bin/bash

curdir=`dirname $(readlink -f $0)`

today=$(date +"%Y%m%d")
title="Liri OS"
product="lirios"
imgname=${product}-${today}-x86_64
isofilename=${imgname}.iso
checksumfilename=${imgname}-CHECKSUM
cacherootdir=/var/cache/mkliriosimage

source $curdir/.settings

if [ -z "$releasever" ]; then
    echo "Fedora release not specified, please check your .settings"
    exit 1
fi

mkdir -p $cacherootdir

kspath=/tmp/${product}-livecd-$$.ks
ksflatten --config=${product}-livecd.ks -o $kspath || exit 1

livecd-creator --releasever=${releasever} --config=$kspath --fslabel="${imgname}" --title="${title}" --product="${product}" --cache=$cacherootdir/dnf

rm -f $kspath

if [ ! -f ${isofilename} ]; then
    echo "ERROR: Failed to create ISO!"
    exit 2
fi

sha256sum -b --tag ${isofilename} > ${checksumfilename}

chown $SUDO_UID:$SUDO_GID ${isofilename}
