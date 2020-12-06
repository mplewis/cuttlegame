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

FROM node:15.3 as builder

COPY web /src/web
WORKDIR /src/web
RUN yarn install
RUN yarn build

RUN sed -i 's#app/locale/#novnc/app/locale/#' /src/web/dist/static/novnc/app/ui.js

########################################

FROM system

COPY --from=builder /src/web/dist/ /usr/local/lib/web/frontend/
COPY rootfs /
RUN ln -sf /usr/local/lib/web/frontend/static/websockify /usr/local/lib/web/frontend/static/novnc/utils/websockify && \
    chmod +x /usr/local/lib/web/frontend/static/websockify/run
RUN ln -s /usr/share/novnc/vnc_auto.html /usr/share/novnc/index.html

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
CMD [ "start.sh" ]
