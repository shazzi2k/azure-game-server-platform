#!/bin/bash
set -e

echo "Starting Valheim server..."

mkdir -p /home/steam/valheim

# Install if missing
if [ ! -f /home/steam/valheim/valheim_server.x86_64 ]; then
    echo "Installing Valheim server..."
    /steamcmd/steamcmd.sh \
        +force_install_dir /home/steam/valheim \
        +login anonymous \
        +app_update 896660 validate \
        +quit
fi

cd /home/steam/valheim

exec ./valheim_server.x86_64 \
    -name "${SERVER_NAME:-ValheimServer}" \
    -port 2456 \
    -world "${WORLD_NAME:-Dedicated}" \
    -password "${SERVER_PASSWORD:-changeme}" \
    -public "${SERVER_PUBLIC:-1}"
