#!/bin/bash

# Installation
# 1- rm old files
# 2- check if curl command is exist
# 3- some Linux platforms don't have git installed, so it's well checking is git command is exist

GH_RAW_URL=https://raw.githubusercontent.com
SM_DIR=/home/sm
smLocLD=/usr/local/bin

rmOldFiles() {
    if [ -f $smLocLD/secman ]; then
        sudo rm -rf $smLocLD/secman*
        sudo rm -rf $smLocLD/verx*
        sudo rm -rf $smLocLD/cgit*

        if [ -d $SM_DIR ]; then
            sudo rm -rf $SM_DIR
        fi
    fi
}

# install deps
echo "installing deps..."

curl -fsSL https://raw.githubusercontent.com/secman-team/corgit/main/setup | bash
curl -fsSL https://raw.githubusercontent.com/abdfnx/verx/HEAD/install.sh | bash

cd ~
wget $GH_RAW_URL/secman-team/secman/HEAD/Gemfile
sudo gem install bundler
bundle install
sudo rm -rf Gemfile*

v=$(verx secman-team/secman -l)

git clone https://github.com/secman-team/sm ~/sm
sudo mv ~/sm /home

smUrl=https://github.com/secman-team/secman/releases/download/$v/secman_linux_${v}_x64.zip
sm_unUrl=$GH_RAW_URL/secman-team/secman/HEAD/packages/secman-un
sm_syUrl=$GH_RAW_URL/secman-team/secman/HEAD/api/sync/secman-sync

successInstall() {
    echo "yesss, secman was installed successfully 😎, you can type secman --help"
}

installSecman_Tools() {
    wget $smUrl
    sudo chmod 755 secman_linux_${v}_x64.zip
    unzip secman_linux_${v}_x64.zip

    # secman
    sudo mv secman_bin/secman $smLocLD
    sudo mv secman_share/man/man1/secman*.1.gz /usr/share/man/man1

    # secman-un
    sudo wget -P $smLocLD $sm_unUrl

    # secman-sync
    sudo wget -P $smLocLD $sm_syUrl

    sudo chmod 755 $smLocLD/secman*

    rm secman_bin secman_share LICENSE
}

mainCheck() {
    if [ -x "$(command -v git)" ]; then
        installSecman_Tools
    else
        echo "You Should Install Git"
    fi
}

if [ -x "$(command -v curl)" ]; then
    rmOldFiles
    mainCheck

    if [ -x "$(command -v secman)" ]; then
        successInstall
    else
        echo "Download failed 😔"
    fi

else
    echo "You should install curl"
    exit 0
fi
