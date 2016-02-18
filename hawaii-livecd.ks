#
# This file is part of Hawaii.
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
#%include rpmfusion-free.ks
#%include rpmfusion-nonfree.ks
%include repos/hawaii.ks
%include ux-packages.ks
%include desktop-packages.ks
%include multimedia-packages.ks
%include misc-packages.ks
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

# Additional packages that would make the image reacher
fuse
pavucontrol

# Themes and settings
sddm-theme-hawaii
plymouth-theme-hawaii
hawaii-settings

%end

%post

# Set Plymouth theme
plymouth-set-default-theme hawaii

# Regenerate initramfs to pickup the new Plymouth theme
dracut --regenerate-all --force

%end
