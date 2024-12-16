#!/bin/bash
set -e

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )
. $C3BASEPATH/open-c3/Installer/scripts/multi-os-support.sh

cd $C3BASEPATH/open-c3/Installer/C3/pkg || exit 1

cat module|c3xargs bash -c "./extract-module.sh {} || exit 255"

# unzip
cd $C3BASEPATH/open-c3/Connector/pkg || exit 1
tar -zxvf install-cache.tar.gz;
tar -zxvf dev-cache.tar.gz;
tar -zxvf book.tar.gz;

# install-cache
if [ -d "$C3BASEPATH/open-c3/Installer/install-cache" ] && [ ! -L "$C3BASEPATH/open-c3/Installer/install-cache" ] ; then
    rm -rf $C3BASEPATH/open-c3/Installer/install-cache
fi
ln -fsn $C3BASEPATH/open-c3/Connector/pkg/install-cache $C3BASEPATH/open-c3/Installer/install-cache

# dev-cache
if [ -d "$C3BASEPATH/open-c3/Installer/dev-cache" ] && [ ! -L "$C3BASEPATH/open-c3/Installer/dev-cache" ] ; then
    rm -rf $C3BASEPATH/open-c3/Installer/dev-cache
fi
ln -fsn $C3BASEPATH/open-c3/Connector/pkg/dev-cache $C3BASEPATH/open-c3/Installer/dev-cache
