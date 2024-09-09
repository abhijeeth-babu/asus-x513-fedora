Here's a simpler and more casual version:

---

# Brightness Adjustment for Fedora

These scripts help restore screen brightness after waking from suspend on Fedora 40 with GNOME and Wayland.

### Files

1. **adjust-brightness.sh**  
   Save to `/usr/lib/systemd/system-sleep/`. It saves brightness before suspend and restores it after.

2. **restore-brightness.service**  
   Place in `/etc/systemd/system/`. Restores brightness at startup.

### Setup

1. **Copy the script**  
   ```sh
   sudo cp adjust-brightness.sh /usr/lib/systemd/system-sleep/
   sudo chmod +x /usr/lib/systemd/system-sleep/adjust-brightness.sh
   ```

2. **Add the service**  
   ```sh
   sudo cp restore-brightness.service /etc/systemd/system/
   sudo systemctl enable restore-brightness.service
   ```

### That's it!

The brightness will now be saved and restored automatically.

--- 

Feel free to tweak it as needed!
