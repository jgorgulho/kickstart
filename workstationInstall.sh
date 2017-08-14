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
chrony cmake cockpit cockpit-bridge cockpit-docker cockpit-kubernetes \
cockpit-networkmanager cockpit-pcp cockpit-shell cockpit-storaged cockpit-ws \
cockpit-selinux cockpit-dock cockpit-dashboard cockpit-machines \
cockpit-packagekit cockpit-sosreport cockpit-system \
cowsay cups cups-filters dejavu-sans-mono-fonts deltarpm \
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

# Main Gnome Shell Extensions
echo 'Installing Gnome Shell Extensions'
sudo dnf install -y gnome-shell-extension-window-list \
    gnome-shell-extension-openweather \
    gnome-shell-extension-alternate-tab \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-no-topleft-hot-corner \
    gnome-shell-extension-media-player-indicator

gnome-shell-extension-tool -e alternate-tab 
gnome-shell-extension-tool -e background-logo 
gnome-shell-extension-tool -e launch-new-instance 
gnome-shell-extension-tool -e places-menu
gnome-shell-extension-tool -e user-theme 
gnome-shell-extension-tool -e window-list 
sudo dnf copr enable -y region51/chrome-gnome-shell
sudo dnf install -y chrome-gnome-shell

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
