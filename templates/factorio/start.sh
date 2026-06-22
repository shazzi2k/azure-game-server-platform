#!/bin/bash
set -e

echo "Starting Factorio..."

mkdir -p /factorio

if [ ! -f /factorio/bin/x64/factorio ]; then

    echo "Installing Factorio..."

    /steamcmd/steamcmd.sh \
        +force_install_dir /factorio \
        +login anonymous \
        +app_update 427520 validate \
        +quit
fi

cd /factorio

exec ./bin/x64/factorio \
    --start-server-load-latest