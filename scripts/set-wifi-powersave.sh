#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (use sudo)."
  exit 1
fi

# Help usage block
usage() {
  echo "Usage: $0 <on|off> [interface_name]"
  echo "Example: $0 off          (Disables power save on all Wi-Fi cards)"
  echo "Example: $0 on wlan0     (Enables power save only on wlan0)"
  exit 1
}

# Check for the mandatory first argument
ACTION=$(echo "$1" | tr '[:upper:]' '[:lower:]')
if [[ "$ACTION" != "on" && "$ACTION" != "off" ]]; then
  echo "Error: Missing or invalid action argument."
  usage
fi

TARGET_DEVICE=$2
echo "=== Wi-Fi Power Saving Manager ==="

# Determine which interfaces to process
if [ -n "$TARGET_DEVICE" ]; then
  # Verify if the user-provided device exists in the system
  if [ ! -e "/sys/class/net/$TARGET_DEVICE" ]; then
    echo "Error: Device '$TARGET_DEVICE' does not exist."
    exit 1
  fi
  interfaces="$TARGET_DEVICE"
else
  # Find all Wi-Fi interfaces automatically
  interfaces=$(ls /sys/class/net | grep -E '^(wlan|wlp|wlo|wlx)')
  if [ -z "$interfaces" ]; then
    echo "No Wi-Fi interfaces found on this system."
    exit 1
  fi
fi

# Loop through the selected interface(s)
for iface in $interfaces; do
  echo "----------------------------------------"
  echo "Target interface: $iface"

  # Apply the command based on available system tools
  if command -v iw &> /dev/null; then
    echo "Applying '$ACTION' via 'iw'..."
    iw dev "$iface" set power_save "$ACTION"
  elif command -v iwconfig &> /dev/null; then
    echo "Applying '$ACTION' via 'iwconfig'..."
    # iwconfig uses 'power on' or 'power off'
    iwconfig "$iface" power "$ACTION"
  else
    echo "Error: Neither 'iw' nor 'iwconfig' is installed on this system."
    exit 1
  fi

  # Verify and display the current hardware status
  if command -v iw &> /dev/null; then
    status=$(iw dev "$iface" get power_save 2>/dev/null)
    echo "Current status for $iface: $status"
  fi
done

echo "----------------------------------------"
echo "Operation completed successfully!"
