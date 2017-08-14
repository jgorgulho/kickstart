#!/bin/env bash

echo "###############################################"
echo "# Running Installation Script for Workstation #"
echo "###############################################"

echo 'Setting delta rpm...'
echo "deltarpm=1" | sudo tee -a /etc/dnf/dnf.conf

echo 'Updating system...'
sudo dnf update -y

echo 'Setting repositories...'

echo 'Installing rpmfusion...'
sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
echo 'Installing GitHub Atom editor...'
sudo dnf install -y "https://github.com/atom/atom/releases/download/v1.11.1/atom.x86_64.rpm"

echo 'Updating system...'
sudo dnf update -y

echo 'Installing big list of packages...'
sudo dnf group install -y "C Development Tools and Libraries"
sudo dnf install -y abrt-desktop autoconf automake binutils bison chromium \
chrony cmake cowsay cups cups-filters dejavu-sans-mono-fonts deltarpm \
diffstat docker docker-registry docker-vim doxygen \
fedora-dockerfiles firefox flex fortune-mod gcc gcc-c++ \
gdb gettext ghostscript gimp git glibc-devel google-droid-sans-mono-fonts \
guestfs-browser hpijs hplip icedtea-web inkscape java-openjdk \
levien-inconsolata-fonts libffi libguestfs-tools libtool \
libvirt-daemon-config-network libvirt-daemon-kvm libxml2-devel lynx \
make mozilla-fira-mono-fonts nmap nodejs npm nss-mdns ntfs-3g \
openssh-server PackageKit patch patchutils perl-core \
powerline powertop python-libguestfs python-pip qemu-kvm recordmydesktop \
redhat-rpm-config rolekit ruby-devel rubygems-devel setroubleshoot skanlite \
strace subversion system-config-keyboard \
system-config-language system-config-users systemtap tmux \
tuned unzip vim vim-common vim-enhanced vim-filesystem \
*powerline* vim-X11 virt-install virt-manager virt-top virt-viewer \
vlc youtube-dl fuse-sshfs

echo "Cloning dotfiles from github repo to root..."
git clone https://github.com/jgorgulho/dotfiles /root/.dotfiles
ln -sf /root/.dotfiles/.bashrc /root/.bashrc
echo "Cloning dotfiles from github repo to user..."
git clone https://github.com/jgorgulho/dotfiles /home/jgorgulho/.dotfiles
ln -sf /home/jgorgulho/.dotfiles/.bashrc /home/jgorgulho/.bashrc
chown -R jgorgulho /home/jgorgulho/.dotfiles
chown -R jgorgulho /home/jgorgulho/.dotfiles/.*
chown -R jgorgulho /home/jgorgulho/.bashrc

echo "Enabling tuned..."
systemctl enable tuned
echo "Enabling powertop..."
systemctl enable powertop
systemctl enable sshd
systemctl enable cockpit.socket
