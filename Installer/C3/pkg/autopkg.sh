#!/bin/bash

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )

set -e

cd $C3BASEPATH/open-c3/Installer/C3/pkg || exit

git pull

cat module|grep -v '^#'|xargs -i{} bash -c "./autopkg {} || exit 255"
