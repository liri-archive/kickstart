#
# This file is part of Hawaii.
#
# Copyright (C) 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
#
# Author(s):
#    Pier Luigi Fiorini
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

%include /usr/share/spin-kickstarts/fedora-live-base.ks
%include /usr/share/spin-kickstarts/fedora-live-minimization.ks
#%include rpmfusion-free.ks
#%include rpmfusion-nonfree.ks
%include hawaii-packages.ks
%include desktop-packages.ks
%include multimedia-packages.ks

selinux --permissive

#part / --size 4400

# Chromium
#repo --name="Copr repo for chromium owned by spot" --baseurl=https://copr-be.cloud.fedoraproject.org/results/spot/chromium/fedora-$releasever-$basearch/ --cost=1000

%packages

# Exclude unwanted groups that fedora-live-base.ks pulls in
-@dial-up
-@input-methods
-@standard

@base-x
@core
@fonts
@guest-desktop-agents
@hardware-support
@multimedia
@networkmanager-submodules
@printing

# Use calamares instead of anaconda
-anaconda
calamares

# Login manager
sddm

# Exclude unwanted packages from @anaconda-tools group
-gfs2-utils
-reiserfs-utils

# Remove unwanted packages
-setroubleshoot
-ibus

# Additional packages that would make the image reacher
fuse
pavucontrol

%end

%post

# Set up login manager
cat > /etc/sddm.conf << EOF
[Theme]
Current=hawaii

[Autologin]
User=livesys
Session=hawaii
EOF

# sddm doesn't support wayland sessions yet
cp /usr/share/wayland-sessions/hawaii.desktop /usr/share/xsessions/hawaii.desktop

# Make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

%end