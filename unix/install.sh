#!/bin/bash

installPath=$1
secmanPath=""

if [ "$installPath" != "" ]; then
    secmanPath=$installPath
else
    secmanPath=/usr/local/bin
fi

UNAME=$(uname)
ARCH=$(uname -m)

rmOldFiles() {
    if [ -f $secmanPath/secman ]; then
        sudo rm -rf $secmanPath/secman*
    fi
}

v=$(curl --silent "https://api.github.com/repos/scmn-dev/secman/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

releases_api_url=https://github.com/scmn-dev/secman/releases/download

successInstall() {
    echo "
███████╗ ███████╗  ██████╗ ███╗   ███╗  █████╗  ███╗   ██╗
██╔════╝ ██╔════╝ ██╔════╝ ████╗ ████║ ██╔══██╗ ████╗  ██║
███████╗ █████╗   ██║      ██╔████╔██║ ███████║ ██╔██╗ ██║
╚════██║ ██╔══╝   ██║      ██║╚██╔╝██║ ██╔══██║ ██║╚██╗██║
███████║ ███████╗ ╚██████╗ ██║ ╚═╝ ██║ ██║  ██║ ██║ ╚████║
╚══════╝ ╚══════╝  ╚═════╝ ╚═╝     ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═══╝"
    echo "🙏 Thanks for installing Secman! If this is your first time using the CLI, be sure to run `secman help` first."
}

mainCheck() {
    echo "Installing secman version $v"
    name=""

    if [ "$UNAME" == "Linux" ]; then
        if [ $ARCH = "x86_64" ]; then
            name="secman_linux_${v}_amd64"
        elif [ $ARCH = "i686" ]; then
            name="secman_linux_${v}_386"
        elif [ $ARCH = "i386" ]; then
            name="secman_linux_${v}_386"
        elif [ $ARCH = "arm64" ]; then
            name="secman_linux_${v}_arm64"
        elif [ $ARCH = "arm" ]; then
            name="secman_linux_${v}_arm"
        fi

        secmanURL=$releases_api_url/$v/$name.zip

        wget $secmanURL
        sudo chmod 755 $name.zip
        unzip $name.zip
        rm $name.zip

        # secman
        sudo mv $name/bin/secman $secmanPath

        rm -rf $name

    elif [ "$UNAME" == "Darwin" ]; then
        if [ $ARCH = "x86_64" ]; then
            name="secman_macos_${v}_amd64"
        elif [ $ARCH = "arm64" ]; then
            name="secman_macos_${v}_arm64"
        fi

        secmanURL=$releases_api_url/$v/$name.zip

        wget $secmanURL
        sudo chmod 755 $name.zip
        unzip $name.zip
        rm $name.zip

        # secman
        sudo mv $name/bin/secman $secmanPath

        rm -rf $name

    elif [ "$UNAME" == "FreeBSD" ]; then
        if [ $ARCH = "x86_64" ]; then
            name="secman_freebsd_${v}_amd64"
        elif [ $ARCH = "i386" ]; then
            name="secman_freebsd_${v}_386"
        elif [ $ARCH = "i686" ]; then
            name="secman_freebsd_${v}_386"
        elif [ $ARCH = "arm64" ]; then
            name="secman_freebsd_${v}_arm64"
        elif [ $ARCH = "arm" ]; then
            name="secman_freebsd_${v}_arm"
        fi

        secmanURL=$releases_api_url/$v/$name.zip

        wget $secmanURL
        sudo chmod 755 $name.zip
        unzip $name.zip
        rm $name.zip

        # secman
        sudo mv $name/bin/secman $secmanPath

        rm -rf $name
    fi

    # chmod
    sudo chmod 755 $secmanPath/secman

    # install secman core cli
    if [ -x "$(command -v npm)" ]; then
        echo "Installing secman core cli..."
        npm install -g @secman/scc
    else
        echo "npm is not installed. Please install npm first."
    fi
}

rmOldFiles
mainCheck

if [ -x "$(command -v secman)" ]; then
    successInstall
else
    echo "Download failed 😔"
    echo "Please try again."
fi
