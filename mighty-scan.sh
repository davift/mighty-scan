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
  #tput bold
  tput setaf 2
  echo "[ `date +"%F %T"` - $@ ]"
  tput sgr0
}

function box_yellow() {
  #tput bold
  tput setaf 3
  echo "[ `date +"%F %T"` - $@ ]"
  tput sgr0
}

function box_red() {
  #tput bold
  tput setaf 1
  echo "[ `date +"%F %T"` - $@ ]"
  tput sgr0
}

echo " "
box_blue "MIGHTY-SCAN"
echo " "

# Checking for root (or sudo) privileges.
IsUbuntu=$(whoami)
if [ $IsUbuntu != 'root' ]
then
  box_yellow "No root privileges - Advanced features disabled"
else
  box_green "Running with root privileges - Advanced features enabled"
fi

# Creating output directory adn testing for writting access.
OUTPUT_DIR="./scope"
mkdir -p $OUTPUT_DIR
touch $OUTPUT_DIR/7211b01d8e0c 2> /dev/null || (box_red "No writting access" && exit 0)
rm -rf $OUTPUT_DIR/7211b01d8e0c

# Checking for the file with the addresses/networks in scope: target.ips
TARGET_FILE="$OUTPUT_DIR/target.ips"
if [ ! -f $TARGET_FILE ]; then
    box_yellow "File not found: target.ips"

    # Prompt for target.
    read -e -p "Enter, comma separated, the target addresses (e.g. 10.0.0.0/24,10.0.0.1): " TARGET
    [ -z "$TARGET" ] && box_red "FAILED - No target" && exit 0

    # Saving targets to file.
    echo $TARGET | tr , "\n" > $TARGET_FILE
else
  box_green "Targets found"
fi

# Printing target addresses for review.
tput setaf 4
cat $TARGET_FILE
tput sgr0

#
# Discovery
#

box_green "Ping scan"
nmap -iL $TARGET_FILE -oG $OUTPUT_DIR/scan.ping -v0 -sn
tput setaf 4
cat $OUTPUT_DIR/scan.ping | grep 'seconds'
tput sgr0
cat $OUTPUT_DIR/scan.ping | grep -o -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | uniq

box_green "No ping scan"
nmap -iL $TARGET_FILE -oG $OUTPUT_DIR/scan.noping -v0 -Pn
if [ $IsUbuntu != 'root' ]
then
  sed '/Status: Up/d' -i $OUTPUT_DIR/scan.noping
  sed '/Ports: 	/d' -i $OUTPUT_DIR/scan.noping
fi
tput setaf 4
cat $OUTPUT_DIR/scan.noping | grep 'seconds'
tput sgr0
cat $OUTPUT_DIR/scan.noping | grep -o -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | uniq

box_green "ENDED"
exit 0