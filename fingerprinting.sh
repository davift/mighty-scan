##
## Fingerprinting Phase
##

box_green "Attack Surface by Port"
tput setaf 4
egrep -v "^#|Status: Up" $OUTPUT_DIR/port.open | cut -d' ' -f2,4- | awk -F, '{split($0,a," "); printf "%-16s (%d ports)\n" , a[1], NF}'
tput sgr0
mkdir -p $OUTPUT_DIR/fingerprint

read -e -p "Scripts: Default (y/N): " OPT1
read -e -p "Scripts: Service/Version (y/N): " OPT2
read -e -p "Scripts: O.S. Detection (if root) (y/N): " OPT3
read -e -p "Verbosity: Extra (y/N): " OPT4
read -e -p "Speed: High Speed Network (very-fast) (y/N): " OPT5
read -e -p "Speed: Good VPN or Wireless (fast) (y/N): " OPT6
read -e -p "Speed: Slow Bandwidth (y/N): " OPT7

# Parsing parameters
if [ "$OPT1" == "y" ] || [ "$OPT1" == "Y" ]; then
  SCAN_OPT1='-sC'
  SCAN=yes
fi
if [ "$OPT2" == "y" ] || [ "$OPT2" == "Y" ]; then
  SCAN_OPT2='-sV'
  SCAN=yes
fi
if [ "$OPT3" == "y" ] || [ "$OPT3" == "Y" ]; then
  SCAN_OPT3='-O'
  SCAN=yes
fi
if [ "$OPT4" == "y" ] || [ "$OPT4" == "Y" ]; then
  SCAN_OPT4='-vv --reason'
  SCAN=yes
fi
if [ "$OPT5" == "y" ] || [ "$OPT5" == "Y" ]; then
  SCAN_SPEED='-T4'
  SCAN=yes
elif [ "$OPT6" == "y" ] || [ "$OPT6" == "Y" ]; then
  SCAN_SPEED='-T3'
  SCAN=yes
elif [ "$OPT7" == "y" ] || [ "$OPT7" == "Y" ]; then
  SCAN_SPEED='-T2'
  SCAN=yes
fi

# Executing the scan
if [ "$SCAN" == 'yes' ]; then
  box_green "Scanning..."
  for HOST in $(egrep -v "^#|Status: Up" $OUTPUT_DIR/port.open | cut -d' ' -f2); do
    PORTS=$(egrep -v "^#|Status: Up" $OUTPUT_DIR/port.open | grep "$HOST" | cut -d' ' -f4- | tr ',' '\n' | sed -e 's/^[ \t]*//' | awk -F'/' '{print $1}' | tr '\n' ',' | sed 's/.$//')
    tput setaf 4
    echo "$HOST    $PORTS"
    tput sgr0
    if [ $USER != 'root' ]; then
      nmap -oG $OUTPUT_DIR/fingerprint/$HOST.grep.1 -oN $OUTPUT_DIR/fingerprint/$HOST.nmap.1 -Pn $SILENT $SCAN_OPT1 $SCAN_OPT2 $SCAN_OPT4 $SCAN_SPEED -p$PORTS $HOST
    else
      sudo nmap -oG $OUTPUT_DIR/fingerprint/$HOST.grep.1 -oN $OUTPUT_DIR/fingerprint/$HOST.nmap.1 -Pn $SILENT $SCAN_OPT1 $SCAN_OPT2 $SCAN_OPT3 $SCAN_OPT4 $SCAN_SPEED -p$PORTS $HOST
    fi
  done
else
  box_yellow "SKIPPING - No option selected"
fi
