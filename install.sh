#!/bin/bash

# curl -fsSL https://cli.secman.dev | bash

v=$(curl --silent "https://api.github.com/repos/scmn-dev/secman/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

releases_api_url=https://github.com/scmn-dev/secman/releases/download

secman_deb=secman_${v}_amd64.deb

successInstall() {
    echo "🙏 Thanks for installing the Secman CLI! If this is your first time using the CLI, be sure to run `secman --help` first."
}

installSecman() {
    echo "Installing secman version $v"

    wget $releases_api_url/$v/$secman_deb
    sudo chmod 755 $secman_deb
    sudo apt-get install -y ./$secman_deb
    sudo apt-get update
    rm ./$secman_deb

    if [ -x "$(command -v secman)" ]; then
        secman init

    else
        echo "Secman CLI not installed. Please try again."
    fi
}

installSecman

if [ -x "$(command -v secman)" ]; then
    successInstall
else
    echo "Download failed 😔"
    echo "Please try again."
fi
