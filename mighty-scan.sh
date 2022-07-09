#!/bin/bash

# https://github.com/davift/mighty-scan
# 2022-07-09 v0.1

function box_blue() {
  tput bold
  tput setaf 4
  echo "[ $@ ]"
  tput sgr 0
}

function box_green() {
  tput bold
  tput setaf 2
  echo "[ Success! ]"
  tput sgr0
}

function box_yellow() {
  tput bold
  tput setaf 3
  echo "[ $@ ]"
  tput sgr0
}

function box_red() {
  tput bold
  tput setaf 1
  echo "[ Aborted! ]"
  tput sgr0
  exit 0
}

echo " "
box_blue "MIGHTY-SCAN"
echo " "

# Checking for root (or sudo) privileges.
IsUbuntu=$(whoami)
if [ $IsUbuntu != 'root' ]
then
  box_yellow "No root privileges - Advanced features disabled"
fi

# Checking for the file with the addresses/networks in scope: target.ips
if [ ! -f "target.ips" ]; then
    box_yellow "File not found: target.ips"

    # Prompt for target.
    read -e -p "Enter the target address or network (e.g. 10.0.0.0/24 or 10.0.0.1): " TARGET
    [ -z "$TARGET" ] && box_red "`date +"%F %T"` FAILED - No target"

    # Saving targets to file.
    
fi

box_green "`date +"%F %T"` ENDED"
exit 0