FROM ubuntu:20.04

RUN apt-get update && apt-get upgrade -y 
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get install -y tzdata locales 
RUN locale-gen en_US.UTF-8
RUN apt install -y wget curl nano git xz-utils openssh-server build-essential net-tools dialog apt-utils vim xterm pulseaudio cups libevent* ; \
    apt --fix-broken install && apt clean;

RUN apt-get -y dist-upgrade 
RUN apt-get install -y  mate-desktop-environment-core mate-desktop-environment mate-indicator-applet ubuntu-mate-themes ubuntu-mate-wallpapers firefox nano sudo

RUN apt-get install -y wget curl

# sshd
RUN sudo mkdir -p /var/run/sshd
RUN sudo sed -i 's\#PermitRootLogin prohibit-password\PermitRootLogin yes\ ' /etc/ssh/sshd_config
RUN sudo sed -i 's\#PubkeyAuthentication yes\PubkeyAuthentication yes\ ' /etc/ssh/sshd_config
RUN sudo apt clean

# VSCODETOr
RUN sudo wget https://github.com/coder/code-server/releases/download/v4.10.0/code-server_4.10.0_amd64.deb
RUN sudo dpkg -i code-server_4.10.0_amd64.deb
RUN sudo wget -O - https://deb.nodesource.com/setup_18.x | sudo -E bash && sudo apt-get -y install nodejs && sudo npm i -g updates
RUN sudo wget https://deb.torproject.org/torproject.org/pool/main/t/tor/tor_0.4.7.13-1~jammy+1_amd64.deb
RUN sudo dpkg -i tor_0.4.7.13-1~jammy+1_amd64.deb
RUN sudo sed -i 's\#SocksPort 9050\SocksPort 9050\ ' /etc/tor/torrc
RUN sudo sed -i 's\#ControlPort 9051\ControlPort 9051\ ' /etc/tor/torrc
RUN sudo sed -i 's\#HashedControlPassword\HashedControlPassword\ ' /etc/tor/torrc
RUN sudo sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' /etc/tor/torrc
RUN sudo sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir /var/lib/tor/hidden_service/\ ' /etc/tor/torrc
RUN sudo sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 12345 127.0.0.1:12345\ ' /etc/tor/torrc
RUN sudo sed -i '73s\#HiddenServicePort 22 127.0.0.1:22\HiddenServicePort 22 127.0.0.1:22\ ' /etc/tor/torrc
RUN sudo sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' /etc/tor/torrc
RUN sudo sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' /etc/tor/torrc
RUN sudo sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' /etc/tor/torrc
RUN sudo sed -i '77 i HiddenServicePort 9000 127.0.0.1:9000' /etc/tor/torrc
RUN sudo sed -i '78 i HiddenServicePort 6900 127.0.0.1:6900' /etc/tor/torrc
RUN sudo rm -rf code-server_4.10.0_amd64.deb tor_0.4.7.13-1~jammy+1_amd64.deb
RUN sudo apt clean


# CONFIG

RUN sudo touch VSCODETOr.sh
RUN echo "code-server --bind-addr 127.0.0.1:12345 >> vscode.log &" | sudo tee --append VSCODETOr.sh
RUN echo "tor > tor.log &" | sudo tee --append VSCODETOr.sh
RUN echo 'echo "######### wait Tor #########"' | sudo tee --append VSCODETOr.sh
RUN echo 'sleep 1m' | sudo tee --append VSCODETOr.sh
RUN echo "cat /var/lib/tor/hidden_service/hostname" | sudo tee --append VSCODETOr.sh
RUN echo "sed -n '3'p ~/.config/code-server/config.yaml" | sudo tee --append VSCODETOr.sh
RUN echo 'echo "######### OK #########"' | sudo tee --append VSCODETOr.sh
RUN echo 'sleep 90d' | sudo tee --append VSCODETOr.sh


RUN https://download.nomachine.com/download/8.4/Linux/nomachine_8.4.2_1_amd64.deb && dpkg -i nomachine_8.4.2_1_amd64.deb

RUN apt-get clean
RUN apt-get autoclean
EXPOSE 4000
VOLUME [ "/home/nomachine" ]
ADD nxserver.sh /
RUN chmod +x /nxserver.sh
ENTRYPOINT ["/nxserver.sh"]
