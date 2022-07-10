#!/bin/bash

# https://github.com/davift/mighty-scan
# 2022-07-09 v0.1

source boxes.sh

echo " "
box_blue "MIGHTY-SCAN"
echo " "

# Checking for root (or sudo) privileges.
USER=$(whoami)
if [ $USER != 'root' ]; then
  box_yellow "No root privileges - Disabled features that require raw packet analysis"
else
  box_green "Running with root privileges - All features available"
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
    read -e -p "Enter, comma separated, the target addresses (e.g. 10.0.0.0/24,10.0.0.1,10.0.0.1-5): " TARGET
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

##
## Discovery Phase
##

read -e -p "Discover reachable host (y/N): " DISCOVER
if [ "$DISCOVER" == "y" ] || [ "$DISCOVER" == "Y" ]; then
  source discovery.sh
fi

##
## Select IPs
##

read -e -p "Use discovered hosts as targets (y/N): " SELECTED
if [ "$SELECTED" == "y" ] || [ "$SELECTED" == "Y" ] && [ -f $OUTPUT_DIR/hosts.up ]; then
  IPS=$OUTPUT_DIR/hosts.up
elif [ "$SELECTED" == "y" ] || [ "$SELECTED" == "Y" ] && [ ! -f $OUTPUT_DIR/hosts.up ]; then
  box_red "NOT FOUND - $OUTPUT_DIR/hosts.up"
  IPS=$OUTPUT_DIR/target.ips
else
  IPS=$OUTPUT_DIR/target.ips
fi

##
## Port Scan Phase
##

read -e -p "Start port scan (y/N): " PORT_SCAN
if [ "$PORT_SCAN" == "y" ] || [ "$PORT_SCAN" == "Y" ]; then
  source portscan.sh
fi

# Terminating
box_green "ENDED"
exit 0
