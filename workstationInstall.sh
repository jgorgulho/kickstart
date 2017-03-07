#!/bin/env bash

echo "###############################################"
echo "# Running Installation Script for Workstation #"
echo "###############################################"

echo 'Setting delta rpm...'
echo "deltarpm=1" | sudo tee -a /etc/dnf/dnf.conf

echo 'Updating system...'
sudo dnf update -y

echo 'Setting repositories...'
echo 'Setting Spotify repository...'
#Spotify
sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
echo 'Setting Skype repository...'
# Skype
sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-skype.repo
echo 'Setting Flash repository...'
# Flash
dnf config-manager --add-repo=http://negativo17.org/repos/fedora-flash-plugin.repo
echo 'Setting general multimedia repository...'
# Multimedia
sudo dnf config-manager --add-repo=http://negativo17.org/repos/fedora-multimedia.repo

echo 'Installing rpmfusion...'
sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
echo 'Installing GitHub Atom editor...'
sudo dnf install -y "https://github.com/atom/atom/releases/download/v1.11.1/atom.x86_64.rpm"

echo 'Updating system...'
sudo dnf update -y

echo 'Installing big list of packages...'
sudo dnf install -y abrt-desktop autoconf automake binutils bison chromium \
chrony cmake cowsay cups cups-filters dejavu-sans-mono-fonts deltarpm \
diffstat docker docker-registry docker-vim doxygen \
fedora-dockerfiles firefox flash-plugin flex fortune-mod gcc gcc-c++ \
gdb gettext ghostscript gimp git glibc-devel google-droid-sans-mono-fonts \
guestfs-browser hpijs hplip icedtea-web inkscape java-openjdk \
levien-inconsolata-fonts libdvdcss libffi libguestfs-tools libtool \
libvirt-daemon-config-network libvirt-daemon-kvm libxml2-devel lynx \
make mozilla-fira-mono-fonts nmap nodejs npm nss-mdns ntfs-3g \
openssh-server PackageKit patch patchutils perl-core pkgconfig \
powerline powertop python-libguestfs python-pip qemu-kvm recordmydesktop \
redhat-rpm-config rolekit setroubleshoot skanlite skype spotify-client \
strace subversion system-config-keyboard \
system-config-language system-config-users systemtap tmux \
tuned unzip vim vim-common vim-enhanced vim-filesystem \
*powerline* vim-X11 virt-install virt-manager virt-top virt-viewer \
vlc youtube-dl xmonad ghc-xmonad-contrib-devel xmobar

echo "Fixing and setting KWin as Plasma Windows Manager after instaling XMonad..."
mkdir -p ~/.config/plasma-workspace/env
echo "export KDEWM=$(which kwin)" > ~/.config/plasma-workspace/env/set_window_manager.sh
chmod +x ~/.config/plasma-workspace/env/set_window_manager.sh

echo 'Downloading hplip and lastpass for later install...'
mkdir /home/jgorgulho/toInstall
wget -O hplip.run "http://downloads.sourceforge.net/project/hplip/hplip/3.16.11/hplip-3.16.11.run?r=http%3A%2F%2Fhplipopensource.com%2Fhplip-web%2Finstall%2Finstall%2Findex.html&ts=1480467242&use_mirror=netassist"
wget -O lastpass.tar.bz2 "https://lastpass.com/lplinux.tar.bz2"
echo 'Moving hplip and lastpass to user folder...'
mv hplip.run /home/jgorgulho/toInstall
mv lastpass.tar.bz2 /home/jgorgulho/toInstall
chown -R jgorgulho /home/jgorgulho/toInstall
chown -R jgorgulho /home/jgorgulho/toInstall/*

echo "Cloning dotfiles from github repo to root..."
git clone https://github.com/jgorgulho/dotfiles /root/.dotfiles
ln -sf /root/.dotfiles/.bashrc /root/.bashrc
echo "Cloning dotfiles from github repo to user..."
git clone https://github.com/jgorgulho/dotfiles /home/jgorgulho/.dotfiles
ln -sf /home/jgorgulho/.dotfiles/.bashrc /home/jgorgulho/.bashrc
chown -R jgorgulho /home/jgorgulho/.dotfiles
chown -R jgorgulho /home/jgorgulho/.dotfiles/.*
chown -R jgorgulho /home/jgorgulho/.bashrc

echo "Installing Jekyll..."
gem install jekyll

echo "Installing docker compose bash completion..."
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

echo "Enabling tuned..."
systemctl enable tuned
echo "Enabling powertop..."
systemctl enable powertop
