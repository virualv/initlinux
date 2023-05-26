#!/bin/bash -ex
sudo apt update
OUT_IP=$(curl -sSL 'http://ip-api.com/line/?fields=query')
IP_LOCATION=$(curl -k -sSL "https://ipapi.co/${OUT_IP}/country/")
IS_OVERSEA='false'
ARCH=$(uname -m)

if [ ${IP_LOCATION} == "CN" ];then
    IS_OVERSEA='true'
fi

if [ ${ARCH} == 'x86_64' ]; then
    sudo apt-get -y install asciidoc bzip2 git patch python3 python2.7 unzip \
        p7zip p7zip-full wget curl rsync psmisc locales \
        iputils-ping dnsutils net-tools inetutils-tools inetutils-telnet \
        vim tmux aria2 tig htop
        # inetutils-ping
elif [ ${ARCH} == 'aarch64' ]; then
    sudo apt-get -y install asciidoc bzip2 git patch python3 python2.7 unzip \
        p7zip p7zip-full libssl-dev wget curl rsync psmisc locales \
        iputils-ping dnsutils net-tools inetutils-tools inetutils-telnet \
        vim tmux aria2 tig htop
fi 

sudo -v ; curl https://rclone.org/install.sh | sudo bash
