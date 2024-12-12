#!/bin/bash
set -e

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )

cd $C3BASEPATH/open-c3/Installer/C3/pkg || exit

echo -n "c3-bot " > upload.txt

git status .|grep /version|awk '{print $NF}'|awk -F/ '{print $1}' |grep -f module |xargs -i{} bash -c "./upload-module.sh {} || exit 255"

git commit -m "`cat upload.txt`"
