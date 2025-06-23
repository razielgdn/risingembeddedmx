FROM ubuntu:22.04

# Configure timezone (prevents interactive prompts)
# Set the timezone to America/Monterrey
ENV TZ="America/Monterrey"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install system dependencies and tools
# This includes essential build tools and libraries for Ruby and Jekyll
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
# This section creates a non-root user for running applications.
# It sets the username, user ID, and group ID.
# The user is granted sudo privileges without a password prompt.
# This is important for security and best practices in containerized environments.
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
# This section sets up rbenv for Ruby version management.
# It defines the root directory for rbenv and the Ruby version to be installed.
ENV RBENV_ROOT="/home/$USERNAME/.rbenv"
ENV RUBY_VERSION="3.4.4"
ENV PATH="${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH"

# Install rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} \
    && git clone https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build \
    && echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Install Ruby
# This section installs the specified Ruby version using rbenv.
RUN rbenv install ${RUBY_VERSION} \
    && rbenv global ${RUBY_VERSION} \
    && rbenv rehash

# Install Jekyll and Bundler
# This section installs Jekyll and Bundler using the RubyGems package manager.
RUN gem install bundler jekyll \
    && rbenv rehash
# Set up workspace directory for projects
WORKDIR /workspace

# Expose Jekyll's default port
# This allows external access to the Jekyll server when running in the container.
EXPOSE 4000 

# This sets the default command to be executed when the container starts.
CMD ["bash"]
