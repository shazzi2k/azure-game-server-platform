FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y \
    wget \
    tar \
    curl \
    libc6:i386 \
    libstdc++6:i386 && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /steamcmd && \
    cd /steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xzf steamcmd_linux.tar.gz

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]