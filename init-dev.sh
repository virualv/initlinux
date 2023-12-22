#!/bin/bash -ex
sudo apt update
OUT_IP=$(curl -sSL 'http://ip-api.com/line/?fields=query')
IP_LOCATION=$(curl -k -sSL "https://ipapi.co/${OUT_IP}/country/")
IS_OVERSEA='true'
ARCH=$(uname -m)

if [ ${IP_LOCATION} == "CN" ];then
    IS_OVERSEA='false'
fi

if [ ${IS_OVERSEA} == 'true' ]; then
    curl -fsSL https://get.docker.com | sudo bash -s docker
    sudo su -c "curl -k -sSL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-`uname -m` -o /usr/local/bin/docker-compose && chmod a+x /usr/local/bin/docker-compose"
else
    curl -fsSL https://get.docker.com | sudo bash -s docker --mirror Aliyun
    sudo su -c "curl -k -sSL https://ghproxy.com/https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-`uname -m` -o /usr/local/bin/docker-compose && chmod a+x /usr/local/bin/docker-compose"
fi

if [ ${ARCH} == 'x86_64' ]; then
    sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git \
        libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc-s1 libc6-dev-i386 \
        flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo \
        libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler \
        g++-multilib antlr3 gperf wget curl swig rsync psmisc locales \
        iputils-ping dnsutils net-tools inetutils-tools inetutils-telnet \
        vim tmux aria2 tig htop
        # inetutils-ping
elif [ ${ARCH} == 'aarch64' ]; then
    sudo apt-get -y install build-essential asciidoc binutils bzip2 git \
        libz-dev patch python3 python2.7 unzip zlib1g-dev \
        p7zip p7zip-full libssl-dev \
        wget curl rsync psmisc locales \
        iputils-ping dnsutils net-tools inetutils-tools inetutils-telnet \
        vim tmux aria2 tig htop
        # inetutils-ping
fi 
