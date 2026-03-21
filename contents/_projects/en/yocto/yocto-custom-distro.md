---
title: "Custom Yocto layer for Raspberry Pi 4"
permalink:  /projects/en/yocto/custom-distro
key: yocto-custom-distro-en
tags:
    - Yocto
    - Linux
    - Customization
date: 2026-02-18
modify_date: 2026-02-22 
---

This article explains how to create a custom Linux distribution layer using the Yocto Project. The characteristics of the distribution are:

- [x] It is based on poky-yocto.             
- [x] It will be run on a Raspberry Pi 4 platform. 
- [x] The image will be minimal to run without a graphical interface.
- [x] It will include the ability to connect to a Wi-Fi network.
- [x] SSH and FTP services will be included to allow remote access to the device.
- [x] A hello world kernel module will be included to explain how to include a custom kernel module in the distribution.
- [x] A Build script will be included to automate the build process of the distribution.

The list above will be updated as the project progresses and the features are implemented and tested.
## Important Considerations

This project is intended to be a learning experience for those interested in embedded Linux development and the Yocto Project. It is not meant to be a production-ready distribution, but rather a starting point for understanding how to create and customize a Linux distribution using Yocto.

To follow the steps in this article you should work with the containerized Yocto environment provided in the last article. 
Ensure you follow the instructions in the previous article to set up your environment before proceeding with the steps outlined in this article.

I experienced some issues with the build process related to the permissions, resources allocated to the image, and the internet connections. In my own setup I had to change the resources allocated to the container using Docker Desktop to adapt it to my hardware capabilities. 

These are the parameters used to configure the setup.  My setup is the following:
- CPU: 10
- Memory: 12GB
- Swap: 4GB
- Disk: 400GB 


If you do not use Docker Desktop, you can use the docker-compose file configured with the parameters adjusted to your setup.

```diff
      - TERM=xterm-256color                      # Enable 256-color terminal support
+    deploy:
+      resources:
+        limits:
+          cpus: '10'                             # Limit container to 10 CPU cores
+          memory: 12G                            # Limit container to 12GB RAM
+        reservations:
+          cpus: '2'                              # Reserve 2 CPU cores for optimal performance
+          memory: 4G                            # Reserve 4GB RAM for stable operation

volumes:
```
### Creating the Layer

To create a layer, we can use the Yocto Project's `bitbake-layers` tool, which simplifies the process of creating and managing layers. Here are the steps to create a new layer for our custom distribution:

1. Open a terminal and navigate to the directory where you want to create your layer. For example, if you are in the `poky` directory, you can create a new layer called `meta-custom` with the following command:
```bash
$ bitbake-layers create-layer ../meta-custom
```
This command will create a new directory called `meta-custom` with the necessary structure for a Yocto layer. 
The template, as you can see, has the following structure:
```
meta-custom/
├── conf/
│   └── layer.conf
├── recipes-example/
│   └── example/ 
│       └── example_1.0.bb
├── README
└── COPYING.MIT     
```

2. Verify the layer was created correctly by navigating into it and checking its structure.

3. Keep the layer outside of the build directory for now. We will rename it first and then add it to `bblayers.conf`.

## Transitioning from Example to Functional Layer

The template created by `bitbake-layers` provides a basic structure, but to create a functional and production-ready layer like `meta-rising-embedded-os`, you need to make several modifications:

### Step 1: Rename and Organize the Layer

First, rename your layer to reflect its purpose:
```bash
$ mv meta-custom meta-rising-embedded-os
```

Then add the renamed layer to your build configuration:
```bash
$ bitbake-layers add-layer ../meta-rising-embedded-os
```

### Step 2: Update the layer.conf File

Modify the `conf/layer.conf` file to properly identify your layer and define its dependencies:

```python
# We have a conf and classes directory, add to BBPATH
BBPATH .= ":${LAYERDIR}"

# We have recipes-* directories, add to BBFILES
BBFILES += "${LAYERDIR}/recipes-*/*/*.bb \
            ${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "rising-embedded-os-layer"
BBFILE_PATTERN_rising-embedded-os-layer = "^${LAYERDIR}/"
BBFILE_PRIORITY_rising-embedded-os-layer = "6"

LAYERDEPENDS_rising-embedded-os-layer = "core"
LAYERSERIES_COMPAT_rising-embedded-os-layer = "scarthgap"
```

Key components explained:
- **BBFILE_PRIORITY**: Higher numbers mean higher priority. Set this to override recipes from other layers (typically 6 for custom layers).
- **LAYERDEPENDS**: Specifies which layers this layer depends on. The `core` layer is essential.
- **LAYERSERIES_COMPAT**: Indicates which Yocto versions this layer is compatible with.

### Step 3: Create a Distribution Configuration

Create a custom distribution configuration file at `conf/distro/rising-embedded-os.conf`:

```python
MAINTAINER = "your.email@example.com"
require conf/distro/poky.conf

# Set the distribution name, version, and codename
DISTRO = "rising-embedded-os"
DISTRO_NAME = "Rising-Embedded-MX-OS"
DISTRO_VERSION = "1.0"
DISTRO_CODENAME = "OLINUX"
# Remove unnecessary features to reduce image size
DISTRO_FEATURES:remove = " \ 
                sysvinit \
                pcmcia \
                wayland \
                ext2 \
                irda \
                x11 \
                nfc \
                ptest \
                3g \
                pulseaudio \
                alsa-plugins \
                opengl \
                egl \
                "

# Add only essential features  
DISTRO_FEATURES:append = " \ 
                systemd \
                wifi \
                pam \
                usrmerge \
                "

# We need to backfill sysvinit for compatibility with some packages that expect it. 
DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit "

# Set the default init system to systemd
VIRTUAL-RUNTIME_init_manager = "systemd "
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units "

# Set the root home directory  
ROOT_HOME = "/root "
# Accept the license for the synaptics-killswitch and commercial packages, 
# which are required by some of the packages in this distribution.
LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch commercial"

# Set default hostname 
hostname_pn-base-files = "risingembeddedmx"

# Set the default locale and language settings for the image
GLIBC_GENERATE_LOCALES = "en_US.UTF-8"
IMAGE_LINGUAS = "en-us"

# Avoid installing recommended packages 
NO_RECOMMENDATIONS = "1"

# Set default timezone
DEFAULT_TIMEZONE = "America/Monterrey" 

# Enable UART
ENABLE_UART = "1"
```

### Step 4: Create Recipe Directories

Organize your recipes by category and create the necessary directories for your custom recipes:

```bash
$ mkdir -p meta-rising-embedded-os/recipes-risingembeddedmx/image
$ mkdir -p meta-rising-embedded-os/recipes-risingembeddedmx/custom-application
$ mkdir -p meta-rising-embedded-os/recipes-bsp
$ mkdir -p meta-rising-embedded-os/recipes-kernel/kconf
```

### Step 5: Create a Base Image Recipe
The bb file defines the base image for the distribution, including the packages and features to be included. It also specifies the image format and other configurations related to the image build process.


Create `recipes-risingembeddedmx/image/rising-embedded-os-image.bb`:

```python
SUMMARY = "Recipe for an image for rising embedded os."
DESCRIPTION = "Custom image for rising embedded os based on core-image-base, with additional packages and features."
LICENSE = "MIT"
include recipes-core/images/core-image-base.bb

# Essential packages
IMAGE_INSTALL += "\
                  linux-firmware-rpidistro-bcm43455 \
                  kernel-modules \
                  nano \  
                  busybox \
                  busybox-udhcpc \
                  wpa-supplicant \
                  wpa-supplicant-cli \
                  wpa-supplicant-passphrase \
                  iproute2 \
                  iw \
                  rfkill \
                  openssh-sftp-server \
                  network-setup \
                  default-user \
                  "

# Network services
IMAGE_FEATURES += " nfs-server ssh-server-dropbear "
#Only produce the "rpi-sdimg" image format
IMAGE_FSTYPES = "rpi-sdimg"

#Remove old builds
RM_OLD_IMAGE = "1"

# Remove bluetooth packages
IMAGE_INSTALL:remove = " bluez5 obexftp "

# Set the boot partition size to 128MB
BOOT_SPACE = "131072"

# Align the root filesystem to 4KB and add extra space for growth
IMAGE_ROOTFS_ALIGNMENT = "4096"
# Set the overhead factor to account for filesystem metadata and growth
IMAGE_OVERHEAD_FACTOR = "1.5"
# Add extra space (512MB) to the root filesystem to ensure it can grow without running out of space
IMAGE_ROOTFS_EXTRA_SPACE = "524288"
```

### Step 6: Enable Wi-Fi Support

At this point the image has support for Wi-Fi; however, when I performed the tests I had some difficulties connecting to the device. 
1. All the necessary packages are included in the image; however, the configuration must be performed manually — additional instructions were added to guide the connection.
2. The packages were installed in the `usr/sbin` path and the only way to execute them was to run from the exact path, for example: `/usr/sbin/wpa_supplicant` instead of just `wpa_supplicant`. 
3. To use SSH and SFTP services, it is recommended to create a user with a password, since the default user is root without a password, which is not recommended for security reasons.

The recipe was improved with some scripts and configuration files to make the Wi-Fi connection easier. 

#### Configure wpa_supplicant to connect to a Wi-Fi network automatically at boot.

- Create the path to store the instructions:
  
```bash
$ mkdir -p recipes-connectivity/network-setup
$ mkdir -p recipes-connectivity/network-setup/files
$ mkdir -p recipes-connectivity/wpa-supplicant
$ mkdir -p recipes-connectivity/wpa-supplicant/files
```

- Create the `wpa_supplicant.conf` file in `recipes-connectivity/files/wpa-supplicant.conf`: 

```conf
ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
update_config=1
country=MX

network={
    ssid="Your-SSID"
    psk="Wifi-Password"
    key_mgmt=WPA-PSK
    scan_ssid=1
}
```

- Create the file `wpa_supplicant_%.bbappend` in `recipes-connectivity/wpa-supplicant/wpa_supplicant_%.bbappend`:

```python
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://wpa_supplicant.conf"

# Keep daemon active at boot so wpa_cli can connect without manual startup.
SYSTEMD_AUTO_ENABLE = "enable"

do_install:append() {
    install -d ${D}${sysconfdir}
    install -m 0600 ${WORKDIR}/wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant.conf
}
```

#### Configure the network-setup script to use wpa_supplicant for Wi-Fi management.

- Create the `network-setup_1.0.bb` file in `recipes-connectivity/network-setup/network-setup_1.0.bb`:

```python
SUMMARY = "Minimal Wi-Fi setup service using wpa_supplicant and udhcpc"
DESCRIPTION = "Installs a shell script and systemd service that associates \
               wlan0 with the AP defined in /etc/wpa_supplicant.conf and \
               requests a DHCPv4 address at boot."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://network-setup.sh \
    file://network-setup.service \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "network-setup.service"
SYSTEMD_AUTO_ENABLE = "enable"

RDEPENDS:${PN} = "wpa-supplicant busybox-udhcpc rfkill iproute2"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/network-setup.sh ${D}${bindir}/network-setup.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/network-setup.service ${D}${systemd_system_unitdir}/network-setup.service
}

FILES:${PN} += "${systemd_system_unitdir}/network-setup.service"
```

- Create the `network-setup.sh` file in `recipes-connectivity/network-setup/files/network-setup.sh`:

```bash
#!/bin/sh
# network-setup.sh
# Minimal Wi-Fi setup: associates with AP using wpa_supplicant and gets
# DHCPv4 via udhcpc. SSID and password are read from WPA_CONF locally.

IFACE="wlan0"
WPA_CONF="/etc/wpa_supplicant.conf"
WPA_PID="/var/run/wpa_supplicant.pid"

# Unblock Wi-Fi adapter (rfkill)
rfkill unblock wifi

# Bring interface up
ip link set "$IFACE" up

# Kill any stale wpa_supplicant instance
if [ -f "$WPA_PID" ]; then
    kill "$(cat "$WPA_PID")" 2>/dev/null
    rm -f "$WPA_PID"
fi

# Start wpa_supplicant in background
wpa_supplicant -B -i "$IFACE" -c "$WPA_CONF" -P "$WPA_PID"

# Wait for association (up to 20 seconds)
TIMEOUT=20
ELAPSED=0
while [ "$ELAPSED" -lt "$TIMEOUT" ]; do
    STATE=$(wpa_cli -i "$IFACE" status 2>/dev/null | grep "^wpa_state" | cut -d= -f2)
    if [ "$STATE" = "COMPLETED" ]; then
        break
    fi
    sleep 1
    ELAPSED=$((ELAPSED + 1))
done

if [ "$STATE" != "COMPLETED" ]; then
    echo "network-setup: Wi-Fi association failed after ${TIMEOUT}s" >&2
    exit 1
fi

# Request DHCPv4
udhcpc -i "$IFACE" -q -n

echo "network-setup: Wi-Fi up on $IFACE"

```

- Create the `network-setup.service` file in `recipes-connectivity/network-setup/files/network-setup.service`:

```ini
[Unit]
Description=Minimal Wi-Fi setup (wpa_supplicant + udhcpc)
After=systemd-udevd.service
Wants=systemd-udevd.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/network-setup.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```


### Step 7: Add Custom Applications (Optional)

Create recipe files for custom applications. For example, `recipes-risingembeddedmx/custom-application/re-custom-application_1.0.bb`:

```python
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://wpa_supplicant.conf"

# Keep daemon active at boot so wpa_cli can connect without manual startup.
SYSTEMD_AUTO_ENABLE = "enable"

do_install:append() {
    install -d ${D}${sysconfdir}
    install -m 0600 ${WORKDIR}/wpa_supplicant.conf ${D}${sysconfdir}/wpa_supplicant.conf
}
```
### Step 8: Add a default user to the image

Create the `default-user_1.0.bb` file in `recipes-core/default-user/`:

```python
SUMMARY = "Create a local default user on first boot"
DESCRIPTION = "Installs a generic default-user config and a systemd oneshot service that creates a local user at first boot."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://default-user.conf \
    file://default-user-setup.sh \
    file://default-user-setup.service \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "default-user-setup.service"
SYSTEMD_AUTO_ENABLE = "enable"

RDEPENDS:${PN} = "shadow"

do_install() {
    install -d ${D}${sysconfdir}
    install -m 0600 ${WORKDIR}/default-user.conf ${D}${sysconfdir}/default-user.conf

    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/default-user-setup.sh ${D}${bindir}/default-user-setup.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/default-user-setup.service ${D}${systemd_system_unitdir}/default-user-setup.service
}

FILES:${PN} += "${systemd_system_unitdir}/default-user-setup.service"
```
- Create the `default-user.conf` file in `recipes-core/default-user/files/default-user.conf`:

```conf
# Local default user configuration
# Keep this committed with generic values.
# For local/private values, edit this file and optionally mark it skip-worktree.

DEFAULT_USER="user-default"
DEFAULT_PASSWORD="<change-me>"
DEFAULT_GROUPS="audio,video"
```
- Create the `default-user-setup.sh` file in `recipes-core/default-user/files/default-user-setup.sh`:

```bash
#!/bin/sh
# Create a default user at first boot using settings from /etc/default-user.conf.
# This script is intended to run as a one-shot systemd service. It reads the
# target username, password, and optional group memberships from the config file,
# validates the values, creates the user if they do not already exist, sets the
# password, and writes a stamp file so the service does not run again on subsequent boots.

# Exit immediately on errors and treat unset variables as errors.
set -eu

# Path to the configuration file that defines the default user credentials and groups.
CFG="/etc/default-user.conf"

# Directory and stamp file used to track whether setup has already been completed.
STAMP_DIR="/var/lib/default-user"
STAMP_FILE="${STAMP_DIR}/configured"

# Abort silently if the configuration file is missing; nothing to do.
if [ ! -f "$CFG" ]; then
    echo "default-user-setup: missing $CFG"
    exit 0
fi

# Source the configuration file to import DEFAULT_USER, DEFAULT_PASSWORD, DEFAULT_GROUPS.
# shellcheck source=/dev/null
. "$CFG"

# Read credentials and group list from the sourced config, defaulting to empty strings.
USER_NAME="${DEFAULT_USER:-}"
USER_PASS="${DEFAULT_PASSWORD:-}"
USER_GROUPS="${DEFAULT_GROUPS:-}"

# Abort if the mandatory username or password fields are empty.
if [ -z "$USER_NAME" ] || [ -z "$USER_PASS" ]; then
    echo "default-user-setup: missing DEFAULT_USER or DEFAULT_PASSWORD"
    exit 0
fi

# Abort if the config still contains the default placeholder values to prevent
# accidental creation of an insecure user on a production image.
if [ "$USER_NAME" = "user-default" ] || [ "$USER_PASS" = "<change-me>" ]; then
    echo "default-user-setup: placeholder credentials detected; skipping"
    exit 0
fi

# Create the user only if they do not already exist on the system.
if ! id "$USER_NAME" >/dev/null 2>&1; then
    GROUP_ARGS=""

    # If a group list was provided, validate each entry against /etc/group and
    # build a comma-separated list of groups that actually exist on this image.
    if [ -n "$USER_GROUPS" ]; then
        VALID_GROUPS=""
        OLD_IFS="$IFS"
        IFS=','
        for grp in $USER_GROUPS; do
            # Include the group only if it is defined in /etc/group.
            if grep -q "^${grp}:" /etc/group; then
                if [ -z "$VALID_GROUPS" ]; then
                    VALID_GROUPS="$grp"
                else
                    VALID_GROUPS="${VALID_GROUPS},${grp}"
                fi
            fi
        done
        IFS="$OLD_IFS"

        # Build the useradd -G argument only when at least one valid group was found.
        if [ -n "$VALID_GROUPS" ]; then
            GROUP_ARGS="-G ${VALID_GROUPS}"
        fi
    fi

    # Create the user with a home directory and /bin/sh as the login shell.
    # Include supplementary group membership when available.
    if [ -n "$GROUP_ARGS" ]; then
        useradd -m -s /bin/sh $GROUP_ARGS "$USER_NAME"
    else
        useradd -m -s /bin/sh "$USER_NAME"
    fi
fi

# Set (or update) the user's password using chpasswd.
echo "${USER_NAME}:${USER_PASS}" | chpasswd

# Write the stamp file so the systemd one-shot service does not repeat on next boot.
install -d "$STAMP_DIR"
touch "$STAMP_FILE"

echo "default-user-setup: user ${USER_NAME} configured"
```
- Create the `default-user-setup.service` file in `recipes-core/default-user/files/`

```ini
[Unit]
Description=Configure default local user on first boot
After=local-fs.target
ConditionPathExists=!/var/lib/default-user/configured

[Service]
Type=oneshot
ExecStart=/usr/bin/default-user-setup.sh
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

### Step 9: Extending Boot Files with bbappend (Optional) 

The `bbappend` files are a feature in Yocto that allow you to extend or modify recipes from other layers without changing the original recipe files. A practical example is the `rpi-bootfiles.bbappend` file, which extends the boot files for Raspberry Pi.

Create `recipes-bsp/bootfiles/rpi-bootfiles.bbappend`:

```python
SUMMARY = "This is a file to learn how to a bbappend works"

BCM2711_DIR = "bcm2711-bootfiles"

do_deploy:append() {
    bbnote "BCM2711 custom deploy: Starting"
    bbnote "Creating custom bootfiles directory: ${DEPLOYDIR}/${BCM2711_DIR}"
    
    install -d ${DEPLOYDIR}/${BCM2711_DIR}

    for i in ${S}/*.elf ; do
        bbnote "Copying .elf: $i"
        cp $i ${DEPLOYDIR}/${BCM2711_DIR}/
    done
    
    for i in ${S}/*.dat ; do
        bbnote "Copying .dat: $i"
        cp $i ${DEPLOYDIR}/${BCM2711_DIR}/
    done

    for i in ${S}/*.bin ; do
        bbnote "Copying .bin: $i"
        cp $i ${DEPLOYDIR}/${BCM2711_DIR}/
    done
    
    bbnote "Copying overlays"
    if [ -d ${S}/overlays ]; then
        cp -r ${S}/overlays/ ${DEPLOYDIR}/${BCM2711_DIR}/
    fi
    
    bbnote "BCM2711 custom deploy: Completed"
}
```
### Step 10: Add Custom Kernel Modules (Optional)

Create recipe files for custom kernel modules in `recipes-kernel/kconf/`. For example, `recipes-kernel/kconf/linux-raspberrypi%.bbappend`:

```python
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = "file://fragment.cfg"
```

Create the fragment.cfg file in `recipes-kernel/kconf/files/fragment.cfg`:
```
CONFIG_PACKET_DIAG=m
CONFIG_UNIX_DIAG=m
```


## Build the Image

```bash
$ bitbake rising-embedded-os-image
```

The build artifacts will be generated in `/home/yocto/tmp/deploy/images/raspberrypi4-64`.

This transformation takes the basic layer template and extends it into a production-ready layer suitable for embedded Linux systems.



## Flash the Image to an SD Card

Use `dd` to flash the image to an SD card. First, identify the device name of your SD card (e.g., /dev/sdX) using `lsblk` or `fdisk -l`.
If you build with the script provided in the repository, the image will be generated in `boards/rpi4/rpi4-image-to-flash.sdimg`. Use the following command to flash it:

```bash
$ sudo dd if=boards/rpi4/rpi4-image-to-flash.sdimg of=/dev/sdX bs=4M conv=fsync
```     
Otherwise, use the image generated in `/home/yocto/tmp/deploy/images/raspberrypi4-64` and flash it to the SD card using the same command, replacing the input file path accordingly.


## Testing the Image

The image boots without problems on the Raspberry Pi 4. After the first boot, you can log in with the default credentials (root) and you will have access to the terminal.
The keyboard was detected without problems and I could navigate through the filesystem.

Finally, the image is running with all the promised features: the Wi-Fi connection is working and I can connect to the device using SSH and SFTP.

Once the image is running, you can connect to the device using SSH or SFTP with the default credentials. You can also check the Wi-Fi connection status and manage it using the `wpa_cli` tool.

You can check the IP address assigned to the device using the `ip addr` command and check the Wi-Fi connection status with `wpa_cli -i wlan0 status` (the instruction should be executed as root).

You can use `scp` to transfer files to the device, for example:
- `scp default-user@<device-ip>:/home/default-user` to copy files from the device to your local machine.



## Project Repository

[rsEmb-Image](https://github.com/razielgdn/rsEmb-Image): This repository contains the custom Yocto layer `meta-rising-embedded-os` with the configurations, recipes, and files needed to build the custom Linux distribution for Raspberry Pi 4 described in this article.

Its documentation explains the layer structure and how to use it to build the image.


