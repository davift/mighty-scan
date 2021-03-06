##
## Discovery Phase
##

box_green "Ping discovery"
nmap -iL $TARGET_FILE -oG $OUTPUT_DIR/scan.ping $SILENT -sn
tput setaf 4
tail -n 1 $OUTPUT_DIR/scan.ping
tput sgr0
cat $OUTPUT_DIR/scan.ping | grep -o -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | uniq | tee $OUTPUT_DIR/hosts.up

#
# TCP Discovery (bonus hint: --script discovery)
#

box_green "TCP discovery"
read -e -p "Check top 1000 ports (y/N): " TCP
if [ "$TCP" == "y" ] || [ "$TCP" == "Y" ]; then
  nmap -iL $TARGET_FILE -oG $OUTPUT_DIR/scan.tcp $SILENT -Pn
  if [ $USER != 'root' ]; then
    sed '/Status: Up/d' -i $OUTPUT_DIR/scan.tcp
    sed '/Ports: 	/d' -i $OUTPUT_DIR/scan.tcp
  fi
  tput setaf 4
  tail -n 1 $OUTPUT_DIR/scan.tcp
  tput sgr0
  cat $OUTPUT_DIR/scan.tcp | grep -o -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | uniq | tee -a $OUTPUT_DIR/hosts.up
else
  box_yellow "SKIPPING"
fi

#
# UDP Discovery
#

box_green "UDP discovery (very slow)"
read -e -p "Check top 10 ports (y/N): " UDP
if [ "$UDP" == "y" ] || [ "$UDP" == "Y" ] && [ $USER == 'root' ]; then
  nmap -iL $TARGET_FILE -oG $OUTPUT_DIR/scan.udp -Pn $SILENT -sU --top-ports 10
  tput setaf 4
  tail -n 1 $OUTPUT_DIR/scan.udp
  tput sgr0
  cat $OUTPUT_DIR/scan.udp | grep -o -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | uniq | tee -a $OUTPUT_DIR/hosts.up
elif [ "$UDP" == "y" ] || [ "$UDP" == "Y" ] && [ $USER != 'root' ]; then
  box_red "SKIPPING - Root required"
else
  box_yellow "SKIPPING"
fi

#
# Deduplication
#

cat $OUTPUT_DIR/hosts.up | sort | uniq > $OUTPUT_DIR/hosts.up.tmp
mv $OUTPUT_DIR/hosts.up.tmp $OUTPUT_DIR/hosts.up
