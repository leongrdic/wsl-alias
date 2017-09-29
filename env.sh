#!/bin/bash

if [ $wsl == "1" ]; then
  # Execute only if started without command argument
  echo "Welcome to easyWSLbash! Put your enviroment variables in ~/.wsl/.env"
fi

export example="something"
