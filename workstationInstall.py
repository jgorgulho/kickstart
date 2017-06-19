#!/bin/env python

import os
import sys
import shlex
import subprocess


#
#    Constants
#

WELCOME_STRING = """
########################################################
# Running Installation Script for Workstation          #
########################################################\n\n\n
"""
RAN_SCRIP_STRING = """\n\n\n
########################################################
# Finished running Installation Script for Workstation #
########################################################
"""
RUN_SCRIPT_AS_ROOT_STRING = "\n\nPlease run this script as root or equivalent.\n\n"
DNF_CONST_FILE = "/etc/dnf/dnf.conf"
DNF_DELTARPM_CONFIG_STRING = "deltarpm=1"
OS_UPDATE_SYSTEM = "sudo dnf update"
SUDO_GET_PASSWORD = "sudo touch /tmp/tempFileForInstallationScript"
SUDO_FORGET_PASSWORD = "sudo -k"

#
#    Functions
#

def setDeltaRpm():
    fobj = open(DNF_CONST_FILE)
    dnfConfFile = fobj.read().strip().split()
    stringToSearch = DNF_DELTARPM_CONFIG_STRING 
    if stringToSearch in dnfConfFile:
        print("Delta rpm already configured\n")
        pass
    else: 
    	print('Setting delta rpm...\n')
        fobj.close()
        commandToRun = "sudo sh -c 'echo " + DNF_DELTARPM_CONFIG_STRING + " >> " + DNF_CONST_FILE +"'"
	subprocess.call(shlex.split(commandToRun))
    	print('Delta rpm set...\n')

def performInstall():
    print("\nUpdating system...\n")
    subprocess.call(shlex.split(OS_UPDATE_SYSTEM))

def performInstall():
    setDeltaRpm() 
    #
    #echo 'Setting repositories...'
    #
    #echo 'Installing rpmfusion...'
    #sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
    #sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
    #echo 'Installing GitHub Atom editor...'
    #sudo dnf install -y "https://github.com/atom/atom/releases/download/v1.11.1/atom.x86_64.rpm"
    #
    #echo 'Updating system...'
    #sudo dnf update -y
    #
    #echo 'Installing big list of packages...'
    #sudo dnf install -y abrt-desktop autoconf automake binutils bison chromium \
    #chrony cmake cowsay cups cups-filters dejavu-sans-mono-fonts deltarpm \
    #diffstat docker docker-registry docker-vim doxygen \
    #fedora-dockerfiles firefox flex fortune-mod gcc gcc-c++ \
    #gdb gettext ghostscript gimp git glibc-devel google-droid-sans-mono-fonts \
    #guestfs-browser hpijs hplip icedtea-web inkscape java-openjdk \
    #levien-inconsolata-fonts libffi libguestfs-tools libtool \
    #libvirt-daemon-config-network libvirt-daemon-kvm libxml2-devel lynx \
    #make mozilla-fira-mono-fonts nmap nodejs npm nss-mdns ntfs-3g \
    #openssh-server PackageKit patch patchutils perl-core pkgconfig \
    #powerline powertop python-libguestfs python-pip qemu-kvm recordmydesktop \
    #redhat-rpm-config rolekit ruby-devel setroubleshoot skanlite \
    #strace subversion system-config-keyboard \
    #system-config-language system-config-users systemtap tmux \
    #tuned unzip vim vim-common vim-enhanced vim-filesystem \
    #*powerline* vim-X11 virt-install virt-manager virt-top virt-viewer \
    #vlc youtube-dl fuse-sshfs
    #
    ## Main Gnome Shell Extensions
    #echo 'Installing Gnome Shell Extensions'
    #sudo dnf install -y gnome-shell-extension-window-list \
    #    gnome-shell-extension-openweather \
    #    gnome-shell-extension-alternate-tab \
    #    gnome-shell-extension-background-logo \
    #    gnome-shell-extension-launch-new-instance \
    #    gnome-shell-extension-no-topleft-hot-corner \
    #    gnome-shell-extension-media-player-indicator
    #
    ## Caffeine Gnome Shell Extension
    #echo 'Installing Caffeine Gnome Shell Extensions'
    #cd $HOME
    #git clone git://github.com/eonpatapon/gnome-shell-extension-caffeine.git
    #cd gnome-shell-extension-caffeine
    #sudo ./update-locale.sh
    #sudo glib-compile-schemas --strict --targetdir=caffeine@patapon.info/schemas/ caffeine@patapon.info/schemas
    #cp -r caffeine@patapon.info ~/.local/share/gnome-shell/extensions
    #cd $HOME
    #rm -Rf gnome-shell-extension-caffeine
    #
    #
    #echo 'Downloading hplip and lastpass for later install...'
    #mkdir /home/jgorgulho/toInstall
    #wget -O hplip.run "http://downloads.sourceforge.net/project/hplip/hplip/3.16.11/hplip-3.16.11.run?r=http%3A%2F%2Fhplipopensource.com%2Fhplip-web%2Finstall%2Finstall%2Findex.html&ts=1480467242&use_mirror=netassist"
    #wget -O lastpass.tar.bz2 "https://lastpass.com/lplinux.tar.bz2"
    #echo 'Moving hplip and lastpass to user folder...'
    #mv hplip.run /home/jgorgulho/toInstall
    #mv lastpass.tar.bz2 /home/jgorgulho/toInstall
    #chown -R jgorgulho /home/jgorgulho/toInstall
    #chown -R jgorgulho /home/jgorgulho/toInstall/*
    #
    #echo "Cloning dotfiles from github repo to root..."
    #git clone https://github.com/jgorgulho/dotfiles /root/.dotfiles
    #ln -sf /root/.dotfiles/.bashrc /root/.bashrc
    #echo "Cloning dotfiles from github repo to user..."
    #git clone https://github.com/jgorgulho/dotfiles /home/jgorgulho/.dotfiles
    #ln -sf /home/jgorgulho/.dotfiles/.bashrc /home/jgorgulho/.bashrc
    #chown -R jgorgulho /home/jgorgulho/.dotfiles
    #chown -R jgorgulho /home/jgorgulho/.dotfiles/.*
    #chown -R jgorgulho /home/jgorgulho/.bashrc
    #
    #echo "Installing Jekyll..."
    #gem install jekyll
    #
    #echo "Enabling tuned..."
    #systemctl enable tuned
    #echo "Enabling powertop..."
    #systemctl enable powertop

def checkIfUserHasRootRights():
    return(os.geteuid())

def printWelcomeString():
    print(WELCOME_STRING)

def printNeedRootRightsString():
    print(RUN_SCRIPT_AS_ROOT_STRING)

def printEndString():
    print(RAN_SCRIP_STRING)

def getSudoPass():
    subprocess.call(shlex.split(SUDO_GET_PASSWORD))

def makeSudoForgetPass():
    subprocess.call(shlex.split(SUDO_FORGET_PASSWORD))
 

def main():    
    printWelcomeString()
    if(checkIfUserHasRootRights() == 0):
        performInstall()
    else:
        try:
            getSudoPass()
        except:
            printNeedRootRightsString()
            exit()
        performInstall()
    makeSudoForgetPass()
    printEndString()

#
# Run Main Script
#

main()

