#!/bin/bash

wslalias_dir="$HOME/.wsl-alias"
user=$(whoami)

echo
echo "Welcome to wsl-alias v2.0 installer"
echo

mkdir -p "$wslalias_dir"
cd "$wslalias_dir"

git clone -c advice.detachedHead=false -b "v2.0" https://github.com/leongrdic/wsl-alias.git update
if [ -f "$wslalias_dir/env.sh" ]; then
	rm -f update/env.sh
fi

echo
echo "Moving files and fixing permissions"

cp -r update/* .
rm -rf update

chmod +x wrapper.sh
chmod +x bin/wsl-alias

if [ $(stat -c "%a" "/mnt") != "777" ]; then
	echo "Invalid permissions detected on the /mnt directory"
	echo "You might be asked for your password to fix the permissions so that you can create new mountpoints for drives"
	sudo chmod 777 /mnt
fi

# creating the aliases directory through windows to avoid WSL issue #3487
cmd.exe /c mkdir "%userprofile%\wsl-alias" 2>/dev/null

echo
echo "Do you want to grant your user to use the mount/umount commands without typing a password?"
echo "If you choose yes, you might be asked for your password to add a new sudoers entry"
echo "You can skip this step if you've had wsl-alias v2+ previously installed for this user"
echo -n "Answer (y/n): "
read setup_sudo

if [ "$setup_sudo" = "y" ]; then
	setup_sudoers="$user ALL=(root) NOPASSWD: /bin/mount, /bin/umount"
	if [ $(sudo grep -c "^$setup_sudoers" /etc/sudoers) == 1 ]; then
		echo 'Entry already found in /etc/sudoers, not modifying'
	else
		sudo su -c "echo '$setup_sudoers' >> /etc/sudoers"
		echo "Modified the /etc/sudoers file"
	fi
fi

win_home=$(cmd.exe /c echo %userprofile% | sed -e 's/\r//g')
win_home=$(wslpath "$win_home")
wslalias_dir_win="$win_home/wsl-alias"

if [ -z "$(ls -A $wslalias_dir_win)" ]; then
	echo
	echo "Choose a default alias which you'll use to pass commands from Windows to wsl"
	echo "Note: this alias can't be 'wsl' because that's an internal Windows command"

	echo -n "Command [b]: "
	read setup_alias

	if [ -z "$setup_alias" ] || [ "$setup_alias" == "wsl" ]; then
		setup_alias="b"
	fi

	cmd_path="$wslalias_dir_win/$setup_alias.bat"
	cp template.bat "$cmd_path"
	perl -pi -e 's/ {alias_command}//g' "$cmd_path"
fi

echo
echo
echo "The installation has completed!"
echo
echo "Please add the following directory to your PATH enviroment variable in Windows:"
echo "    %userprofile%\\wsl-alias"
echo
echo "After that you'll be able to use it to call wsl commands from Windows"
echo "To add a new alias from Windows, use:"
echo "    $setup_alias wsl-alias"
echo
