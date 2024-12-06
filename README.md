---

# QOL improvements for VivoBook_ASUSLaptop X513UA_KM513UA running Fedora Workstation.

**As of Linux kernel 6.11.10-300, these tweaks don't seem necessary.**  

## Automatic restoration of brightness.

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

   
## Unlocking Fn key at boot.  
```sh
   sudo grubby --update-kernel=ALL --args="asus_wmi.fnlock_default=0"
```
