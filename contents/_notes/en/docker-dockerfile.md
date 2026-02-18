---
title: Dockerfile basics
permalink: /notes/en/docker-dockerfile-en
key: docker-en
lang: en 
date: 2025-06-20
modify_date: 2025-06-24
---

A Dockerfile is a text file that contains a series of instructions used to build a Docker image automatically. It serves as a blueprint for creating consistent, reproducible container environments.

## What is a Dockerfile?

A Dockerfile is essentially a script that defines:
- The base operating system or runtime environment
- Application dependencies and libraries
- Configuration settings
- Files to copy into the container
- Commands to run during the build process
- How the container should behave when it starts

## Basic Structure and Syntax

Every Dockerfile follows a simple pattern: each line contains an **instruction** followed by **arguments**.

```dockerfile
INSTRUCTION arguments
```

### Example of a Simple Dockerfile

```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3
COPY app.py /app/
WORKDIR /app
CMD ["python3", "app.py"]
```

## Essential Dockerfile Instructions

### FROM - Base Image
The `FROM` instruction specifies the base image for your container. It must be the first instruction in your Dockerfile.

```dockerfile
# Using an official base image
FROM node:18-alpine

# Using a specific version
FROM python:3.11-slim

# Using latest (not recommended for production)
FROM ubuntu:latest
```

**Best Practice**: Always specify exact versions for reproducible builds.

### RUN - Execute Commands
The `RUN` instruction executes commands during the image build process. Each `RUN` instruction creates a new layer in the image.

```dockerfile
# Single command
RUN apt-get update

# Multiple commands (preferred - creates fewer layers)
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

### COPY vs ADD - Adding Files
Both instructions copy files from your local system to the container.

```dockerfile
# COPY - simple file copying (preferred)
COPY source.txt /app/destination.txt
COPY ./src /app/src

# ADD - has additional features (auto-extraction, URL support)
ADD archive.tar.gz /app/  # Automatically extracts
ADD https://example.com/file.txt /app/  # Downloads from URL
```

**Best Practice**: Use `COPY` unless you specifically need `ADD`'s extra features.

### WORKDIR - Set Working Directory
Sets the working directory for subsequent instructions.

```dockerfile
WORKDIR /app
COPY . .  # Now copies to /app
RUN npm install  # Runs in /app directory
```

### ENV - Environment Variables
Sets environment variables that persist in the running container.

```dockerfile
ENV NODE_ENV=production
ENV APP_PORT=3000
ENV DATABASE_URL=postgresql://localhost:5432/mydb

# Multiple variables in one instruction
ENV NODE_ENV=production \
    APP_PORT=3000 \
    DEBUG=false
```

### EXPOSE - Document Ports
Documents which ports the application uses (doesn't actually publish them).

```dockerfile
EXPOSE 3000
EXPOSE 8080 8443
```

### USER - Set User Context
Specifies which user should run the container (security best practice).

```dockerfile
# Create a non-root user
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup appuser

USER appuser
```

### CMD vs ENTRYPOINT - Container Startup

#### CMD - Default Command
Provides default execution command for the container. Can be overridden.

```dockerfile
# Exec form (preferred)
CMD ["python3", "app.py"]

# Shell form
CMD python3 app.py

# As parameters to ENTRYPOINT
CMD ["--config", "production.conf"]
```

#### ENTRYPOINT - Fixed Entry Point
Defines the command that always runs. Arguments can be appended.

```dockerfile
ENTRYPOINT ["python3", "app.py"]

# Combined with CMD for default arguments
ENTRYPOINT ["python3", "app.py"]
CMD ["--mode", "development"]
```

### ARG - Build Arguments
Defines variables that can be passed during build time.

```dockerfile
ARG VERSION=latest
ARG BUILD_DATE
FROM node:${VERSION}
LABEL build-date=${BUILD_DATE}
```

Build with arguments:
```bash
docker build --build-arg VERSION=18-alpine --build-arg BUILD_DATE=2025-06-20 .
```

### LABEL - Metadata
Adds metadata to images for documentation and organization.

```dockerfile
LABEL maintainer="developer@example.com"
LABEL version="1.0"
LABEL description="My application container"
```

## Best Practices
1. Use Specific Base Image Tags    
 ```dockerfile
 # Good
 FROM node:18.17-alpine
 # Avoid
 FROM node:latest
 ```

2. Minimize Layers
 ```dockerfile
 # Good - single layer
 RUN apt-get update && \
     apt-get install -y curl git && \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/*
 # Avoid - multiple layers
 RUN apt-get update
 RUN apt-get install -y curl
 RUN apt-get install -y git
 ```

3. Use .dockerignore
Create a `.dockerignore` file to exclude unnecessary files:
   ```
 node_modules
 .git
 .gitignore
 README.md
 Dockerfile
 .dockerignore
 ```

4. Order Instructions by Change Frequency
Put instructions that change frequently at the bottom to maximize cache usage.

 ```dockerfile
 FROM node:18-alpine
 # These change rarely - put first
 WORKDIR /app
 RUN apk add --no-cache git

 # These change more often - put later
 COPY package*.json ./
 RUN npm ci --only=productionas

 # This changes most frequently - put last
 COPY . .
 ```

5. Run as Non-Root User

 ```dockerfile
 RUN addgroup -g 1001 -S nodejs
 RUN adduser -S nextjs -u 1001
 USER nextjs
 ```

6. Use Multi-Stage for Smaller Images
Separate build dependencies from runtime dependencies.


## Common Dockerfile Patterns

### Node.js Application
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
USER node
CMD ["node", "server.js"]
```

### Python Application
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["python", "app.py"]
```

### Jekyll Site with Ruby Base Image
```dockerfile
FROM ruby:3.2-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    git \
    nodejs \
    npm \
    tzdata

# Set timezone
ENV TZ=America/Monterrey

# Create non-root user
RUN addgroup -g 1000 jekyll && \
    adduser -D -u 1000 -G jekyll jekyll

# Set working directory
WORKDIR /app

# Install Jekyll and Bundler
RUN gem install bundler jekyll

# Create site directory and set permissions
RUN mkdir -p /site && chown -R jekyll:jekyll /site

# Switch to non-root user
USER jekyll

# Set working directory for Jekyll sites
WORKDIR /site

# Expose Jekyll port
EXPOSE 4000

# Default command for development
CMD ["jekyll", "serve", "--host", "0.0.0.0", "--watch", "--force_polling"]
```

## Building and Running

### Build an Image
```bash
# Basic build
docker build -t myapp:latest .

# Build with custom Dockerfile name
docker build -f Dockerfile.prod -t myapp:prod .

# Build with arguments
docker build --build-arg VERSION=1.0 -t myapp:1.0 .
```

### Run the Container
```bash
# Basic run
docker run myapp:latest

# With port mapping and environment variables
docker run -p 3000:3000 -e NODE_ENV=production myapp:latest

# Interactive mode
docker run -it myapp:latest /bin/bash
```

## Troubleshooting Tips

1. Check Build Context
Ensure your build context (usually current directory) contains all necessary files.

2. Use Build Cache Effectively
Docker caches each layer. If a layer hasn't changed, it reuses the cached version.

3. Debug Failed Builds
   ```bash
   # Run intermediate container for debugging
   docker run -it <intermediate-container-id> /bin/bash
   ```

4. Check File Permissions
Files copied into containers maintain their original permissions.

## Security Considerations

1. **Use official base images** from trusted registries
2. **Keep base images updated** regularly
3. **Run as non-root user** whenever possible
4. **Don't include secrets** in the Dockerfile
5. **Use multi-stage builds** to exclude build tools from final image
6. **Scan images** for vulnerabilities regularly

Understanding these Dockerfile fundamentals will help you create efficient, secure, and maintainable container images for your applications.      
{:.info}

This article was generated with AI help. The author is not a real expert in Docker and the text could have errors.
{:.warning}