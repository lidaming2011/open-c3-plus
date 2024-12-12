#!/bin/bash
set -ex

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

cd $C3BASEPATH/open-c3/Installer/C3/pkg/install-cache || exit

if [ ! -d install-cache ];then
    git clone https://github.com/open-c3/open-c3-install-cache install-cache
fi
bash -c "cd install-cache && git pull";
tar --exclude=.git -zcf install-cache.tar.gz install-cache

mkdir -p _tempdata/open-c3/Connector/pkg
mv install-cache.tar.gz _tempdata/open-c3/Connector/pkg/
mv _tempdata tempdata
