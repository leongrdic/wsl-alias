#!/bin/bash

# adding our linux bin directory to path so you can access the 'wsl-add' command
PATH=$PATH:~/.wsl/bin/linux

if [ $wsl_interactive == "1" ]; then
  # execute only if started without command argument
  echo "Welcome to easyWSLbash! Put your environment variables in ~/.wsl/env.sh"
fi

# define environment variables
#   export example="something"

# execute command as root
#   wsl_sudo "whoami"

# always mount a drive (regardless of your current directory)
#   wsl_sudo "sudo mount -t drvfs Z: /mnt/z"
