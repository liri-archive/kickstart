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

%include /usr/share/spin-kickstarts/fedora-live-minimization.ks

%packages

### Miscellaneous

# Exclude unwanted groups that fedora-live-base.ks pulls in
-@dial-up
-@standard

# Other stuff
-@3d-printing

# We use Calamares instead of anaconda
-anaconda
-@anaconda-tools

### Space issues

# Fonts (we make no bones about admitting we're english-only)
wqy-microhei-fonts			# A compact CJK font, to replace:
-naver-nanum-gothic-fonts		# Korean
-vlgothic-fonts				# Japanese
-adobe-source-han-sans-cn-fonts		# Simplified Chinese
-adobe-source-han-sans-tw-fonts 	# Traditional Chinese

-paratype-pt-sans-fonts	# Cyrillic (already supported by DejaVu), huge
#-stix-fonts		# mathematical symbols

# Remove input methods to free space
-@input-methods
-scim*
-m17n*
-ibus*
-iok

# Use our wallpapers
-desktop-backgrounds-basic

# Save some space (from @standard)
-make

# Admin-tools
-gnome-disk-utility
-system-config-date
-system-config-services
-system-config-users

# Exclude unwanted packages from @anaconda-tools group
-gfs2-utils
-reiserfs-utils

# Remove unwanted packages
-setroubleshoot
-ibus

# Exclude Gtk+
-gtk2
-gtk3
-gtk4

# We have our own portal implementation
-xdg-desktop-portal-gtk

%end
