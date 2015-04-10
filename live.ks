%include /usr/share/spin-kickstarts/fedora-live-base.ks
%include /usr/share/spin-kickstarts/fedora-live-minimization.ks
%include hawaii-packages.ks
%include desktop-packages.ks
%include multimedia-packages.ks

selinux --permissive

#part / --size 4400

# Hawaii from git
repo --name="Hawaii from git" --baseurl=https://copr-be.cloud.fedoraproject.org/results/plfiorini/hawaii-git/fedora-$releasever-$basearch/ --cost=1000

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
