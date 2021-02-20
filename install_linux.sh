#!/bin/bash

# Installation
# 1- rm old files
# 2- check if curl command is exist
# 3- some Linux platforms don't have git installed, so it's well checking is git command is exist

GH_RAW_URL=https://raw.githubusercontent.com
SM_DIR=~/sm
smLocLD=/usr/local/bin

rmOldFiles() {
    if [ -f $smLocLD/secman ]; then
        sudo rm -rf $smLocLD/secman*
        sudo rm -rf $smLocLD/verx*
        sudo rm -rf $smLocLD/cgit*

        if [ -d $SM_DIR ]; then
            rm -rf ~/sm
        fi
    fi
}

# install deps
echo "installing deps..."

git clone https://github.com/secman-team/sm ~/sm

curl -fsSL https://raw.githubusercontent.com/secman-team/corgit/main/setup | bash
curl -fsSL https://raw.githubusercontent.com/abdfnx/verx/HEAD/install.sh | bash

# secman-sync shortcut
secman_sync_shortcut=$GH_RAW_URL/secman-team/secman/HEAD/plugins/secman-sync

sudo wget -P $smLocLD $secman_sync_shortcut

cd ~
wget $GH_RAW_URL/secman-team/secman/HEAD/Gemfile
sudo gem install bundler
bundle install
sudo rm -rf Gemfile*

v=$(bash $SM_DIR/verx secman-team/secman -l)

smUrl=https://github.com/secman-team/secman/releases/download/$v/secman-linux
sm_unUrl=$GH_RAW_URL/secman-team/secman/HEAD/packages/secman-un
sm_syUrl=$GH_RAW_URL/secman-team/secman/HEAD/api/sync/secman-sync

successInstall() {
    echo "yesss, secman was installed successfully 😎, you can type secman --help"
}

installSecman_Tools() {
    # secman
    sudo wget -O $smLocLD/secman $smUrl

    sudo chmod 755 $smLocLD/secman

    # secman-un
    sudo wget -P $smLocLD $sm_unUrl

    sudo chmod 755 $smLocLD/secman-un

    # secman-sync
    sudo wget -P $SM_DIR $sm_syUrl
    sudo chmod 755 $SM_DIR/secman-sync
}

mainCheck() {
    if [ -x "$(command -v sudo)" ]; then
        sudo apt install git
        installSecman_Tools
    else
        apt install git
        installSecman_Tools
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
