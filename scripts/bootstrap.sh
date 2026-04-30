#!/bin/bash
set -e

echo "=== BOOTSTRAP START ==="

# Update system
apt update -y

# Install dependencies
apt install -y docker.io git curl

# Enable docker
systemctl enable docker
systemctl start docker

# Add user to docker group (optional but useful)
usermod -aG docker $USER || true

# Create base directory
mkdir -p /srv/platform

# Clone your repo
if [ ! -d "/srv/platform/.git" ]; then
    git clone https://github.com/shazzi2k/azure-game-server-platform /srv/platform
else
    cd /srv/platform && git pull
fi

cd /srv/platform

# Ensure structure exists
mkdir -p instances

echo "=== PLATFORM READY ==="
