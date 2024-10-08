---

# Brightness Adjustment for Fedora

These scripts help restore screen brightness after waking from suspend on Fedora 40 with GNOME and Wayland.

### Files

1. **adjust-brightness.sh**  
   Save to somewhere in `$PATH`. It saves brightness before suspend and restores it after.

2. **adjust-brightness.service**
   The service that restores brightness after suspend. Place in `/etc/systemd/system/`.

4. **restore-brightness.service**  
   Place in `/etc/systemd/system/`. Restores brightness at startup.

### Setup

1. **Copy the script**  
   ```sh
   sudo cp adjust-brightness.sh /usr/local/bin
   sudo chmod +x /usr/local/bin/adjust-brightness.sh
   
   ```

2. **Add the service**  
   ```sh
   sudo cp restore-brightness.service /etc/systemd/system/
   sudo systemctl enable restore-brightness.service
   sudo cp adjust-brightness.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable --now adjust-brightness.service
   ```
