# mighty-scan

Mighty-Scan is a simple script that automates, guides, and properly documents outputs of the network enummeration (mostly using NMAP).

There is nothing new about scanning here. It only reduces repetitive typing.

## Usage

```
git clone https://github.com/davift/mighty-scan.git
cd mighty-scan
```

Optionally create a file with the target IPs/Networks in the scope.

```
echo "192.168.1.0/24" > ./scope/target.ips
echo "192.168.2.1" >> ./scope/target.ips
```

Then, execute the script with or without root privileges.

```
sudo ./mighty-scan.sh
```

**Note:** with root privileges, the scan will leverage additional features suck as syn scan (half-open scan).

