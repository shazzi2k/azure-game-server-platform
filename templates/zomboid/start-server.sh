#!/bin/bash
set -e

echo "Starting Project Zomboid server..."

mkdir -p /pz

# Install if missing
if [ ! -f /pz/start-server.sh ]; then
    echo "Installing Zomboid server..."
    /steamcmd/steamcmd.sh \
        +login anonymous \
        +force_install_dir /pz \
        +app_update 380870 validate \
        +quit
fi

cd /pz

export JAVA_OPTS="-Xms2g -Xmx4g"

exec ./start-server.sh \
    -servername "${SERVER_NAME:-default}" \
    -adminpassword "${ADMIN_PASSWORD:-changeme}"
