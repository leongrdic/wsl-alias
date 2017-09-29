#!/bin/bash

dir="$HOME/.wsl"
user=$(whoami)

echo
echo "Welcome to easyWSLbash installer"
echo

mkdir -p $dir
cd $dir

git clone https://github.com/leongrdic/easyWSLbash.git
if [ -f "$dir/env.sh" ]; then
	rm -f easyWSLbash/env.sh
fi

echo
echo "Moving files and fixing permissions"
mv easyWSLbash/* .
rm -rf easyWSLbash
chmod +x b.sh
echo

if [ $(grep -c '^wsl:' /etc/passwd) == 1 ]; then
	echo "The wsl user already exists - skipping creation"
else
	echo "I need root access to setup a new user that will be used for pre-mounting drives"

	# Ask for users password to get sudo access
	sudo cat /dev/null

	sudo useradd -s /bin/bash -G sudo wsl
	sudo passwd -l wsl

	sudo su -c "echo 'wsl ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
	sudo su -c "echo '$user ALL=(wsl) NOPASSWD:ALL' >> /etc/sudoers"
fi

echo
echo "The installation has completed!"
echo
echo "Please add the following folder to your enviroment variable PATH in Windows:"
echo "%localappdata%\\Packages\\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\\LocalState\\rootfs\\home\\$user\.wsl"
echo
