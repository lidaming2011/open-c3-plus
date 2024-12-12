#!/bin/bash
set -e

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

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

cd $C3BASEPATH/open-c3/Installer/C3/pkg || exit 1

docker push openc3/pkg-$MODULE:$VERSION

git add $MODULE/version

echo "c3bot:autopkg($MODULE:$VERSION)" >> upload.txt
