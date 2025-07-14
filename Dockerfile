FROM ruby:3.4.4-slim

# Configure timezone
ENV TZ="America/Monterrey"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    g++ \
    libc-dev \
    make \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install gems
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock jekyll-text-theme.gemspec ./
RUN bundle install 

# Configure user
ARG USERNAME=remoteUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}

# Switch to the user
USER ${USERNAME}

# Set up workspace
WORKDIR /home/${USERNAME}/workspace

# Expose Jekyll's default port
EXPOSE 4000

# Default command
# CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--livereload"]