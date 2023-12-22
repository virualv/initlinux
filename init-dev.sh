#!/bin/bash -ex

USER_NAME=${1:-kit}
apt update
OUT_IP=$(curl -sSL 'http://ip-api.com/line/?fields=query')
IFNAME=$(ip link | grep "2: " | sed "s/ //g" | cut -d: -f2)
IP_LOCATION=$(curl -k -sSL "https://ipapi.co/${OUT_IP}/country/")
IS_OVERSEA='true'
ARCH=$(uname -m)
adduser ${USER_NAME}

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

usermod ${USER_NAME} -a -G docker,sudo,adm

# optimize system config

cat > /home/${USER_NAME}/.vimrc <<EOF
set nocompatible
set backspace=indent,eol,start
syntax on
filetype on
set t_Co=256
set tabstop=4
set expandtab
set foldenable
set autoindent
set hlsearch
set incsearch
set encoding=utf-8
EOF

cat /home/${USER_NAME}/.vimrc > /root/.vimrc

cp -i /etc/security/limits.conf /etc/security/limits.conf.bak
cat > /etc/security/limits.conf <<EOF
root            soft    nofile          65535
root            hard    nofile          65535
*               soft    nofile          65535
*               hard    nofile          65535
root            soft    nproc           unlimited
root            hard    nproc           unlimited
*               soft    nproc           65535
*               hard    nproc           65535
EOF

cp -i /etc/sysctl.conf /etc/sysctl.conf.bak
echo -e "net.ipv4.neigh.default.base_reachable_time_ms = 600000
net.ipv4.neigh.default.mcast_solicit = 20
net.ipv4.neigh.default.retrans_time_ms = 250
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.{IFNAME}.rp_filter=0
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_tw_reuse=1
" > /etc/sysctl.conf

mkdir -p /home/${USER_NAME}/.config/atuin
touch /home/${USER_NAME}/.config/atuin/config.toml 

chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/

export LANG=en_US.UTF-8
dpkg-reconfigure locales
