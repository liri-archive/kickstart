# Hawaii from git
repo --name="Hawaii from git" --baseurl=https://copr-be.cloud.fedoraproject.org/results/plfiorini/hawaii-git/fedora-$releasever-$basearch/ --cost=1000

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
