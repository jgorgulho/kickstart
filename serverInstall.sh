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

echo "##########################################"
echo "# Running Installation Script for Server #"
echo "##########################################"


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
       
# Begin installing rpm fusion 
echo 'Installing rpmfusion...'
sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
# End installing rpm fusion 

## End installing individual packages 


echo 'Updating system...'
sudo dnf update -y

echo 'Installing big list of packages...'
sudo dnf install -y $(<packagesToInstallServer)

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
