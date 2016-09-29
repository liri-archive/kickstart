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

%include /usr/share/spin-kickstarts/fedora-live-base.ks
#%include repos/rpmfusion-free.ks
#%include repos/rpmfusion-nonfree.ks
%include repos/lirios.ks
%include remix.ks
%include ux-packages.ks
%include desktop-packages.ks
%include multimedia-packages.ks
%include minimization.ks
%include snippets/desktop-ux.ks
%include snippets/cleanup.ks
%include snippets/logging.ks

selinux --permissive

#part / --size 4400

# Chromium
#repo --name="Copr repo for chromium owned by spot" --baseurl=https://copr-be.cloud.fedoraproject.org/results/spot/chromium/fedora-$releasever-$basearch/ --cost=1000

%packages

@base-x
@core
@fonts
@guest-desktop-agents
@hardware-support
@multimedia
@networkmanager-submodules
@printing

# Use calamares instead of anaconda
calamares

# Login manager
sddm

# QXL video driver for Xorg (until SDDM has a Wayland greeter)
xorg-x11-drv-qxl

# Additional packages that would make the image reacher
fuse
pavucontrol

# Make sure we have everything for plymouth
plymouth-scripts

# Themes and settings
sddm-theme-lirios
plymouth-theme-lirios
lirios-settings

%end

%post

# Set Plymouth theme
plymouth-set-default-theme lirios

# Regenerate initramfs to pickup the new Plymouth theme
dracut --regenerate-all --force

#
# Calamares have problems running on Wayland:
# - By default Qt applications run with the xcb QPA plugin,
#   so we need to make sure it will use wayland QPA.
# - Wayland clients need $XDG_RUNTIME_DIR in order to connect
#   to the compositor but pkexec won't propagate that
# To fix these issues we make a script and change the
# desktop entry to use that instead of the executable.
#

cat > /usr/bin/calamares-wayland <<EOF
#!/bin/sh
export XDG_RUNTIME_DIR=/run/user/\$PKEXEC_UID
export QT_QPA_PLATFORM=wayland
export WAYLAND_DISPLAY=greenisland-seat0
exec /usr/bin/calamares -platform wayland
EOF
chmod 755 /usr/bin/calamares-wayland

cat > /usr/share/applications/calamares.desktop <<EOF
[Desktop Entry]
Type=Application
Version=1.0
Name=Install to Hard Disk Drive
#Exec=pkexec /usr/bin/calamares-wayland
Exec=sudo -E /usr/bin/calamares --platform wayland
Icon=drive-harddisk
Terminal=false
StartupNotify=false
Categories=Qt;System;
OnlyShowIn=X-Liri;
EOF
#############################################################################

%end
