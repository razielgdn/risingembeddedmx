---
title: "Custom Yocto Linux Distribution"
permalink:  /projects/en/yocto/custom-distro
key: yocto-custom-distro-en
tags:
    - Yocto
    - Linux
    - Customization
date: 2025-06-06
modify_date: 2025-06-10 
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

1. Open a terminal and navigate to the directory where you want to create your layer. For example, if you are in the `poky` directory, you can create a new layer called `meta-custom`:



