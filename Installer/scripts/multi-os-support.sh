#!/bin/bash

shopt -s expand_aliases

CurrOS=Unknown
unameOutput=$(uname -s)
case "${unameOutput}" in
    Linux*)
        if grep -q 'CentOS' /etc/os-release; then
            CurrOS=CentOS
        elif grep -q 'Ubuntu' /etc/os-release; then
            CurrOS=Ubuntu
        elif grep -q 'Deepin' /etc/os-release; then
            CurrOS=Deepin
        fi
        ;;
    Darwin*)
        CurrOS=macOS
        ;;
    *)
        CurrOS=Unknown
        ;;
esac

test $CurrOS == "Unknown" && exit 1

if [ "$CurrOS" == "macOS" ]; then
    alias c3sed='sed -i ""'
    alias c3xargs='xargs -I{}'
    alias c3pkginstall='brew'

    alias c3-docker-compose="docker-compose"

    C3BASEPATH=$HOME/open-c3-workspace

elif [ "$CurrOS" == "CentOS" ]; then
    alias c3sed='sed -i'
    alias c3xargs='xargs -i{}'
    alias c3pkginstall='yum'

    alias c3-docker-compose="$C3BASEPATH/open-c3/Installer/docker-compose"

else
    alias c3sed='sed -i'
    alias c3xargs='xargs -i{}'
    alias c3pkginstall='apt-get'

    alias c3-docker-compose="$C3BASEPATH/open-c3/Installer/docker-compose"
fi
