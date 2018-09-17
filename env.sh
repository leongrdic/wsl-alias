#!/bin/bash

# adding our linux bin directory to path so you can access the 'wsl-add' command
PATH=$PATH:$HOME/.wsl-alias/bin

if [ $wslalias_interactive == "1" ]; then
  # execute only if started without command argument
  echo "Welcome to wsl-alias! Put your environment variables in ~/.wsl/env.sh"
fi

# define environment variables
#   export example="something"

# always mount a drive (regardless of your current directory)
#   sudo mount -o uid=1000,gid=1000 -t drvfs Z: /mnt/z
