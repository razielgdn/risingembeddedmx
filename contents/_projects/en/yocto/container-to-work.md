---
title: "Building an embedded Linux image from a container"
permalink:  /projects/en/yocto/container-to-work
key: yocto-container-en 
---

In the previous article, we discussed the Yocto Project and its capabilities for building custom Linux-based operating systems. Now, let's explore how to build an embedded Linux image using a containerized environment.
Using a container can simplify the setup process and ensure a consistent build environment across different machines. Here's a step-by-step guide to building an embedded Linux image from a container

To develop this project, I am using Docker to create the containerized environment from Ubuntu 24.04.3 LTS. You can use any Linux distribution that supports the necessary tools.

In the previous article, I forgot to mention that the host machine should have good hardware specifications, focusing on CPU, storage, and RAM, because building with Yocto can be resource-intensive.

My PC has the following specifications:
- CPU: AMD Ryzen 7 5600X 6-Core Processor
- RAM: 16 GB
- Storage: 500 GB SSD

In this project, I am using the Scarthgap version of Yocto (5.0.15) and the target board is a Raspberry Pi 4 Model B with 4GB of RAM. The build process will create a custom Linux image tailored for this specific hardware.

In a future implementation, I will try to use the AML-S905X-CC board with the same version of Yocto, but for now, I will focus on the Raspberry Pi 4 Model B. However, a path is reserved for this board in the repository and will be mentioned in the build script.

I chose containerization for this project because it allows for the reproducibility of the build environment, compatibility across different host systems, and isolation of the build process.



## Set Up a Containerized Environment
The following Dockerfile defines the environment for using Yocto to build embedded Linux images. 

This Dockerfile sets up a Debian-based environment with all the necessary dependencies for building Yocto projects. It also creates a user named "yocto" and configures the permissions for the build process. The workspace is set to `/home/yocto/workspace`.

```Dockerfile
FROM debian:12-slim
# Configure timezone in my case, you can change it to your timezone. This is important for some build processes that rely on correct time settings.
ENV TZ="America/Monterrey"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
# Yocto official documentation recommends: https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html
RUN apt-get update && apt-get install -y --no-install-recommends \  
    build-essential \
    chrpath \
    cpio \
    debianutils \
    diffstat \
    file \
    gawk \
    gcc \
    git \
    iputils-ping \
    libacl1 \
    locales \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pexpect \
    python3-pip \
    python3-subunit \
    python3-yaml \
    socat \
    sudo \
    texinfo \
    unzip \
    wget \
    zutils \
    lz4 \
    zstd \
    bzip2 \
    autoconf \
    automake \
    libtool \
    autopoint \
    m4 \
    pkgconf \
    xz-utils \    
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Yocto documentation recommends setting UTF-8 locale
RUN sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Install BitBake
RUN git clone https://git.openembedded.org/bitbake/ /opt/yocto/bitbake
ENV PATH="/opt/yocto/bitbake/bin:${PATH}"

# Configure user
ARG USERNAME=yocto
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}

# Allow yocto user to run sudo without password for volume permission fixes
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: /bin/chown" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Create volume directories and ensure proper permissions
RUN mkdir -p /home/yocto/downloads /home/yocto/sstate-cache /home/yocto/tmp \
    && chown -R ${USER_UID}:${USER_GID} /home/yocto

# Switch to the user
USER ${USERNAME}

# Set up workspace
WORKDIR /home/${USERNAME}/workspace

CMD ["/bin/bash"]
```

As you can see in the Dockerfile the dependecies are installed before start to work. This packages are:
- **build-essential**: A meta-package that includes essential tools for building software, such as compilers and libraries.
- **chrpath**: A utility for changing the rpath of ELF executables.
- **cpio**: A tool for creating and extracting cpio archives, which are used in the Yocto build process.
- **debianutils**: A collection of utilities for Debian-based systems.
- **diffstat**: A tool for generating statistics from diff output, useful for analyzing changes in source code.
- **file**: A utility for determining the type of a file, which is important for the build process to handle different file types correctly.
- **gawk**: A powerful text processing tool used in various build scripts and configuration files.
- **gcc**: The GNU Compiler Collection, essential for compiling source code during the build process.
- **git**: A version control system used for managing source code and fetching layers and dependencies from repositories.
- **iputils-ping**: A utility for testing network connectivity, which can be useful for fetching sources and dependencies during the build process.
- **libacl1**: A library for Access Control Lists, which may be required for certain file permissions during the build process.
- **locales**: A package for managing locale settings, which is important for ensuring the build environment is configured correctly for different languages and regions.
- **python3**: The Python programming language, which is used for various scripts and tools in the Yocto build process.
- **socat**: A utility for establishing bidirectional data transfers, which can be useful for debugging and testing during the build process.
- **sudo**: A tool for allowing users to run commands with elevated privileges, which is necessary for certain operations during the build process.
- **texinfo**: A documentation system used for generating manuals and documentation from source code, which can be useful for understanding and troubleshooting the build process.
- **unzip**: A utility for extracting ZIP archives, which may be used for handling source code and dependencies during the build process.
- **wget**: A command-line utility for downloading files from the web, which is essential for fetching sources and dependencies during the build process.
- **zutils, lz4, zstd, bzip2, autoconf, automake, libtool, autopoint, m4, pkgconf, xz-utils, python3-yaml, ca-certificates, curl**: These are additional tools and libraries that may be required for handling various aspects of the build process, such as compression, configuration, and fetching sources.

The use of volumes in the Docker Compose file allows you to persist the downloads, sstate cache, and temporary files across container runs, which can significantly speed up subsequent builds.
When I start to work with the container I had some issues with the size of files and permissions in the build environment the solution was creathe these volumes to solve the problems in the build process.

Bitbake is installed in the container by cloning the official Bitbake repository from the Yocto Project, it is directioned to the `/opt/yocto/bitbake` directory in the container. The PATH environment variable is updated to include the Bitbake binary directory, allowing you to run Bitbake commands from anywhere in the container.

An important tasks defined in the Dockerfile is the creation of the user "yocto" and the configuration of permissions. This is crucial for ensuring that the build process can access the necessary files and directories without running into permission issues, especially when using mounted volumes for the workspace and cache.




## Create the compose file
To build and run the container, we can use a `docker-compose.yml` file. This file defines the services, volumes, and configurations needed to run the containerized environment for Yocto.  

This `docker-compose.yml` file defines a service named `yocto` that builds the Docker image from the provided Dockerfile. It sets up the necessary volumes for the workspace, downloads, sstate cache, and temporary files. The container runs with the same user ID and group ID as the host user to avoid permission issues when accessing the mounted volumes.

```yaml
# Docker compose file for RisingEmbedded Yocto development environment
services:
  yocto:
    build: 
      context: .                                 # Build context
      args:                                      # Build arguments for user permissions
        USER_UID: ${UID:-1000}                   # User ID, default to 1000 if not set   
        USER_GID: ${GID:-1000}                   # Group ID, default to 1000 if not set
    image: yocto-builder:latest                  # Yocto builder image
    container_name: yocto-dev                    # Yocto development container 
    working_dir: /home/yocto/workspace           # Working directory inside the container
    user: "${UID:-1000}:${GID:-1000}"            # Run as host user to match permissions
    volumes:
      - .:/home/yocto/workspace:cached           # desktop workspace
      - yocto-downloads:/home/yocto/downloads    # downloads
      - yocto-sstate:/home/yocto/sstate-cache    # sstate cache
      - yocto-tmp:/home/yocto/tmp                # tmp folder where the build output is stored
    tty: true
    stdin_open: true                             # Keep the container running
    environment:
      - LANG=en_US.UTF-8
      - LC_ALL=en_US.UTF-8
      - TERM=xterm-256color                      # Enable color output in terminal   
volumes:
  yocto-downloads:                              
  yocto-sstate:
  yocto-tmp:
```

## Build and Run the Container
To build the Docker image and run the container, use the following commands in your terminal:

```bash
# Build and run the Docker image
docker-compose up --build -d

# Access the container's shell
docker-compose exec yocto bash

# To stop the container when done
docker-compose down
```
This will build the Docker image based on the provided Dockerfile, start the container in detached mode, and allow you to access the shell of the container to start working with Yocto. 

To test a first approach to the build process using a containerized environment. 
a minimal image could be built using the following command:

```bash
# Se the environment variables for the build process.
cd boards/rpi4/poky
source oe-init-build-env ../build-rpi4
## You will be moved to the build directory, now you can start the build process for a minimal image.
```
Inside the build directory you will find the `conf` folder, which contains the configuration files for the build process. The `bblayers.conf` file defines the layers that will be used in the build, while the `local.conf` file contains specific settings for the build process, such as the target machine, download directory, and other build options.


The file `bblayers.conf` contains the configuration to build a minimal image. with the following content:  

```conf
# Define the layers to be included in the build process. Each layer provides additional functionality, recipes, and configurations for the build. The layers are specified as paths relative to the workspace.
POKY_BBLAYERS_CONF_VERSION = "2"
BBPATH = "${TOPDIR}"
BBFILES ?= ""
BBLAYERS ?= " \
  /home/yocto/workspace/boards/rpi4/poky/meta \ 
  /home/yocto/workspace/boards/rpi4/poky/meta-poky \
  /home/yocto/workspace/boards/rpi4/poky/meta-yocto-bsp \  
  /home/yocto/workspace/boards/rpi4/meta-raspberrypi \  
  "
BBLAYERS_NON_REMOVABLE ?= " \
  /home/yocto/workspace/boards/rpi4/poky/meta \
  /home/yocto/workspace/boards/rpi4/poky/meta-poky \
"
```  
The BBLAYERS variable lists the layers that will be included in the build process. Each one provide specific functionality and suppor for different hardware and software, in this case the layers are:
- **meta**: The core layer of the Yocto Project, providing essential recipes and configurations.
- **meta-poky**: The reference distribution layer for the Yocto Project, providing a base set of recipes and configurations for building a Linux distribution.
- **meta-yocto-bsp**: A layer that provides Board Support Package (BSP) recipes and configurations for various hardware platforms.
- **meta-raspberrypi**: A layer that provides support for Raspberry Pi hardware, including recipes and configurations specific to Raspberry Pi devices.

The file `local.conf` contains the configuration for the build process, with the following content: 

```conf
# This is the local configuration file for the Yocto build process. It defines various settings and parameters that control how the build is performed.
# MACHINE: Specifies the target machine for which the image will be built. In this case, it's set to "raspberry
MACHINE ?= "raspberrypi4-64"
# DL_DIR: Directory where downloaded source files will be stored. This is important for caching and reusing downloads across builds.
# SSTATE_DIR: Directory for the shared state cache, which helps speed up builds by reusing previously built components.
# TMPDIR: Temporary directory for build files and output. This is where the build process will store intermediate files and results.
DL_DIR ?= "/home/yocto/downloads"
SSTATE_DIR ?= "/home/yocto/sstate-cache"
TMPDIR = "/home/yocto/tmp"
# DISTRO: Specifies the distribution to be built. In this case, it's set to "poky", which is the reference distribution provided by the Yocto Project.
DISTRO ?= "poky"
# EXTRA_IMAGE_FEATURES: Additional features to include in the built image. In this case, "debug-tweaks" is added to enable debugging features in the image.
EXTRA_IMAGE_FEATURES ?= "debug-tweaks"
# USER_CLASSES: Defines additional classes to be included in the build process. "buildstats" is added to enable build statistics collection.
USER_CLASSES ?= "buildstats"
# PATCHRESOLVE: Defines how patch conflicts are resolved during the build process. "noop" means that no automatic resolution will be attempted, and manual intervention may be required if conflicts arise.
PATCHRESOLVE = "noop"
# BB_DISKMON_DIRS: Configuration for monitoring disk usage during the build process. It defines thresholds for stopping tasks or halting the build if certain directories exceed specified sizes. This helps prevent the build from consuming too much disk space and allows for better management of resources.
BB_DISKMON_DIRS ??= "\
    STOPTASKS,${TMPDIR},1G,100K \
    STOPTASKS,${DL_DIR},1G,100K \
    STOPTASKS,${SSTATE_DIR},1G,100K \
    STOPTASKS,/tmp,100M,100K \
    HALT,${TMPDIR},100M,1K \
    HALT,${DL_DIR},100M,1K \
    HALT,${SSTATE_DIR},100M,1K \
    HALT,/tmp,10M,1K"
# Number of threads used by BitBake
BB_NUM_THREADS ?= "4" 
# Number of parallel make processes
PARALLEL_MAKE ?= "-j 4"     
```
following the procedure descripted in the previous article to build the image you can first download the necessary source files and dependencies using the following command:

```bash
bitbake -c fetchall core-image-minimal
```

Build a minimal image using the provided configuration
```bash
bitbake core-image-minimal
``` 

This last command will start the build process for a minimal Linux image using the configurations defined in the `bblayers.conf` and `local.conf` files. The build process may take some time, especially on the first run, as it will download and compile all necessary components.

The resulting image will be located inside the `/home/yocto/tmp/deploy/images/raspberrypi4-64/` directory, and you can use it to flash your Raspberry Pi 4 Model B or test it in an emulator.

## Conclusion
This  article provided a step-by-step guide on how to set up a containerized environment for building embedded Linux images using the Yocto Project. By using Docker and Docker Compose, we can create a consistent and reproducible build environment that simplifies the setup process and allows for easier management of dependencies and configurations. 

I the next article I will present to you the process of customizing a linux image with a personalized distro and there I will explain how to automate the build process using a scritot to make it easier and faster to build the image with the desired configurations and customizations. Stay tuned for more insights and tutorials on embedded Linux development with Yocto!
