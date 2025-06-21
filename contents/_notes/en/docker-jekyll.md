---
title: Dockerfile, jekyll workspace
permalink: /notes/en/docker-jekyll-en
key: docker-en
modify_date: 2025-06-19
date: 2025-06-19  
lang: en 
---

Docker is used to compile this site locally and generate a preview before releasing a post or article.
To use it with VS Code, you should add the following extensions:
- [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers){:target="_blank"}   
- [Container Tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers){:target="_blank"}
## Create the container 
Once installed, create a Dockerfile to run the site in a container.
The code is as follows:

```dockerfile
FROM ubuntu:22.04
# Configure timezone (prevents interactive prompts)
ENV TZ="America/Monterrey"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    apt-utils \
    sudo \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure user
ARG USERNAME=remoteUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Configure Ruby with rbenv
ENV RBENV_ROOT /home/$USERNAME/.rbenv
ENV RUBY_VERSION 3.4.4
ENV PATH ${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH

# Install rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} \
    && git clone https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build \
    && echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install Ruby
RUN rbenv install ${RUBY_VERSION} \
    && rbenv global ${RUBY_VERSION} \
    && rbenv rehash

# Install Jekyll and Bundler
RUN gem install bundler jekyll \
    && rbenv rehash

# Set up workspace directory for projects
WORKDIR /workspace

# Expose Jekyll's default port
EXPOSE 4000

# Default command
CMD ["bash"]
```

## Building and Running the Container

To build the Docker image:

```sh
docker build -t jekyll-site .
```

To run the container and mount your project directory:

```sh
docker run -it -p 4000:4000 -v $(pwd):/workspace jekyll-site
```

```dockerfile
# Use an official ARM GCC toolchain image as base
FROM ubuntu:22.04
# Configure timezone (prevents interactive prompts)
ENV TZ="America/Monterrey"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \            
    openocd \
    make \    
    && rm -rf /var/lib/apt/lists/*

# Configure user
ARG USERNAME=remoteUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]

```


## Using VSCode
In Visual Studio Code, you can use the container directly from the graphical interface. Once the extensions are installed and the Dockerfile is ready, follow these steps to run your environment from a container:

1. Press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> to open the command palette and select **Open Folder in Container**.  
   ![Open folder](/assets/images/docker/image01.png)
2. Select your project folder and click **Open**.
3. When prompted, select **Add configuration to user data folder** to work locally.
4. Choose **From Dockerfile** as the configuration source.
5. Click **OK** in the remaining tabs without changing any arguments.
6. Wait until the container is created and your environment is ready.
   
