FROM x11vnc/desktop:latest

RUN add-apt-repository ppa:libretro/stable
RUN apt-get update
RUN apt-get install -y retroarch libretro-vbam
RUN apt-get install -y pulseaudio

COPY pokemon_ruby.gba /tmp/

COPY autostart /home/ubuntu/.config/lxsession/LXDE/
COPY xorg.conf /etc/X11/xorg.conf
COPY startvnc.sh start.sh /usr/local/bin/
COPY retroarch.cfg /home/ubuntu/.config/retroarch/

CMD [ "start.sh" ]
