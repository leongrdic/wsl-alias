#!/bin/bash

dir="$HOME/.wsl"

wsl_sudo () {
  sudo -u "wsl" sudo $1
}

if [ -f "$dir/env.sh" ]; then
  source "$dir/env.sh"
fi

uri="$1"
uri=$(echo "$uri" | sed 's/\\/\//g')
uri=$(echo "$uri" | sed 's/://g')
uri=$(echo "$uri" | sed 's/^./\L&\E/')
uri="/mnt/$uri"

if [ ! -d "$uri" ]; then
  letter=${uri:5:1}
  echo "attempting to mount drive $letter:"

  wsl_sudo "mkdir -p /mnt/$letter"
  wsl_sudo "sudo mount -t drvfs $letter: /mnt/$letter"
fi

cd "$uri"

arg="$2"
if [ -z "$arg" ]; then
  arg="bash"
fi

eval "$arg"