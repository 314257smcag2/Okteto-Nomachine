#!/bin/sh
code-server --bind-addr 127.0.0.1:8888 >> vscode.log &
tor >> tor.log &
echo "######### wait Tor #########"
echo 'sleep 1m' >>/VSCODETOr.sh
cat /var/lib/tor/hidden_service/hostname
sed -n '3'p ~/.config/code-server/config.yaml
echo "######### OK #########"
groupadd -r $USER -g 433 \
&& useradd -u 431 -r -g $USER -d /home/$USER -s /bin/bash -c "$USER" $USER \
&& adduser $USER sudo \
&& mkdir /home/$USER \
&& chown -R $USER:$USER /home/$USER \
&& echo $USER':'$PASSWORD | chpasswd
/etc/NX/nxserver --startup
tail -f /usr/NX/var/log/nxserver.log
