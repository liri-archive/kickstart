#!/bin/bash

arch="x86_64"

filename=`find . -type f -name "*-${arch}.iso" -exec stat -c '%X %n' {} \; | sort -nr | awk 'NR==1 {print $2}'`

if [ -z "$filename" ]; then
    echo "No ISO image found!"
    exit 1
fi

exec qemu-system-$arch -enable-kvm -m 2G -vga qxl -cdrom $filename
