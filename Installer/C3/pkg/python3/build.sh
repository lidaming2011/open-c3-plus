#!/bin/bash
set -ex

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

VERSION=$1
if [ "X$VERSION" == "X" ];then
    VERSION=$(date +%y%m%d)
fi
echo VERSION:$VERSION

cd $C3BASEPATH/open-c3/Installer/C3/pkg/python3 || exit

docker build . -t openc3/pkg-python3:$VERSION --no-cache

docker run -v $C3BASEPATH/open-c3/Installer/C3/pkg/python3:/tempdata openc3/pkg-python3:$VERSION

mkdir -p _tempdata/open-c3/Connector/pkg
mv python3.tar.gz _tempdata/open-c3/Connector/pkg/python3.tar.gz
mv _tempdata tempdata
