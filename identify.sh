##
## Fingerprinting Phase
##

box_green "Attack Surface"
tput setaf 4
egrep -v "^#|Status: Up" ./scope/port.open | cut -d' ' -f2,4- | sed -n -e 's/Ignored.*//p' | awk -F, '{split($0,a," "); printf "%-16s (%d ports)\n" , a[1], NF}'
tput sgr0
mkdir -p $OUTPUT_DIR/fingerprint

box_green "FP1 - Scripts: Default + Service/Version + O.S. Detection (if root)"
read -e -p "Proceed (y/N): " PROCEED
if [ "$PROCEED" == "y" ] || [ "$PROCEED" == "Y" ]; then
  for HOST in $(cat $IPS); do
    PORTS=$(egrep -v "^#|Status: Up" $OUTPUT_DIR/port.open | grep "$HOST" | cut -d' ' -f4- | sed -n -e 's/Ignored.*//p' | tr ',' '\n' | sed -e 's/^[ \t]*//' | awk -F'/' '{print $1}' | tr '\n' ',' | sed 's/.$//')
    if [ $USER != 'root' ]; then
      nmap -oG $OUTPUT_DIR/fingerprint/scan.$HOST.grep.1 -oN $OUTPUT_DIR/fingerprint/scan.$HOST.nmap.1 -sC -sV -p$PORTS $HOST
    else
      nmap -oG $OUTPUT_DIR/fingerprint/scan.$HOST.grep.1 -oN $OUTPUT_DIR/fingerprint/scan.$HOST.nmap.1 -sC -sV -O -p$PORTS $HOST
    fi
  done
else
  box_yellow "SKIPPING"
fi
