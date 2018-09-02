#
# This file is part of Liri.
#
# Copyright (C) 2015-2016 Pier Luigi Fiorini
#
# Author(s):
#    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#
# $BEGIN_LICENSE:GPL2+$
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# $END_LICENSE$
#

%include /usr/share/spin-kickstarts/fedora-arm-base.ks
%include repos/fedberry.ks
%include remix.ks
%include ux-packages.ks
%include desktop-packages.ks
%include multimedia-packages.ks
%include minimization.ks
%include mobile-minimization.ks
%include snippets/desktop-ux.ks
%include snippets/cleanup.ks
%include snippets/logging.ks

# Disable hard disk related services
services --enabled=ssh,NetworkManager,avahi-daemon,rsyslog,chronyd --disabled=network,lvm2-monitor,dmraid-activation

# System bootloader configuration
# Define how large you want your rootfs to be
# NOTE: /boot and swap MUST use --asprimary to ensure '/' is the last partition in order for rootfs-resize to work.
bootloader --location=boot

# Need to create logical volume groups first then partition
part /boot --fstype="vfat" --size 256 --label=BOOT --asprimary
part swap --fstype="swap" --size 1024 --asprimary
part / --fstype="ext4" --size 3200 --grow --label=rootfs --asprimary
# Note: the --fsoptions & --fsprofile switches don't seem to work at all!
#  <SIGH> Need to edit fstab in %post :-(

%packages

# Additional packages that would make the image reacher
fuse

# SDDM is too slow on Raspberry Pi, until I have a greeter
# working on Wayland we can't do a graphical login
-sddm
-sddm-theme-lirios

# FedBerry specific packages
fedberry-repo
python-rpi-gpio
raspberrypi-local
raspberrypi-vc-utils
raspberrypi-vc-libs

# We'll want to resize the rootfs on first boot
rootfs-resize

%end

%post

# Work around for poor key import UI in PackageKit
rm -f /var/lib/rpm/__db*
releasever=$(cat /etc/os-release |grep VERSION_ID |sed 's/VERSION_ID=//')
basearch=armhfp
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpi2

# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

# Having /tmp as tmpfs helps extend lifespan of SDCards but it must be limited to 100MB
echo "Setting size limit of 100M for tmpfs for /tmp."
echo "tmpfs /tmp tmpfs    defaults,noatime,size=100m 0 0" >>/etc/fstab

# Ensure we are using custom RPi2 kernel and firmware
sed -i '/skip_if_unavailable=False/a exclude=kernel* bcm283x-firmware' /etc/yum.repos.d/fedora-updates.repo

# Tweak boot options
echo "Modifying cmdline.txt boot options"
sed -i 's/nortc/elevator=deadline nortc libahci.ignore_sss=1 raid=noautodetect/g' /boot/cmdline.txt

# Resize root partition on first boot
echo "Enabling resizing of root partition on first boot"
touch /.rootfs-repartition
touch /.resized

%end
