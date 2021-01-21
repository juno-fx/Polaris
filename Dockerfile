FROM ubuntu:18.04

# general updates
RUN apt update -q \
    && apt upgrade -y \
    && apt install -y apt-utils

# system installs
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y --no-install-recommends \
        tigervnc-standalone-server \
        tigervnc-common \
        xvfb \
        dbus-x11 \
        x11-utils \
        xfonts-base \
        xubuntu-desktop \
        xubuntu-icon-theme \
        xfce4-whiskermenu-plugin \
        xfce4-goodies

# theme installs
RUN apt install -y --no-install-recommends \
        arc-theme \
        nautilus \
        menulibre \
        curl \
        git \
    && mkdir -p /root/.config \
    && xdg-mime default nautilus.desktop inode/directory application

# application imstalls
RUN apt install -y --no-install-recommends \
        zsh \
        firefox \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && chsh -s $(which zsh)

# clean up
RUN apt autoclean -y \
    && apt autoremove -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# set install context
WORKDIR /root/

# install configuration
COPY xstartup .vnc/
COPY start-vncserver.sh .
COPY config .config
ADD theme/Breeze-Blur-Glassy-Dark.tar.gz .icons/

# set up configuration
RUN chmod a+x .vnc/xstartup \
    && touch .Xauthority \
    && chmod a+x start-vncserver.sh

# set handoff context
WORKDIR /

# target port and launch
EXPOSE 5901
CMD [ "/root/start-vncserver.sh" ]
