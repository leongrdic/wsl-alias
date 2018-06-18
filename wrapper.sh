#!/bin/bash

# getting the arguments

uri="$1"
shift
cmd="$@"

# loading the custom environment

wsl_dir="$HOME/.wsl"
wsl_interactive="0"

if [ -z "$cmd" ]; then
  wsl_interactive="1"
fi

wsl_sudo () {
  sudo -u "wsl" sudo $1
}

if [ -f "$wsl_dir/env.sh" ]; then
  source "$wsl_dir/env.sh"
fi

# parsing the uri

uri=$(echo "$uri" | sed 's/\\/\//g')
uri=$(echo "$uri" | sed 's/://g')
uri=$(echo "$uri" | sed 's/^./\L&\E/')
uri="/mnt/$uri"

# mounting the drive if its not mounted

uri_letter=${uri:5:1}
uri_root_ls=$(ls -A "/mnt/$uri_letter")

if [ ! -d "$uri" ] || [ -z "$uri_root_ls" ]; then
  user=$(whoami)
  user_uid=$(id -u "$user")
  user_gid=$(id -g "$user")

  echo "wsl: attempting to mount drive $uri_letter:"

  wsl_sudo "mkdir -p /mnt/$uri_letter"
  wsl_sudo "sudo mount -o uid=$user_uid,gid=$user_gid -t drvfs $uri_letter: /mnt/$uri_letter"
fi

cd "$uri"

if [ -z "$cmd" ]; then
  cmd="bash"
fi

eval "$cmd"
