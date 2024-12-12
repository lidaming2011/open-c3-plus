#!/bin/bash
set -e

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )

MODULE=$1

if [ "X$MODULE" == "X" ];then
    echo \$0 MODULE
    exit 1
fi
echo MODULE:$MODULE

VERSION=`cat $MODULE/version`;
if [ "X$VERSION" == "X" ];then
    echo nofind VERSION
    exit 1
fi

docker run --rm -v $C3BASEPATH/open-c3:/data/open-c3 openc3/pkg-$MODULE:$VERSION
