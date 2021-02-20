#!/bin/bash

# Installation
# 1- rm old files
# 2- check if curl command is exist
# 3- some Linux platforms don't have git installed, so it's well checking is git command is exist

GH_RAW_URL=https://raw.githubusercontent.com
SM_DIR=~/sm
smLocLD=/usr/local/bin
_cgit=$GH_RAW_URL/secman-team/corgit/HEAD/cgit
_verx$GH_RAW_URL/abdfnx/verx/HEAD/verx

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

curl -o $SM_DIR/cgit $_cgit
curl -o $SM_DIR/verx $_verx

# secman-sync shortcut
secman_sync_shortcut=$GH_RAW_URL/secman-team/secman/plugins/secman-sync

curl -o $smLocLD/secman-sync $secman_sync_shortcut

cd ~
sudo gem install bundler
curl $GH_RAW_URL/secman-team/secman/HEAD/Gemfile
bundle install
sudo rm -rf Gemfile*

v=$(verx secman-team/secman -l)

smUrl=https://github.com/secman-team/secman/releases/download/$v/secman-linux
sm_unUrl=$GH_RAW_URL/secman-team/secman/HEAD/packages/secman-un
sm_syUrl=$GH_RAW_URL/secman-team/secman/HEAD/api/sync/secman-sync


successInstall() {
    echo "yesss, secman was installed successfully 😎, you can type secman --help"
}

installSecman_Tools() {
    # secman
    sudo curl -o $smLocLD/secman $smUrl

    sudo chmod 755 $smLocLD/secman

    # secman-un
    sudo curl -o $smLocLD/secman-un $sm_unUrl

    sudo chmod 755 $smLocLD/secman-un

    # secman-sync
    sudo curl -o $SM_DIR/secman-sync $sm_syUrl
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
