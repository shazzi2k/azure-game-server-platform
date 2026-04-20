FROM ubuntu:22.04

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y \
    wget \
    ca-certificates \
    lib32gcc-s1 \
    lib32stdc++6 \
    libcurl4 \
    libcurl4:i386 \
    libsdl2-2.0-0 \
    libsdl2-2.0-0:i386 \
    libopenal1 \
    libopenal1:i386 \
    libgl1 \
    libgl1:i386 && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Locale
RUN apt update && apt install -y locales && \
    locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# SteamCMD
RUN mkdir -p /steamcmd && \
    cd /steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Install script
COPY install.txt /install.txt

# Install game
RUN mkdir -p /pz && \
    /steamcmd/steamcmd.sh +runscript /install.txt

# 🔥 ADD THIS SECTION
COPY start-server.sh /start-server.sh
RUN chmod +x /start-server.sh

WORKDIR /pz

CMD ["/start-server.sh"]
