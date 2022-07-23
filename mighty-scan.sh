#!/bin/bash

# https://github.com/davift/mighty-scan
# 2022-07-09 v0.1

source boxes.sh
SILENT='-v0'

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
    if [ -z "$TARGET" ]; then
      box_yellow "No address entered"
      box_green "Smart detection (arp scan + hosts file)"
      cat /etc/hosts | grep -o -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sort | uniq | tee -a $OUTPUT_DIR/target.ips > /dev/null
      arp -a | grep -o -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sort | uniq | tee -a $OUTPUT_DIR/target.ips >> /dev/null
        if [ -f "`which arp-scan`" ] && [ $USER == 'root' ]; then
          ## To install: sudo apt install arp-scan -y
          for ADAPTER in $(ip a | grep "state UP" | awk -F " " '{print $2}' |  sed 's/://')
          do
            echo $ADAPTER
            arp-scan --interface=eth0 --localnet | grep -o -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sort | uniq | tee -a $OUTPUT_DIR/target.ips >> /dev/null
          done
        fi
    else
      # Saving targets to file.
      echo $TARGET | tr , "\n" > $TARGET_FILE
    fi
    # Deduplicating
    cat $OUTPUT_DIR/target.ips | sort | uniq > $OUTPUT_DIR/target.ips.tmp
    mv $OUTPUT_DIR/target.ips.tmp $OUTPUT_DIR/target.ips

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
else
  box_yellow "SKIPPING"
fi

##
## Selecting Targer IPs
##

if [ ! -f $OUTPUT_DIR/hosts.up ]; then
  box_red "NOT FOUND - $OUTPUT_DIR/hosts.up"
  IPS=$OUTPUT_DIR/target.ips
else
  IPS=$OUTPUT_DIR/hosts.up
fi
box_blue "Targets in $IPS"

##
## Port Scan Phase
##

read -e -p "Start port scan (y/N): " PORT_SCAN
if [ "$PORT_SCAN" == "y" ] || [ "$PORT_SCAN" == "Y" ]; then
  source portscan.sh
else
  box_yellow "SKIPPING"
fi

##
## Fingerprinting Phase
##

read -e -p "Start fingerprinting the open ports (y/N): " IDENTIFY
if [ "$IDENTIFY" == "y" ] || [ "$IDENTIFY" == "Y" ]; then
  source fingerprinting.sh
else
  box_yellow "SKIPPING"
fi

##
## Vulnerabilities Phase
##

read -e -p "Start vulnerability check (y/N): " VULN
if [ "$VULN" == "y" ] || [ "$VULN" == "Y" ]; then
  source vulnerability.sh
else
  box_yellow "SKIPPING"
fi

# Changing ownership of output files
if [ $USER == 'root' ]; then
  chown -R $SUDO_USER: $OUTPUT_DIR
fi

# Terminating
box_green "ENDED"
exit 0
