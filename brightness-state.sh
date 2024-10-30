#!/bin/bash

# Check if brightnessctl is installed
if ! command -v brightnessctl &>/dev/null; then
  echo "Error: brightnessctl is not installed. Please install it first."
  exit 1
fi

# Monitor D-Bus messages and react to lock/unlock events
gdbus monitor -y -d org.freedesktop.login1 | while read -r line; do
  if echo "$line" | grep -q "LockedHint.*true"; then
    brightnessctl -q -s
    brightnessctl -q -r
  elif echo "$line" | grep -q "LockedHint.*false"; then
    brightnessctl -q -r
  fi
done
