#!/bin/bash

# Installation
# 1- check if curl command is exist
# 2- check if wget command // //
# 3- check if brew command // //
# 4- some Linux platforms don't have git installed, so it's well checking is git command is exist

GH_RAW_URL=https://raw.githubusercontent.com

# install deps
echo "installing deps..."
/bin/bash -c "$(curl -fsSL $GH_RAW_URL/secman-team/corgit/main/setup)"
/bin/bash -c "$(curl -fsSL $GH_RAW_URL/abdfnx/verx/HEAD/install.sh)"
sudo gem install bundler
wget -qO- https://raw.githubusercontent.com/secman-team/secman/HEAD/Gemfile
bundle install
sudo rm -rf Gemfile

v=$(verx secman-team/secman -l)

smUrl=https://github.com/secman-team/secman/releases/download/$v/secman-linux
sm_unUrl=$GH_RAW_URL/secman-team/secman/HEAD/packages/secman-un
sm_syUrl=$GH_RAW_URL/secman-team/secman/HEAD/api/sync/secman-sync
smLocLD=/usr/local/bin

successInstall() {
    echo "yesss, secman was installed successfully 😎, you can type secman --help"
}

installBrew() {
    /bin/bash -c "$(curl -fsSL $GH_RAW_URL/Homebrew/install/HEAD/install.sh)"
}

installSecman_Tools() {
    # secman
    sudo wget -O $smLocLD/secman $smUrl

    sudo chmod 755 $smLocLD/secman

    # secman-un
    sudo wget -P $smLocLD $sm_unUrl

    sudo chmod 755 $smLocLD/secman-un

    # secman-sync
    sudo wget -P $smLocLD $sm_syUrl

    sudo chmod 755 $smLocLD/secman-sync
}

checkWget() {
    if [ -x "$(command -v wget)" ]; then
        installSecman_Tools
    else
        brew install wget

        if [ -x "$(command -v wget)" ]; then
            installSecman_Tools
        fi
    fi
}

gitAndBrew() {
    if [ -x "$(command -v git)" ]; then
        installBrew

        if [ -x "$(command -v brew)" ]; then
            checkWget
        fi
    fi
}

checkGit() {
    if [ -x "$(command -v sudo)" ]; then
        sudo apt install git
        gitAndBrew
    else
        apt install git
        gitAndBrew
    fi

}

mainCheck() {
    if [ -x "$(command -v brew)" ]; then
        checkWget

    else
        if [ -x "$(command -v git)" ]; then
            installBrew

            if [ -x "$(command -v brew)" ]; then
                checkWget
            fi
        else
            checkGit
        fi
    fi
}

if [ -x "$(command -v curl)" ]; then
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
