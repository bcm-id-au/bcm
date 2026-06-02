# Use the official Docker-in-Docker base image
FROM docker:27.0-dind

# Install Docker Compose (V2) dependencies
RUN apk add --no-cache docker-cli-compose

# Create a working directory inside the parent container
WORKDIR /app

# Copy your docker-compose file and local project files
COPY docker-compose.yml .
# Uncomment the line below if your compose file builds local code
# COPY . .

# Expose ports that your docker-compose services use (example: 80 and 3306)
EXPOSE 80 3306

# Create an entrypoint script to start the Docker daemon and then run compose
RUN echo '#!/bin/sh' > /entrypoint.sh && \
  echo 'dockerd-entrypoint.sh &' >> /entrypoint.sh && \
  echo 'sleep 5' >> /entrypoint.sh && \
  echo 'docker compose up --build' >> /entrypoint.sh && \
  chmod +x /entrypoint.sh

# Run the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]