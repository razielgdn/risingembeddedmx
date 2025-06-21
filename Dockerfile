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