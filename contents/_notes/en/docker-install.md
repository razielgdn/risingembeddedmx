---
title: Docker introduction and installation
permalink: /notes/en/docker-inst-en
key: docker-en
modify_date: 2025-06-19
date: 2025-06-19  
lang: en
---


According to Wikipedia, Docker is an open-source project that automates the deployment of applications within software containers, providing an additional layer of abstraction and automation for application virtualization across multiple operating systems. Docker uses Linux kernel resource isolation features, such as cgroups and namespaces, to allow independent "containers" to run within a single Linux instance, avoiding the overhead of starting and maintaining virtual machines.

Its history began in 2008 when Solomon Hykes started Docker as a project within the company dotCloud. In March 2013, it was released as open source, and the project has grown since then to the extent of being natively included in Windows and is now an industry standard.

# Virtualization Concepts
Below are some useful concepts for understanding the technologies used by Docker.
## What is Virtualization?
Virtualization is a technology that creates virtual environments to run multiple operating systems or applications on the same physical hardware. It allows abstraction of resources like CPU, memory, storage, and networking, simulating independent machines (virtual machines or containers). This improves efficiency, portability, and isolation. Instead of having a dedicated physical computer for each task, you can create multiple "virtual computers" sharing the same physical hardware. It’s like dividing a large house into several independent apartments.

## What is a Virtual Machine?
A virtual machine (VM) is a virtual environment that emulates a complete physical computer, including its own operating system, CPU, memory, and storage. It is created using a hypervisor (such as VMware or VirtualBox) that divides the physical hardware resources. VMs offer strong isolation but are heavier than containers because they include a full operating system.
Key features:
- Complete and independent operating system
- Full isolation from the host system
- Consumes significant resources (several GB of RAM)
- Slow startup (must boot the entire OS)

## What is a Container?
A container is a lightweight and portable unit that packages an application along with all its dependencies (libraries, configurations, runtime, etc.) to run consistently in any environment, whether on your local machine, a server, or the cloud. Unlike virtual machines, containers share the host operating system’s kernel, making them more resource-efficient. They can be thought of as a "box" containing everything needed for an application to run.
- Includes: code, libraries, configurations, environment variables
- Portable: works the same on any system that supports containers

## What are Namespaces?
Namespaces are a Linux kernel feature that provides isolation for system resources, allowing containers to operate as independent environments. They create separate views of resources like processes (PID), networking, file systems (mount), users (UID/GID), and inter-process communication (IPC). This ensures each container sees only its own resources, without interfering with other containers or the host. It’s like giving each tenant in a building their own "view" of the world. Each sees only their apartment as if it were the entire house, unaware of other tenants.
Main types:
- PID Namespace: Each process sees only its own processes
  - Inside the container: process with ID 1
  - On the host: same process has ID 15432
- Network Namespace: Isolated network
  - Each container has its own network interface, routing table, firewall
- Mount Namespace: Separate file system
  - Each container sees its own directory tree (/home, /etc, /var)
- User Namespace: Different users
  - The "root" user inside the container is not the "root" of the host

## What are Control Groups?
Control Groups (cgroups) are a Linux kernel feature that limits, prioritizes, and allocates system resources (such as CPU, memory, disk, and network) to groups of processes, like those running in containers. They ensure each container uses only its assigned resources, preventing one from monopolizing the system and ensuring predictable and equitable performance. It’s like being the manager of an apartment building who can decide how much electricity, water, and gas each apartment can use, preventing one from consuming everything and leaving others without resources.

# Installing Docker on Linux

## Introduction
Docker has become an essential tool for modern application development and deployment. This guide details the complete process for installing Docker Engine (the open-source part of Docker) and Docker Desktop on Ubuntu 24.04, including troubleshooting common issues encountered during installation.

## Prerequisites
Before starting the installation, ensure:
- Ubuntu 24.04 is installed
- Access to a terminal with administrative privileges
- Stable internet connection
- **Verify that virtualization is enabled in UEFI/BIOS**

> **Note:** Virtualization must be enabled in your device's BIOS/UEFI for Docker to function properly.

## Installing Docker Engine

### Step 1: Add the Official Docker Repository
The process follows the [official Docker documentation](https://docs.docker.com/engine/install/ubuntu/){:target="_blank"} for Ubuntu. Using `apt` is recommended as it simplifies future updates.

```bash
# Add Docker’s official GPG key
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
```

### Step 2: Install Docker Engine
```bash
# Install Docker using the apt repository
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

> **Note:** It’s normal to see a warning at the end of the installation similar to:
> ```
> N: Download is performed unsandboxed as root, as file '/home/user/Downloads/docker-desktop.deb' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)
> ```
> This message is normal and does not affect the installation.

### Step 3: Configure Permissions to Use Docker Without Sudo
```bash
# Create the docker group and add the current user
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

If permission issues arise, it may be necessary to delete Docker’s configuration folder:
```bash
sudo rm -rf ~/.docker
```

### Step 4: Configure Docker to Start Automatically
To ensure Docker starts automatically with the system:
```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

To disable this behavior later:
```bash
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

## Installing Docker Desktop (Optional)
Docker Desktop is not required to work with Docker but provides a useful graphical interface for monitoring images and containers.

### Step 1: Download Docker Desktop
Following the [official documentation](https://docs.docker.com/desktop/setup/install/linux/ubuntu/){:target="_blank"}, you can download directly from the browser or use `wget`:
```bash
# Navigate to the downloads folder
cd Downloads/

# Download using wget
wget -c https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb
```

### Step 2: Install the Package
```bash
sudo apt update
sudo apt install ./docker-desktop-amd64.deb
```

### Step 3: Troubleshoot Issues on Ubuntu 24.04
Specific issues with Docker Desktop on Ubuntu 24.04 have been reported. The solution can be found in [this Docker forum](https://forums.docker.com/t/docker-desktop-not-working-on-ubuntu-24-04/141054/6).

**Temporary Solution (must be repeated on each reboot):**
```bash
# Grant kernel permissions
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0

# Restart the service
systemctl --user restart docker-desktop
```

**Permanent Solution:**
To avoid repeating this process manually after each reboot:
```bash
# Edit the kernel configuration file
sudo nano /etc/sysctl.conf
```

Add to the end of the file:
```
kernel.apparmor_restrict_unprivileged_userns=0
```

Apply the changes:
```bash
sudo sysctl -p
```

## Verifying the Installation
To confirm Docker is working correctly, run the following commands:
```bash
# Check Docker version
docker --version

# Run the test container
docker run hello-world
```

If Docker Desktop is installed, it can be launched from the applications menu or by running:
```bash
systemctl --user start docker-desktop
```