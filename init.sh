#!/bin/bash -ex

cat > ~/.vimrc << EOF
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

sudo apt update
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git \
    libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev libc6-dev-i386 \
    subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo \
    libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler \
    g++-multilib antlr3 gperf wget curl swig rsync iftop inetutils-ping \
    tmux aria2 tig htop

curl -fsSL https://get.docker.com | sudo bash -s docker

sudo su -c "curl -k -sSL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-`uname -m` -o /usr/local/bin/docker-compose && chmod a+x /usr/local/bin/docker-compose"

sudo su -c "cat > /etc/security/limits.conf << EOF
root            soft    nofile          65535
root            hard    nofile          65535
*               soft    nofile          65535
*               hard    nofile          65535
root            soft    nproc           unlimited
root            hard    nproc           unlimited
*               soft    nproc           65535
*               hard    nproc           65535
EOF"

sudo su -c 'cp -i /etc/sysctl.conf /etc/sysctl.conf.bak'
sudo su -c 'echo -e "net.ipv4.neigh.default.base_reachable_time_ms = 600000
net.ipv4.neigh.default.mcast_solicit = 20
net.ipv4.neigh.default.retrans_time_ms = 250
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.$(ip link | grep "2: " | sed "s/ //g" | cut -d: -f2).rp_filter=0
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_tw_recycle=1" > /etc/sysctl.conf'

sudo su -c "
cat > /root/.vimrc << EOF
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
"
