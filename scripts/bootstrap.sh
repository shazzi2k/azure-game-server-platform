#!/bin/bash
set -e

echo "=== BOOTSTRAP START ==="

# Update system
apt update -y

# Install dependencies
apt install -y docker.io git curl
apt install -y python3 python3-pip

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

# Install agent requirements
if [ -f "/srv/platform/agent/requirements.txt" ]; then
    pip3 install -r /srv/platform/agent/requirements.txt
fi

echo "=== PLATFORM READY ==="
