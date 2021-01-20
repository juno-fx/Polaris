FROM ubuntu:18.04

RUN apt update -q

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y --no-install-recommends \
        tightvncserver \
        xvfb \
        dbus-x11 \
        x11-utils \
        xfonts-base \
        xfonts-75dpi \
        xfonts-100dpi \
        xubuntu-desktop \
        xubuntu-icon-theme \
        xfce4-goodies

RUN apt install -y --no-install-recommends \
        zsh

RUN apt install -y --no-install-recommends \
        arc-theme

RUN apt autoclean -y \
    && apt autoremove -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/

RUN mkdir -p /root/.vnc

COPY xstartup /root/.vnc/
COPY start-vncserver.sh /root/
COPY config /root/.config

RUN chmod a+x /root/.vnc/xstartup \
    && touch /root/.Xauthority \
    && chmod a+x /root/start-vncserver.sh

EXPOSE 5901
ENV USER root
CMD [ "/root/start-vncserver.sh" ]