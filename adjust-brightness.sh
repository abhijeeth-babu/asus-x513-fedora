#!/usr/bin/env bash

# Save this script to: /usr/lib/systemd/system-sleep/adjust-brightness.sh

brightness_file="/sys/class/backlight/amdgpu_bl1/brightness"
saved_brightness_file="/tmp/saved_brightness"

case "$1" in
  pre)
    # Save the current brightness before suspend
    current_brightness=$(cat "$brightness_file")
    echo "$current_brightness" > "$saved_brightness_file"
  ;;
  post)
    # Wait for 2 seconds after resume
    sleep 2

    # Restore the brightness after resume
    if [ -f "$saved_brightness_file" ]; then
      previous_brightness=$(cat "$saved_brightness_file")
      echo "$previous_brightness" | tee "$brightness_file"
    else
      # Set the brightness to 35 if no saved brightness is found
      echo 35 | tee "$brightness_file"
    fi
  ;;
esac
