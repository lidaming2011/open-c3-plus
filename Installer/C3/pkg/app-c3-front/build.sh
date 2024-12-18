#!/bin/bash
set -ex

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )

VERSION=$1
if [ "X$VERSION" == "X" ];then
    VERSION=$(date +%y%m%d)
fi
echo VERSION:$VERSION

cd $C3BASEPATH/open-c3/Installer/C3/pkg/app-c3-front || exit

rm -rf /data/open-c3/approve-front/dist

/data/open-c3/Installer/scripts/approve-dev.sh build

mkdir -p _tempdata/open-c3/c3-front
mv /data/open-c3/approve-front/dist _tempdata/open-c3/c3-front/dist-app
mv _tempdata tempdata
