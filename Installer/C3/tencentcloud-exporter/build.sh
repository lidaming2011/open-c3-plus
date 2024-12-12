#!/bin/bash
set -ex

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

VERSION=$1
if [ "X$VERSION" == "X" ];then
    VERSION=$(date +%Y%m%d)
fi
echo VERSION:$VERSION

cd temp

docker build . -t openc3/tencentcloud-exporter:$VERSION --no-cache

docker ps|grep 0.0.0.0:9123|awk '{print $1}'| xargs -i{} docker kill {}

docker run -it -p 9123:9123 \
  -v $C3BASEPATH/open-c3/Installer/C3/tencentcloud-exporter/qcloud.yml:/qcloud.yml \
  openc3/tencentcloud-exporter:$VERSION
