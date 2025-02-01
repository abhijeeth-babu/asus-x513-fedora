---

# QOL improvements for VivoBook_ASUSLaptop X513UA_KM513UA running Fedora Workstation.

## Unlocking Fn key at boot.  
```sh
   sudo grubby --update-kernel=ALL --args="asus_wmi.fnlock_default=0"
```

## Setting up the 3.5mm jack microphone.
The device has Realtek ALC897 codec. To set up the microphone:
1. Install `alsa-utils`.
   ```sh
      sudo dnf install alsa-utils
   ```
2. Launch the HDAJackRetask utility.
3. Select the Realtek ALC897 codec from the drop down list.
4. Select show unconnected pins and advanced override.
5. Override the `0x19` pin and set it to **Microphone**.
6. Install boot override and reboot.
If it fails with the error that the device is busy, try the following, and then
install the boot override.
```sh
   systemctl --user stop pipewire.socket
   systemctl --user stop pipewire.service
   systemctl --user stop pipewire-pulse.socket
   systemctl --user stop pipewire-pulse.service
 ```
![Screenshot From 2025-01-17 17-47-29](https://github.com/user-attachments/assets/cd3fa88b-d86a-45f2-92ce-217bb03bcfb7)


## Automatic restoration of brightness.

**NOTE: As of Linux kernel 6.11.10-300, these tweaks don't seem necessary.**  
These scripts help restore screen brightness after waking from suspend, and after logging in from lockscreen.

**Disclaimer**: Use at your own risk, also try to go through the scripts and service files before using them. Tested on Fedora 40 and 41. YMMV.

**Dependencies**: `systemd`, `brightnessctl`, `gnome`.
### Files

1. **adjust-brightness.sh**  
   Save to somewhere in `$PATH`. It saves brightness before suspend and restores it after.

2. **adjust-brightness.service**  
   The service that restores brightness after suspend. Place in `/etc/systemd/system/`.

4. **restore-brightness.service**  
   Place in `/etc/systemd/system/`. Restores brightness at startup.

5. **brightness-state.sh**  
   Save to `$PATH`. It uses gdbus to monitor the lockscreen state.
   
6. **brightness-state.service**  
   User service that runs the above script. (Also one might use autostart)

### Setup

1. **Copy the script**  
   ```sh
   sudo cp adjust-brightness.sh /usr/local/bin
   sudo chmod +x /usr/local/bin/adjust-brightness.sh
   mkdir -p ~/.local/bin
   cp brightness-state.sh ~/.local/bin/
   chmod +x ~/.local/bin/brightness-state.sh
   
   ```

2. **Add the service**  
   ```sh
   sudo cp restore-brightness.service /etc/systemd/system/
   sudo systemctl enable restore-brightness.service
   sudo cp adjust-brightness.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable --now adjust-brightness.service
   mkdir -p ~/.config/systemd/user/
   cp brightness-state.service ~/.config/systemd/user/
   systemctl --user daemon-reload
   systemctl --user enable brightness-state.service
   systemctl --user start brightness-state.service
   
   ```

   


## Setting Battery Charge Threshold

To extend battery lifespan, you can set a charge threshold to stop charging at a specific percentage. This is particularly useful for laptops that are often plugged in. The following systemd services will set the battery charge threshold at boot and after resuming from suspend. If on gnome, you can use [Battery Health Charging extension for GNOME shell](https://github.com/maniacx/Battery-Health-Charging)

### Files

1. **battery-charge-threshold.service**  
   This service sets the battery charge threshold at boot. Place it in `/etc/systemd/system/`.

2. **battery-resume.service**  
   This service sets the battery charge threshold after resuming from suspend. Place it in `/etc/systemd/system/`.

### Setup

1. **Create the Services**  
   Create the following files with the provided content.

   **`/etc/systemd/system/battery-charge-threshold.service`**:
   ```ini
   [Unit]
   Description=Set the battery charge threshold at boot
   After=multi-user.target

   [Service]
   Type=oneshot
   ExecStart=/bin/bash -c 'echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

   [Install]
   WantedBy=multi-user.target
   ```

   **`/etc/systemd/system/battery-resume.service`**:
   ```ini
   [Unit]
   Description=Set battery charge threshold after resume
   After=suspend.target

   [Service]
   Type=oneshot
   ExecStart=/bin/bash -c 'echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold'

   [Install]
   WantedBy=suspend.target
   ```

2. **Enable and Start the Services**  
   Run the following commands to enable and start the services:

   ```sh
   sudo systemctl daemon-reload
   sudo systemctl enable --now battery-charge-threshold.service
   sudo systemctl enable --now battery-resume.service
   ```

3. **Verify the Services**  
   Check the status of the services to ensure they are running correctly:

   ```sh
   systemctl status battery-charge-threshold.service
   systemctl status battery-resume.service
   ```

### Notes
- Replace `60` in the `ExecStart` lines with your desired threshold (e.g., `80` or `100`).
- If your battery device is not `BAT0`, replace it with the correct device name (e.g., `BAT1`).


