#!/bin/bash

dir="$HOME/.wsl"
echo "Welcome to easyWSLbash installer"

mkdir -p $dir
cd $dir
git clone https://github.com/leongrdic/easyWSLbash.git
mv easyWSLbash/* .
rm -r easyWSLbash
chmod +x b.sh

echo "I need root access to setup a new user that will be used for pre-mounting drives"

# Ask for users password to get sudo access
sudo cat /dev/null

sudo useradd -s /bin/bash -G sudo wsl
sudo passwd -l wsl

sudo su -c 'echo "wsl ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
sudo su -c 'echo "$(whoami) ALL=(wsl) NOPASSWD:ALL" >> /etc/sudoers'

echo "Please add the following folder to your enviroment variable PATH in Windows:"
echo "%localappdata%\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs\home\$(whoami)\.wsl"