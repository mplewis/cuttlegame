FROM ubuntu:20.04

RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
    software-properties-common

RUN add-apt-repository ppa:libretro/testing
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    curl \
    dbus-x11 \
    libgl1-mesa-dri \
    libretro-* \
    mesa-utils \
    net-tools \
    novnc \
    pulseaudio \
    python3-dev \
    python3-pip \
    retroarch \
    software-properties-common \
    sudo \
    supervisor \
    x11-utils \
    x11vnc \
    xvfb \
    xz-utils

RUN pip3 install websockify

ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

RUN ln -s /usr/share/novnc/vnc_auto.html /usr/share/novnc/index.html

COPY rootfs /

EXPOSE 80
CMD [ "start.sh" ]
