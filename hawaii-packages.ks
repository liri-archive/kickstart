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

# Hawaii CI
repo --name="Hawaii CI" --baseurl=https://copr-be.cloud.fedoraproject.org/results/plfiorini/hawaii-ci/fedora-$releasever-$basearch/ --cost=1000

%packages

# Desktop
hawaii-shell
hawaii-system-preferences
hawaii-icon-theme
hawaii-widget-styles
hawaii-wallpapers
# remove once hawaii-shell has all the deps fixed
dbus-x11

%end
