#!/bin/bash
set -e

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )

MODULE=$1
VERSION=$2

if [ "X$MODULE" == "X" ] || [ "X$VERSION" == "X" ];then
    echo \$0 MODULE VERSION
    exit 1
fi

cd $C3BASEPATH/open-c3/Installer/C3/pkg || exit 1

rm -rf $MODULE/tempdata
rm -rf $MODULE/_tempdata

./$MODULE/build.sh

cd $MODULE/tempdata || exit 1

git log                > git.log
git branch | grep '^*' > git.branch

tar --exclude=x.tar.gz -zcvf x.tar.gz *

cp ../../entrypoint.sh .
cp ../../dockerfile    .

docker build . -t openc3/pkg-$MODULE:$VERSION --no-cache

echo $VERSION > ../version
rm -rf ../tempdata
