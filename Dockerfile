FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
    build-essential \
    dbus-x11 \
    libgl1-mesa-dri \
    mesa-utils \
    net-tools \
    novnc \
    pulseaudio \
    python3-dev \
    python3-pip \
    software-properties-common \
    x11-utils \
    x11vnc \
    xvfb \
    xz-utils

RUN pip3 install websockify

# This makes the build take a bit more time, but libretro installs are liable to fail
RUN add-apt-repository ppa:libretro/testing
RUN apt-get update
RUN apt-get install -y \
    libretro-* \
    retroarch

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

RUN ln -s /usr/share/novnc/vnc_auto.html /usr/share/novnc/index.html
COPY rootfs /

EXPOSE 80
ENTRYPOINT [ "/init" ]
