FROM ruby:3.4.4-slim

# Configure timezone
ENV TZ="America/Monterrey"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Configure user
ARG USERNAME=remoteUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}

# Configure gem installation
USER $USERNAME
WORKDIR /home/${USERNAME}
ENV GEM_HOME="/home/${USERNAME}/.gem"
ENV PATH="${GEM_HOME}/bin:$PATH"
RUN mkdir -p /home/${USERNAME}/.gem

# Set up workspace

WORKDIR /home/${USERNAME}/workspace
# Install Jekyll and Bundler
RUN gem install bundler && \
    gem install jekyll && \
    gem install jekyll-text-theme
# Expose Jekyll's default port
EXPOSE 4000

# Default command

#CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--livereload"]