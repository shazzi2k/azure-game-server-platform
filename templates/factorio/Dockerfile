FROM ubuntu:22.04

RUN apt update && \
    apt install -y wget tar curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /steamcmd && \
    cd /steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xzf steamcmd_linux.tar.gz

COPY start-server.sh /start-server.sh
RUN chmod +x /start-server.sh

CMD ["/start-server.sh"]