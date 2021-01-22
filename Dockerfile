FROM ubuntu:18.04

# general updates
RUN apt update \
    && apt install apt-utils -y

# system installs
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt install -y --no-install-recommends \
        tigervnc-standalone-server \
        tigervnc-common \
        xvfb \
        dbus-x11 \
        x11-utils \
        xubuntu-desktop

# theme installs
RUN apt install -y --no-install-recommends \
        arc-theme \
        nautilus \
        xubuntu-icon-theme \
        xfce4-whiskermenu-plugin \
        xfce4-goodies

# application installs
RUN apt install -y --no-install-recommends \
        zsh \
        firefox \
        vim \
        neofetch \
        curl \
        git \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && chsh -s $(which zsh) \
    && apt remove -y \
        curl \
        git

# clean up
RUN apt-get remove -y --auto-remove thunar \
    && apt-get purge -y --auto-remove thunar  \
    && apt autoclean -y \
    && apt autoremove -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# set install context
WORKDIR /root/

# install configuration
COPY xstartup .vnc/
COPY start-vncserver.sh .
COPY config .config
COPY terminal/.zshrc .zshrc
COPY theme/logos/ /usr/share/backgrounds/junofx/
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
