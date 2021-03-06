#!/bin/bash

# Installation
# 1- rm old files
# 2- check if curl command is exist

GH_RAW_URL=https://raw.githubusercontent.com
SM_DIR=~/sm
smLocLD=/usr/bin

rmOldFiles() {
    if [ -f $smLocLD/secman ]; then
        rm -rf $smLocLD/secman*
        rm -rf $smLocLD/verx*
        rm -rf $smLocLD/cgit*

        if [ -d $SM_DIR ]; then
            rm -rf $SM_DIR
        fi
    fi
}

if [ -x "$(command -v wget)" ]; then
    # install deps
    echo "installing deps..."

    curl -fsSL https://raw.githubusercontent.com/secman-team/corgit/main/setup | bash
    curl -fsSL https://raw.githubusercontent.com/abdfnx/verx/HEAD/install.sh | bash

    gem install colorize
    gem install optparse

    v=$(verx secman-team/secman -l)

    git clone https://github.com/secman-team/sm $SM_DIR

    smUrl=https://github.com/secman-team/secman/releases/download/$v/secman-win
    sm_unUrl=$GH_RAW_URL/secman-team/secman/HEAD/packages/secman-un-win
    sm_syUrl=$GH_RAW_URL/secman-team/secman/HEAD/api/sync/secman-sync

    successInstall() {
        echo "yesss, secman was installed successfully 😎, you can type secman --help"
    }

    installSecman_Tools() {
        # secman
        wget -O $smLocLD/secman $smUrl

        # secman-un
        wget -O $smLocLD/secman-un $sm_unUrl

        # secman-sync
        wget -P $smLocLD $sm_syUrl
    }

    mainCheck() {
        if [ -x "$(command -v git)" ]; then
            if [ -x "$(command -v wget)" ]; then
                installSecman_Tools
            else
                echo "You must install wget"
            fi
        else
            echo "You should install git"
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
else
    echo "You must install wget"
fi
