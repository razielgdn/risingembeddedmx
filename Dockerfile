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

# Set up workspace
WORKDIR /home/${USERNAME}/workspace

# Install Jekyll and Bundler
#base64-0.3.0, csv-3.3.5, json-2.12.2, sass-embedded-1.77.5-x86_64-linux-gnu, rexml-3.4.1, benchmark-0.4.1, bigdecimal-3.2.2, drb-2.2.3, logger-1.7.0, minitest-5.25.5
RUN gem install bundler && \
    gem install jekyll && \
    gem install jekyll-text-theme && \
    gem install rake && \ 

# Switch to the user
USER ${USERNAME}

# Expose Jekyll's default port
EXPOSE 4000

# Default command
#CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--livereload"]