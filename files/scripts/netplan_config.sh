#!/usr/bin/env bash

# Get the list of available network interfaces
interfaces=$(ls /sys/class/net)

# Prompt the user to select a network interface
PS3="Select a network interface: "
select interface in $interfaces; do
    if [ -n "$interface" ]; then
        break
    fi
done

# Prompt the user for network configuration details
read -p "Enter static IP address (e.g., 192.168.0.100): " ip_address
read -p "Enter netmask (e.g., 24): " netmask
read -p "Enter gateway IP address: " gateway
read -p "Enter DNS server addresses (comma-separated): " dns_servers

# Split DNS servers into an array
IFS=',' read -ra dns_array <<< "$dns_servers"

# Generate Netplan configuration file
cat <<EOF | sudo tee /etc/netplan/01-netcfg.yaml > /dev/null
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      dhcp4: no
      addresses: [$ip_address/$netmask]
      gateway4: $gateway
      nameservers:
        addresses: [${dns_array[*]}]
EOF

# Apply the new network configuration
sudo netplan apply
exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "Netplan configuration applied successfully."
else
    echo "Error applying Netplan configuration. Exit code: $exit_code"
fi
