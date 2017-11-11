#!/bin/env bash

## Variables
dnfConfigFile=/etc/dnf/dnf.conf
user=jgorgulho

## Functions

# Function to define config for dnf
# Inputs:
# $1 configFile
# $2 nameOfConfigToSet
# $3 configToSet
# Returns:
# n/a
function defineDnfConfig() {
  ## Begin dnf config check
  cleanFile $1
  echo 'Removing previous configs...'
  if (( $(grep -o $2 $1 | wc -l) >= 1)); then
      grep -v $2 $1 >> temp
      mv temp $1
  fi
  ## End dnf config check
  ## Begin dnf config set
  echo 'Setting current desired config...'
  echo $3 | sudo tee -a $1
  cleanFile $1
  echo 'Set '$3' .'
  ## end dnf config check
}

# Function to clean file $1 of empty lines
function cleanFile() {
    sed -i '/^$/d' $1
}

echo "###############################################"
echo "# Running Installation Script for Workstation #"
echo "###############################################"


### DNF configs
echo 'Setting dnf configs...'
## Begin delta RPM 
configName="deltarpm"
configSetting="deltarpm=1"
defineDnfConfig $dnfConfigFile $configName $configSetting
## End delta RPM 

## Begin fastest mirror
configName="fastestmirror"
configSetting="fastestmirror=false"
defineDnfConfig $dnfConfigFile $configName $configSetting
## End fastest mirror

## Begin min rate
configName="minrate"
configSetting="minrate=10k"
defineDnfConfig $dnfConfigFile $configName $configSetting
## End min rate

## Begin timeout
configName="timeout"
configSetting="timeout=10"
defineDnfConfig $dnfConfigFile $configName $configSetting
## End timeout

### End DNF configs

echo 'Updating system...'
sudo dnf update -y


## Begin installing individual packages 
echo 'Configuring repo for paper icons and theme...'
dnf config-manager --add-repo https://download.opensuse.org/repositories/home:snwh:paper/Fedora_25/home:snwh:paper.repo
       
# Begin installing rpm fusion 
echo 'Installing rpmfusion...'
sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
# End installing rpm fusion 

## Begin installing atom editor 
if [ ! -f atom.rpm ]; then
    echo the file exists
    echo 'Downloading GitHub Atom editor (stable)...'
    wget --output-document=atom.rpm "https://atom.io/download/rpm"
fi

if [ ! -f atom-beta.rpm ]; then
    echo the file exists
    echo 'Downloading GitHub Atom editor (developer)...'
    wget --output-document=atom-beta.rpm "https://atom.io/download/rpm?channel=beta"
fi
    echo 'Installing GitHub Atom editor (stable)...'
    echo 'Installing GitHub Atom editor (developer)...'
    sudo dnf install -y atom-beta.rpm atom.rpm
    su -c "cd && apm install atom-ide-ui ide-typescript ide-flowtype prettier-atom prettier-eslint linter-scss-lint" -s /bin/sh $user
# End installing atom editor 
## End installing individual packages 


echo 'Updating system...'
sudo dnf update -y

echo 'Installing big list of packages...'
sudo dnf install -y $(<packagesToInstall)

## Begin install flatpak packages 
echo 'Installing Flatpak Gnome Runtime'
flatpak remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo
echo 'Installing Flatpak Firefox Repo'
flatpak remote-add --from org.mozilla.FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
echo 'Installing Flatpak Firefox Dev Edition'
flatpak install -y org.mozilla.FirefoxRepo org.mozilla.FirefoxDevEdition
echo 'Installing Flatpak Libreoffice'
wget http://download.documentfoundation.org/libreoffice/flatpak/latest/LibreOffice.flatpak
flatpak install -y --bundle LibreOffice.flatpak
# End install flatpak packages 

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
git clone https://github.com/jgorgulho/dotfiles /home/$user/.dotfiles
ln -sf /home/$user/.dotfiles/.bashrc /home/$user/.bashrc
chown -R $user /home/$user/.dotfiles
chown -R $user /home/$user/.dotfiles/.*
chown -R $user /home/$user/.bashrc

echo "Enabling tuned..."
sudo systemctl enable tuned
echo "Enabling powertop..."
sudo systemctl enable powertop
sudo systemctl enable sshd
sudo systemctl enable cockpit.socket

# Finished running script
echo "Finished running script."
echo "If on Gnome shell install gnome extentions from list."
echo "Go to https://flathub.org/ and install Spotify."
