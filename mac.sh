#!/bin/bash

# Define the network range to scan (change this to your network range)
NETWORK="192.168.1.0/24"

echo "------------------------------------------"
echo "Scanning the network $NETWORK for devices and models"
echo "------------------------------------------"

# Step 1: Scan for active devices and their MAC addresses using arp-scan
echo "Running arp-scan..."
sudo arp-scan --localnet > arp-scan-results.txt
echo "------------------------------------------"
echo "ARP-scan results:"
cat arp-scan-results.txt | grep -E "([0-9a-f]{2}:){5}[0-9a-f]{2}"

# Step 2: Scan using nmap with service detection
echo "Running nmap service detection..."
sudo nmap -sV $NETWORK > nmap-scan-results.txt
echo "------------------------------------------"
echo "Nmap service detection results:"
cat nmap-scan-results.txt | grep -E "Nmap scan report|MAC Address|Service Info"

# Step 3: UPnP Device Discovery (to find device model names)
echo "Running UPnP device discovery..."
upnp-inspector > upnp-results.txt
echo "------------------------------------------"
echo "UPnP discovery results (model information):"
grep -E "modelName|friendlyName" upnp-results.txt

# Optional: SNMP Scan for printers or devices exposing model info over SNMP
echo "Running SNMP scan (for printers, etc.)..."
sudo snmpwalk -v 2c -c public $NETWORK > snmp-results.txt
echo "------------------------------------------"
echo "SNMP discovery results (model information):"
grep -E "sysDescr|model" snmp-results.txt

# Combine and display results from all scans
echo "------------------------------------------"
echo "Devices found on your network with model names (if available):"
echo "------------------------------------------"

# Combine arp-scan, nmap service, and UPnP results
arp_scan_output=$(cat arp-scan-results.txt | grep -E "([0-9a-f]{2}:){5}[0-9a-f]{2}")
nmap_output=$(cat nmap-scan-results.txt | grep -E "Nmap scan report|Service Info")
upnp_output=$(grep -E "modelName|friendlyName" upnp-results.txt)
snmp_output=$(grep -E "sysDescr|model" snmp-results.txt)

# Display the combined output
echo "$arp_scan_output"
echo "$nmap_output"
echo "$upnp_output"
echo "$snmp_output"

echo "------------------------------------------"
echo "Script completed!"
