##
## Port Scan Phase
##

box_green "TCP port scan mode"

PS3='Selection: '
options=(
"Top 10" \
"Top 50" \
"Top 100" \
"Top 500" \
"Top 1000" \
"Top 5000" \
"All Ports" \
"Exit")
select opt in "${options[@]}"
do
    case $opt in
        "${options[0]}")
            allowAbort=false;
            box_green "Scanning Top 10..."
            nmap -iL $IPS -oG $OUTPUT_DIR/port.open -oN $OUTPUT_DIR/port.nmap -Pn $SILENT --top-ports 10 --open || box_red "...scan aborted!";
            allowAbort=true;
            break
            ;;
        "${options[1]}")
            allowAbort=false;
            box_green "Scanning Top 50..."
            nmap -iL $IPS -oG $OUTPUT_DIR/port.open -oN $OUTPUT_DIR/port.nmap -Pn $SILENT --top-ports 50 --open || box_red "...scan aborted!";
            allowAbort=true;
            break
            ;;
        "${options[2]}")
            allowAbort=false;
            box_green "Scanning Top 100..."
            nmap -iL $IPS -oG $OUTPUT_DIR/port.open -oN $OUTPUT_DIR/port.nmap -Pn $SILENT --top-ports 100 --open || box_red "...scan aborted!";
            allowAbort=true;
            break
            ;;
        "${options[3]}")
            allowAbort=false;
            box_green "Scanning Top 500..."
            nmap -iL $IPS -oG $OUTPUT_DIR/port.open -oN $OUTPUT_DIR/port.nmap -Pn $SILENT --top-ports 500 --open || box_red "...scan aborted!";
            allowAbort=true;
            break
            ;;
        "${options[4]}")
            allowAbort=false;
            box_green "Scanning Top 1000..."
            nmap -iL $IPS -oG $OUTPUT_DIR/port.open -oN $OUTPUT_DIR/port.nmap -Pn $SILENT --top-ports 1000 --open || box_red "...scan aborted!";
            allowAbort=true;
            break
            ;;
        "${options[5]}")
            allowAbort=false;
            box_green "Scanning Top 5000..."
            nmap -iL $IPS -oG $OUTPUT_DIR/port.open -oN $OUTPUT_DIR/port.nmap -Pn $SILENT --top-ports 5000 --open || box_red "...scan aborted!";
            allowAbort=true;
            break
            ;;
        "${options[6]}")
            allowAbort=false;
            box_green "Scanning all ports..."
            nmap -iL $IPS -oG $OUTPUT_DIR/port.open -oN $OUTPUT_DIR/port.nmap -Pn $SILENT -p- --open || box_red "...scan aborted!";
            allowAbort=true;
            box_green "Full scan completed"
            break
            ;;
        "${options[7]}")
            break
            ;;
        *)
            ;;
    esac
done

#
# Cleaning unnecessary lines.
#

sed '/Status: Up/d' -i $OUTPUT_DIR/port.open
