#!/bin/bash -ex
sudo apt update
sudo apt-get -y install build-essential asciidoc binutils bzip2 git \
    libz-dev patch python3 python2.7 unzip zlib1g-dev \
    git-core gcc-multilib p7zip p7zip-full libssl-dev \
    wget curl rsync \
    tmux aria2 tig htop

curl -fsSL https://get.docker.com | sudo bash -s docker
