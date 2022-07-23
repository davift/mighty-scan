# mighty-scan

Mighty-Scan is a simple script that automates, guides, and properly documents outputs of the network enummeration (mostly using NMAP).

There is nothing new about scanning here. It only reduces repetitive typing.

It tries to optimize the scanning time by following the steps:

- Discover Hosts,
- Check for Open Ports,
- Fingerprints and Enumeration,
- Vulnerabilities and more Enumeration.

## Usage

```
git clone https://github.com/davift/mighty-scan.git
cd mighty-scan
```

Then, execute the script with  or without root privileges.

```
sudo ./mighty-scan.sh
```

**Note:** with root privileges (recommended), the scan will leverage additional features suck as syn scan (half-open scan).

