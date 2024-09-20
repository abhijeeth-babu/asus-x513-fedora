#!/bin/bash

# Add your commands here
# echo "System has woken up from suspend at $(date)" >> /tmp/wake-up-log.txt

brightness_file="/sys/class/backlight/amdgpu_bl1/brightness"
# You can add more commands as needed
sleep 0.33
cat "$brightness_file" | tee "$brightness_file"
# echo "Resetting brightness" >> /tmp/wake-up-log.txt
