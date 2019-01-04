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
%include repos/liri.ks
%include repos/liri-nightly.ks
%include remix.ks
%include ux-packages.ks
%include desktop-packages.ks
%include multimedia-packages.ks
%include minimization.ks
%include snippets/desktop-ux.ks
%include snippets/cleanup.ks
%include snippets/logging.ks

selinux --permissive

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
liri-calamares-branding

# Calamares needs the locales available to offer them to the user
glibc-all-langpacks

# Login manager
sddm

# QXL video driver for Xorg (until SDDM has a Wayland greeter)
xorg-x11-drv-qxl

# Additional packages that would make the image reacher
fuse

# Make sure we have everything for plymouth
plymouth-scripts

# Themes and settings
sddm-theme-lirios
plymouth-theme-lirios
lirios-customization

%end

%post

# Set Plymouth theme
plymouth-set-default-theme lirios

# Regenerate initramfs to pickup the new Plymouth theme
dracut --regenerate-all --force

# Fix Calamares on Wayland
cp -f /usr/share/liri-calamares-branding/calamares.desktop /usr/share/applications/calamares.desktop

%end
