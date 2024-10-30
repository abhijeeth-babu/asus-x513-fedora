#!/bin/bash

# Configuration
LOG_FILE="/tmp/brightness-unlock.log"

# Function to log messages
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >>"$LOG_FILE"
}

# Function to save brightness
save_brightness() {
  brightnessctl -q -s
  if [ $? -eq 0 ]; then
    log_message "Brightness state saved"
  else
    log_message "Failed to save brightness state"
  fi
}

# Function to restore brightness
restore_brightness() {
  brightnessctl -q -r
  if [ $? -eq 0 ]; then
    log_message "Brightness state restored"
  else
    log_message "Failed to restore brightness state"
  fi
}

# Check if brightnessctl is installed
if ! command -v brightnessctl &>/dev/null; then
  echo "Error: brightnessctl is not installed. Please install it first."
  exit 1
fi

# Create log file if it doesn't exist
touch "$LOG_FILE"
log_message "Script started"

# Monitor D-Bus messages and react to lock/unlock events
gdbus monitor -y -d org.freedesktop.login1 | while read -r line; do
  if echo "$line" | grep -q "LockedHint.*true"; then
    log_message "Screen locked - saving brightness state"
    save_brightness
  elif echo "$line" | grep -q "LockedHint.*false"; then
    log_message "Screen unlocked - restoring brightness state"
    restore_brightness
  fi
done
