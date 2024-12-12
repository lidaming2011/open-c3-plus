#!/bin/bash

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

VERSION=$1
if [ "X$VERSION" == "X" ];then
    VERSION=$(date +%Y%m%d)
fi
echo VERSION:$VERSION

rm -rf temp
mkdir -p temp
cp -r $C3BASEPATH/open-c3/Installer/install-cache/bin temp/bin

time docker build . -t openc3/kubectl:$VERSION -f dockerfile --no-cache

rm -rf temp
