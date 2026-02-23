---
title: "Custom Yocto Linux Distribution"
permalink:  /projects/en/yocto/custom-distro
key: yocto-custom-distro-en
tags:
    - Yocto
    - Linux
    - Customization
date: 2026-02-18
modify_date: 2026-02-22 
---

This article contains the steps to create a layer to create a custom linux distribution to exemplify the process using yocto project. The characteristics of the distribution are:

- [x] It is based on poky-yocto.             
- [x] It will be run in a raspberry pi 4 platform. 
- [x] The image will be minimal to run without a graphical interface.
- [ ] It will include the capacity to connect to a wifi network.
- [ ] SSH and FTP services will be included to allow remote access to the device.
- [ ] A hello world kernel module will be included to explain how to include a custom kernel module in the distribution.
- [ ] A Build script will be included to automate the build process of the distribution.

The list above will be updated as the project progresses and the features are implemented and tested

## Creating the Layer.

To create a layer, we can use the Yocto Project's `bitbake-layers` tool, which simplifies the process of creating and managing layers. Here are the steps to create a new layer for our custom distribution:

1. Open a terminal and navigate to the directory where you want to create your layer. For example, if you are in the `poky` directory, you can create a new layer called `meta-custom` with the following command:
```bash
$ bitbake-layers create-layer ../meta-custom
```
This command will create a new directory called `meta-custom` with the necessary structure for a Yocto layer. 
The template has you can see has the following structure:
```meta-custom/
├── conf/
│   └── layer.conf
├── recipes-example/
│   └── example/ 
│       └── example_1.0.bb
├── README
└── COPYING.MIT     
```

2. Verify the layer was created correctly by navigating into it and checking its structure.

3. Initialize the layer in your build configuration by adding it to your `bblayers.conf` file:
```bash
$ bitbake-layers add-layer ../meta-custom
```

## Transitioning from Example to Functional Layer

The template created by `bitbake-layers` provides a basic structure, but to create a functional and production-ready layer like `meta-rising-embedded-os`, you need to make several modifications:

### Step 1: Rename and Organize the Layer

First, rename your layer to reflect its purpose:
```bash
$ mv meta-custom meta-rising-embedded-os
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

# Distribution identity
DISTRO = "rising-embedded-os"
DISTRO_NAME = "Rising-Embedded-OS"
DISTRO_VERSION = "1.0"
DISTRO_CODENAME = "OLINUX"

# Remove unnecessary features to reduce image size
DISTRO_FEATURES:remove = " \
                sysvinit \
                bluetooth \
                pcmcia \
                wayland \
                bluez5 \
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

# Add essential features
DISTRO_FEATURES:append = " \
                systemd \
                wifi \
                pam \
                usrmerge \
                "

# We need to backfill sysvinit for compatibility with some packages that expect it. 
DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit "

# Set systemd as the init system
VIRTUAL-RUNTIME_init_manager = "systemd"
VIRTUAL-RUNTIME_initscripts = "systemd-compat-units"
# Set the root home directory  
ROOT_HOME = "/root "
# Accept the license for the synaptics-killswitch and commercial packages, 
# which are required by some of the packages in this distribution.
LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch commercial"
# Set default hostname 
hostname_pn-base-files = "risingembeddedmx"

GLIBC_GENERATE_LOCALES = "en_US.UTF-8"
IMAGE_LINGUAS = "en-us"
# Avoid installing recommended packages
NO_RECOMMENDATIONS = "1"

# Enable UART
ENABLE_UART = "1"
# Disable Bluetooth
RPI_EXTRA_CONFIG:append = " \n dtoverlay=disable-bt \n "
```

### Step 4: Create Recipe Directories

Organize your recipes by category:

```bash
$ mkdir -p meta-rising-embedded-os/recipes-risingembeddedmx/image
$ mkdir -p meta-rising-embedded-os/recipes-risingembeddedmx/custom-application
$ mkdir -p meta-rising-embedded-os/recipes-bsp
$ mkdir -p meta-rising-embedded-os/recipes-kernel/kconf
```

### Step 5: Create a Base Image Recipe

Create `recipes-risingembeddedmx/image/rising-embedded-os-image.bb`:

```python
SUMMARY = "Recipe for an image for rising embedded os."
DESCRIPTION = "Custom image for rising embedded os based on core-image-base, with additional packages and features."
LICENSE = "MIT"
include recipes-core/images/core-image-base.bb

# Essential packages
IMAGE_INSTALL += "\ 
                  linux-firmware-rpidistro-bcm43455 \
                  nfs-utils \
                  networkmanager \
                  nano \
                  vim \
                  "

# Network services
IMAGE_FEATURES += " nfs-server ssh-server-dropbear "
#Only produce the "rpi-sdimg" image format
IMAGE_FSTYPES = " rpi-sdimg "

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

### Step 6: Add Custom Applications (Optional)

Create recipe files for custom applications. For example, `recipes-risingembeddedmx/custom-application/re-custom-application_1.0.bb`:

```python
DESCRIPTION = "Example to learn how to use a helloworld application"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/razielgdn/custom-application-test.git;protocol=https;branch=main"
SRCREV = "${AUTOREV}"
#BB_STRICT_CHECKSUM = "0"
S = "${WORKDIR}/git"

# S = "${WORKDIR}"
do_compile(){
    # Your code here #
     ${CC} hello.c -o hello ${LDFLAGS}
    # oe_runmake 
    
}
do_install(){
    # Your code here
            install -d ${D}${bindir}
            install -m 0777 hello ${D}${bindir}/
}
```
### Step 7: Add Custom Kernel Modules (Optional)

Create recipe files for custom kernel modules in `recipes-kernel/kconf/`. For example, `recipes-kernel/kconf/linux-raspberrypi$.bbappend`:

```python
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = "file://fragment.cfg"
```
And the `fragment.cfg` file would contain the necessary configuration to include your custom kernel module in the build.

```
CONFIG_PACKET_DIAG=m
CONFIG_UNIX_DIAG=m
```

### Step 8: Extending Boot Files with bbappend

The `bbappend` files are a feature in Yocto that allow you to extend or modify recipes from other layers without changing the original recipe files. A practical example is the `rpi-bootfiles.bbappend` file, which extends the boot files for Raspberry Pi.

Create `recipes-bsp/rpi-bootfiles/rpi-bootfiles.bbappend`:

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



### Step 9: Configure the Build Environment 

To build using your custom distribution and layer:

```bash
$ source oe-init-build-env build-rpi
$ echo 'DISTRO = "rising-embedded-os"' >> conf/local.conf
$ echo 'MACHINE = "raspberrypi4"' >> conf/local.conf
$ bitbake-layers add-layer /path/to/meta-rising-embedded-os
```

### Step 10: Build the Image

```bash
$ bitbake rising-embedded-core-image
```

The build artifacts will be generated in `tmp/deploy/images/raspberrypi4/`.

This transformation takes the basic layer template and extends it into a production-ready layer suitable for embedded Linux systems.




