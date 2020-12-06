FROM ubuntu:20.04 as system

RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
    software-properties-common

RUN add-apt-repository ppa:libretro/testing
RUN apt-get update
RUN apt-get install -y \
    apache2-utils \
    build-essential \
    curl \
    dbus-x11 \
    libgl1-mesa-dri \
    libretro-* \
    mesa-utils \
    net-tools \
    nginx \
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

# tini to fix subreap
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# python library
COPY rootfs/usr/local/lib/web/backend/requirements.txt /tmp/
RUN apt-get update \
    && dpkg-query -W -f='${Package}\n' > /tmp/a.txt \
    && pip3 install setuptools wheel && pip3 install -r /tmp/requirements.txt \
    && ln -s /usr/bin/python3 /usr/local/bin/python \
    && rm -rf /tmp/a.txt /tmp/b.txt

RUN apt-get install -y novnc

########################################

FROM system

COPY rootfs /
RUN ln -s /usr/share/novnc/vnc_auto.html /usr/share/novnc/index.html

EXPOSE 80
CMD [ "start.sh" ]
