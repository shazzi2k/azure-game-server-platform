#!/bin/bash
set -e

echo "=== BOOTSTRAP START ==="

# Update system
apt update -y

# Install dependencies
apt install -y docker.io git curl python3 python3-pip python3-venv
apt install -y docker-compose-plugin
# Enable docker
systemctl enable docker
systemctl start docker

# Create base directory
mkdir -p /srv/platform

# Clone repo
if [ ! -d "/srv/platform/.git" ]; then
    git clone https://github.com/shazzi2k/azure-game-server-platform /srv/platform
else
    cd /srv/platform && git pull
fi

# Ownership
chown -R shazadmin1:shazadmin1 /srv/platform

# Create venv
python3 -m venv /srv/platform/agent/venv

# Install requirements into venv
/srv/platform/agent/venv/bin/pip install --upgrade pip
/srv/platform/agent/venv/bin/pip install -r /srv/platform/agent/requirements.txt

# Create service
cat > /etc/systemd/system/shazcloud-agent.service <<EOF
[Unit]
Description=ShazCloud Agent
After=network.target

[Service]
WorkingDirectory=/srv/platform/agent
ExecStart=/srv/platform/agent/venv/bin/python /srv/platform/agent/app.py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Enable service
systemctl daemon-reload
systemctl enable shazcloud-agent
systemctl restart shazcloud-agent

echo "=== PLATFORM READY ==="