																																																											# DESIGN: FirefoxOS

This is a modular sovereign cloud operating system alternative like ChromeOS
- browser and cloud centric 
- minimal user access to the local latest version of Ubuntu Server Live LTS

**TARGET HARDWARE:** Lenovo M93p Tiny (Intel Core i5 2C/4T, 16GB RAM, 256GB SSD)
**RESOURCE ALLOCATION:** The minimalist Window Manager environment targets an idle RAM footprint of ~300-400MB. This reserves over 15.5GB of RAM and substantial CPU overhead for background containers, hypervisors, or sovereign web services.
**DESIGN PHILOSOPHY:** Strict signal flow. The OS acts as a straight-wire analog console. Inputs are manually routed, outputs are hard-patched, and unnecessary daemons are stripped from the signal path entirely.

---

## Stage 1: Core Architecture & Base Installation (The Console & Routing Matrix)

Deploy a headless foundation to guarantee zero bloated daemons are installed by default. This stage establishes the primary signal routing from the bare metal to the display server.

### Phase 1.1: Base Console Initialization
1.  Download the official **Ubuntu Server LTS** ISO.
2.  During the installation wizard, explicitly select the **Ubuntu Server Minimized** option.
3.  Configure the network interface (DHCP or static) and create the primary administrative user.
4.  Establish an SSH session into the node to execute the remaining configuration steps remotely.

### Phase 1.2: Display Server and Window Manager (The Routing Matrix)
Install the bare minimum graphical stack required to push pixels to the screen.

1.  Update the repository cache: `sudo apt update && sudo apt upgrade -y`
2.  Install the X11 display server and Openbox window manager: `sudo apt install --no-install-recommends xserver-xorg xinit openbox`
3.  Install a lightweight graphical login manager: `sudo apt install lightdm`
4.  Initialize the Openbox configuration directory for the development user:
    * `mkdir -p ~/.config/openbox`
    * `cp /etc/xdg/openbox/rc.xml ~/.config/openbox/`

### Phase 1.3: Interface and Telemetry (The Outputs)
Install the specific UI components to handle compositing, metrics, and application routing.

1.  Install the core visual packages: `sudo apt install picom polybar plank`
2.  Create the autostart script to boot these components in sequence: `nano ~/.config/openbox/autostart`
3.  Manually construct the following initialization sequence:

```bash
    picom -b &
    polybar main &
    plank &
```

4.  Set the script to be executable: `chmod +x ~/.config/openbox/autostart`

---

## Stage 2: The Lockdown Strategy (Hard-Patching the Environment)

This stage severs unauthorized input routing and enforces immutable file permissions, locking the end-user into a restricted GUI.

### Phase 2.1: Openbox Signal Stripping
Prevent the user from launching arbitrary applications by stripping the inputs at the Window Manager level.

1.  Open the Openbox configuration file: `nano ~/.config/openbox/rc.xml`
2.  Locate the `<mouse>` section. Delete the binding that triggers the `root-menu` (typically a right-click on the desktop).
3.  Locate the `<keyboard>` section. Strip out any keybinds mapped to terminal execution (e.g., `W-t` or `C-A-t`) or application launchers.
4.  Save and exit. The desktop is now inert to standard user inputs.

### Phase 2.2: Dock Pinning and Software Lock
Configure the interface while administrative write access is still available.

1.  Boot into the graphical environment and launch the specific authorized applications.
2.  Pin them to the Plank dock and arrange the order.
3.  Apply the internal `dconf` lock via CLI to disable UI-level drag-and-drop:
    * `dconf write /net/launchpad/plank/docks/dock1/lock-items true`

### Phase 2.3: Filesystem Immutable Lock
Enforce the lockdown by revoking the user's write access to the dock configuration.

1.  Drop back into the CLI.
2.  Change the ownership of the Plank launchers directory to `root`:
    * `sudo chown -R root:root ~/.config/plank/dock1/launchers/`
3.  Restrict permissions to read/execute only, effectively hard-patching the dock:
    * `sudo chmod -R 555 ~/.config/plank/dock1/launchers/`

---

## Stage 3: The Deployment Pipeline (Mastering the Image)

Package the customized operating system into a deployable, bootable ISO to ensure standardized deployment across any hardware.

### Phase 3.1: Skel Directory Staging
Ensure every new user created on the system inherits the exact restricted environment automatically.

1.  Copy the perfected `~/.config` folder to the system skeleton directory:
    * `sudo cp -r ~/.config /etc/skel/`
2.  Verify ownership within `/etc/skel/` so that the immutable locks on the Plank directory remain intact when copied to a new user's home folder.

### Phase 3.2: ISO Generation
Use Cubic (Custom Ubuntu ISO Creator) to master the final image.

1.  Install Cubic on a separate Linux workstation.
2.  Import the base Ubuntu Server ISO into Cubic.
3.  Inside the Cubic chroot virtual terminal, manually replicate the `apt install` commands from Stage 1 to inject Xorg, Openbox, Picom, Polybar, and Plank directly into the filesystem.
4.  Inject the customized `/etc/skel/` directory into the Cubic chroot environment.
5.  Instruct Cubic to rebuild the initramfs, update the checksums, and compile the final `.iso` file.

### Phase 3.3: Hardware Deployment
1.  Flash the generated `.iso` to a USB drive.
2.  Boot the hardware and run the standard installer.
3.  Upon completion, the system will boot directly into LightDM. Log in to verify the immutable floating-dock GUI is active.

---

## Stage 4: Ongoing Maintenance & Patch Routing

Because the file restrictions exist purely in the user-space (`~/.config`), system-level updates operate completely independently of the immutable UI locks.

### Path 1: Base System & Binary Updates (The Firmware Flash)
System packages, security patches, and kernel updates modify the underlying binaries (`/usr/bin/`, `/lib/`). These updates are executed with root privileges and bypass the unprivileged user's home directory entirely.

* **Workflow:** SSH into the node and execute standard `apt` update sequences manually. The node updates, reboots if necessary, and the end-user remains permanently trapped in the immutable UI upon login.
* **Command:** `sudo apt update && sudo apt upgrade`

### Path 2: UI & Configuration Updates (The Maintenance Toggle)
To push a feature update (e.g., adding a new authorized application to the locked dock), you must temporarily bypass the filesystem lock. This requires a dedicated bash script to act as an insert switch—a highly effective practical exercise for LFCS exam scripting objectives.

1.  Open an editor: `nano ~/maintenance_toggle.sh`
2.  Construct a script utilizing `if/elif` statements to evaluate lock state arguments:

```bash

#!/bin/bash

# Define the target signal path
DOCK_DIR="/home/user/.config/plank/dock1/launchers/" # Replace 'user' with the actual restricted username

# The Unlock Condition (Bypass Engaged)
if [ "$1" = "unlock" ]; then
    chown -R user:user "$DOCK_DIR"
    chmod -R 755 "$DOCK_DIR"
    echo "Dock unlocked. You may now patch routing."

# The Lock Condition (Bypass Disengaged)
elif [ "$1" = "lock" ]; then
    chown -R root:root "$DOCK_DIR"
    chmod -R 555 "$DOCK_DIR"
    echo "Dock locked. Routing matrix immutable."

# Catch-All Syntax Error
else
    echo "Usage: sudo ./maintenance_toggle.sh {unlock|lock}"
fi
````

3. Make the script executable: `chmod +x ~/maintenance_toggle.sh`
    
4. **Update Workflow:**
    
    - Execute `sudo ./maintenance_toggle.sh unlock`.
        
    - Pin the new app to the dock via the GUI.
        
    - Execute `sudo ./maintenance_toggle.sh lock` to re-secure the environment.

## Graphic User Interfce

Viewer:
Hugo via Obsidian
- Nextcloud
- Jellyfin