#!/bin/bash
set -e

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)


VERSION=$1

if [ "X$VERSION" == "X" ];then
    VERSION=$(date +%y%m%d)
fi
echo VERSION:$VERSION

cd $C3BASEPATH/open-c3/Installer/C3/pkg || exit

cat module|grep -v '^#'|xargs -i{} bash -c "./build-module.sh {} $VERSION || exit 255"
