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
The following Dockerfile defines the environment for using Yocto to build embedded Linux images. It includes all the necessary dependencies and tools required for the build process.

This Dockerfile sets up a Debian-based environment with all the necessary dependencies for building Yocto projects. It also creates a user named "yocto" and configures the necessary permissions for the build process. The workspace is set to `/home/yocto/workspace`, where you can clone your Yocto project and start building your embedded Linux image.

The use of volumes in the Docker Compose file allows you to persist the downloads, sstate cache, and temporary files across container runs, which can significantly speed up subsequent builds.

I got some issues with the compilation process related to build in the workspace folder, the solution to this was the use of volumes in Docker. 

```Dockerfile
# This Dockerfile sets up a Debian-based environment for building Yocto projects for Raspberry Pi on ARM64 architecture.

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
    python3-yaml \
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


