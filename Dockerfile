FROM ubuntu:latest
#FROM fullaxx/ubuntu-desktop:focal
#MAINTAINER SHAKUGAN <shakugan@disbox.net>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get install -y tzdata locales locales-all man-db openssh-client vim wget zip unzip iputils-ping
ENV LANG="en_US.UTF-8"
ENV LANGUAGE=en_US
RUN locale-gen en_US.UTF-8 && locale-gen en_US
RUN echo "America/New_York" > /etc/timezone && \
    apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG

RUN apt-get update -y && apt-get install -y software-properties-common python3 sudo
RUN add-apt-repository universe
RUN apt-get update -y && apt-get install -y vim xterm pulseaudio cups curl libgconf* iputils-ping libnss3* libxss1 wget xdg-utils libpango1.0-0 fonts-liberation

ENV NOMACHINE_PACKAGE_NAME nomachine_8.4.2_1_amd64.deb
ENV NOMACHINE_BUILD 8.4
ENV NOMACHINE_MD5 35d9c2af67707a9e7cd764e3aeda4624

# Install the mate-desktop-enviroment version you would like to have
RUN apt-get update -y && \
    apt-get install -y mate-desktop-environment-extras

RUN apt-get update -y && apt-get install -y firefox libreoffice htop nano git vim wget curl xz-utils openssh-server build-essential net-tools libevent*


# sshd
RUN mkdir -p /var/run/sshd
RUN sed -i 's\#PermitRootLogin prohibit-password\PermitRootLogin yes\ ' /etc/ssh/sshd_config
RUN sed -i 's\#PubkeyAuthentication yes\PubkeyAuthentication yes\ ' /etc/ssh/sshd_config
RUN apt clean

# VSCODETOr
RUN wget https://github.com/coder/code-server/releases/download/v4.10.0/code-server_4.10.0_amd64.deb
RUN dpkg -i code-server_4.10.0_amd64.deb
RUN wget -O - https://deb.nodesource.com/setup_18.x | bash && apt-get -y install nodejs && npm i -g updates
RUN wget https://deb.torproject.org/torproject.org/pool/main/t/tor/tor_0.4.7.13-1~jammy+1_amd64.deb
RUN dpkg -i tor_0.4.7.13-1~jammy+1_amd64.deb
RUN sed -i 's\#SocksPort 9050\SocksPort 9050\ ' /etc/tor/torrc
RUN sed -i 's\#ControlPort 9051\ControlPort 9051\ ' /etc/tor/torrc
RUN sed -i 's\#HashedControlPassword\HashedControlPassword\ ' /etc/tor/torrc
RUN sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' /etc/tor/torrc
RUN sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir /var/lib/tor/hidden_service/\ ' /etc/tor/torrc
RUN sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 8888 127.0.0.1:8888\ ' /etc/tor/torrc
RUN sed -i '73s\#HiddenServicePort 22 127.0.0.1:22\HiddenServicePort 22 127.0.0.1:22\ ' /etc/tor/torrc
RUN sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' /etc/tor/torrc
RUN sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' /etc/tor/torrc
RUN sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' /etc/tor/torrc
RUN sed -i '77 i HiddenServicePort 8000 127.0.0.1:9000' /etc/tor/torrc
RUN rm -rf code-server_4.10.0_amd64.deb tor_0.4.7.13-1~jammy+1_amd64.deb
RUN apt clean

# Install nomachine, change password and username to whatever you want here
RUN curl -fSL "http://download.nomachine.com/download/${NOMACHINE_BUILD}/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - && dpkg -i nomachine.deb && sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg


ADD nxserver.sh /
EXPOSE 4000
ENTRYPOINT ["/nxserver.sh"]
