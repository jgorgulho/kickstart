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
RAN_SCRIP_STRING = """\n
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
INSTALL_PACKAGE_CMD = "sudo dnf install -y "
FEDORA_VERSION_NUMBER = subprocess.check_output(['rpm','-E %fedora'])
RPM_FUSION_FREE_DOWNLOAD_URL = "\"https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"+FEDORA_VERSION_NUMBER.strip()+".noarch.rpm\""
RPM_FUSION_NONFREE_DOWNLOAD_URL = "\"https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"+FEDORA_VERSION_NUMBER.strip()+".noarch.rpm\""
ATOM_EDITOR_DOWNLOAD_URL = "https://atom.io/download/rpm"
PACKAGES_FILE = "workstationPackagesToInstall.txt"
PACKAGE_TO_INSTALL_LIST = ""
ERROR_OPENING_PACKAGES_FILE = "\n\nPlease make sure that the file " + PACKAGES_FILE + " exists.\n\n"
#
#    Functions
#

def setDeltaRpm():
    fobj = open(DNF_CONST_FILE)
    dnfConfFile = fobj.read().strip().split()
    stringToSearch = DNF_DELTARPM_CONFIG_STRING 
    if stringToSearch in dnfConfFile:
        print("Delta rpm already configured.\n")
        pass
    else: 
    	print('Setting delta rpm...\n')
        fobj.close()
        commandToRun = "sudo sh -c 'echo " + DNF_DELTARPM_CONFIG_STRING + " >> " + DNF_CONST_FILE +"'"
	subprocess.call(shlex.split(commandToRun))
    	print('Delta rpm set.\n')

def performUpdate():
    print("\nUpdating system...\n")
    subprocess.call(shlex.split(OS_UPDATE_SYSTEM))
    print("\nUpdated system.\n")

def performInstallFirstStage():
    setDeltaRpm() 

def installPackage(localPackageToInstall):
    commandToRun = INSTALL_PACKAGE_CMD + localPackageToInstall
    subprocess.call(shlex.split(commandToRun))

def installRpmFusion():
    print("\nInstalling rpmfusion...\n")
    installPackage(RPM_FUSION_FREE_DOWNLOAD_URL)
    installPackage(RPM_FUSION_NONFREE_DOWNLOAD_URL)
    print("\nInstaled rpmfusion.\n")
    #echo 'Installing GitHub Atom editor...'
    #sudo dnf install -y "https://github.com/atom/atom/releases/download/v1.11.1/atom.x86_64.rpm"

def installAtomEditor():
    print("\nInstalling Atom editor...\n")
    installPackage(ATOM_EDITOR_DOWNLOAD_URL)
    print("\nInstaled Atom editor.\n")
    #echo 'Installing GitHub Atom editor...'
    #sudo dnf install -y "https://github.com/atom/atom/releases/download/v1.11.1/atom.x86_64.rpm"

def getListOfPackagesToInstall():
    print("Getting list of packages to install from " + PACKAGES_FILE + " ...")
    try:
        PACKAGE_TO_INSTALL_LIST = subprocess.check_output(['cat',PACKAGES_FILE])
    except:
        print(ERROR_OPENING_PACKAGES_FILE)
        makeSudoForgetPass()
        printEndString()
        exit()
    print("Finished getting package list."

def installPackagesFromFile():
    print("Installing packages from list...")
    installPackage(PACKAGE_TO_INSTALL_LIST)
    print("Finished installing package list."

def performInstallThirdStage():
    getListOfPackagesToInstall()

def performInstallSecondtStage():
    installRpmFusion()
    
def performInstall():
    performInstallFirstStage()   
    performUpdate()
    performInstallSecondtStage()
    performUpdate()
    performInstallThirdStage()

    ## Main Gnome Shell Extensions
    #echo 'Installing Gnome Shell Extensions'
    #sudo dnf install -y 
    gnome-shell-extension-window-list \
    gnome-shell-extension-openweather \
    gnome-shell-extension-alternate-tab \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-no-topleft-hot-corner \
    gnome-shell-extension-media-player-indicator
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
            makeSudoForgetPass()
            printEndString()
            exit()
        performInstall()
    makeSudoForgetPass()
    printEndString()

#
# Run Main Script
#

main()

