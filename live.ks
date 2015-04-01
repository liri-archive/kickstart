%include /usr/share/spin-kickstarts/fedora-live-base.ks
%include /usr/share/spin-kickstarts/fedora-live-minimization.ks
%include hawaiii-packages.ks

selinux --permissive

#part / --size 4400

# Hawaii from git
repo --name="Hawaii from git" --baseurl=https://copr-be.cloud.fedoraproject.org/results/plfiorini/hawaii-git/fedora-$releasever-$basearch/ --cost=1000

# RPMFusion repos
#repo --name=rpmfusion-free --baseurl=http://download1.rpmfusion.org/free/fedora/releases/$releasever/Everything/$basearch/os
#repo --name=rpmfusion-free-updates --baseurl=http://download1.rpmfusion.org/free/fedora/updates/$releasever/$basearch
#repo --name=rpmfusion-non-free --baseurl=http://download1.rpmfusion.org/nonfree/fedora/releases/$releasever/Everything/$basearch/os
#repo --name=rpmfusion-non-free-updates --baseurl=http://download1.rpmfusion.org/nonfree/fedora/updates/$releasever/$basearch

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

# set up auto-login
cat > /etc/sddm.conf << EOF
[Autologin]
User=livesys
Session=hawaii
EOF

# Make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

%end
