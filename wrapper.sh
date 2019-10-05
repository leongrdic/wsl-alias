#!/bin/bash

# getting the arguments
pwd_win="$1"
shift
cmd="$@"

# loading the custom environment
wslalias_dir="$HOME/.wsl-alias"
wslalias_interactive="0"
if [ -z "$cmd" ]; then
  wslalias_interactive="1"
fi
if [ -f "$wslalias_dir/env.sh" ]; then
  source "$wslalias_dir/env.sh"
fi

# find the Windows drive mount root (thx to github.com/hustlahusky)
wsl_mount_root="/mnt/"
if [ -f "/etc/wsl.conf" ]; then
  if grep -q root /etc/wsl.conf; then
    wsl_mount_root=$(cat /etc/wsl.conf | awk '/root/ {print $3}')
  fi
fi

# parsing the path
pwd_wsl=$(echo "$pwd_win" | sed 's/\\/\//g')
pwd_wsl=$(echo "$pwd_wsl" | sed 's/://g')
pwd_wsl=$(echo "$pwd_wsl" | sed 's/^./\L&\E/')
pwd_wsl="$wsl_mount_root$pwd_wsl"

# mounting the drive if its not mounted
pwd_drive=${pwd_wsl:${#wsl_mount_root}:1}
pwd_drive_ls=$(ls -A "$wsl_mount_root$pwd_drive" 2>/dev/null)
if [ ! -d "$pwd_wsl" ] || [ -z "$pwd_drive_ls" ]; then
  user=$(whoami)
  user_uid=$(id -u "$user")
  user_gid=$(id -g "$user")
  echo "wsl: attempting to mount drive $pwd_drive:"
  mkdir -p "$wsl_mount_root$pwd_drive"
  sudo mount -o uid=$user_uid,gid=$user_gid -t drvfs $pwd_drive: $wsl_mount_root$pwd_drive
fi

cd "$pwd_wsl" 2>/dev/null
if [ -z "$cmd" ]; then
  cmd="$SHELL"
fi

# replace Windows file path in arguments (thx to github.com/hustlahusky)
while [[ $cmd =~ (.*)([A-Za-z]):(.*) ]]; do
  letter=$(echo "${BASH_REMATCH[2]}" | tr '[:upper:]' '[:lower:]')
  cmd=${BASH_REMATCH[1]}${wsl_mount_root}${letter}${BASH_REMATCH[3]}
done

eval "$cmd; exit $?"
