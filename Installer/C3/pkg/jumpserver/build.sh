#!/bin/bash
set -e

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

cd $C3BASEPATH/open-c3/Installer/C3/pkg/jumpserver || exit

bash -c "cd $C3BASEPATH/open-c3/Connector/bl/sync/jumpserver && ./build.sh"

mkdir -p _tempdata/open-c3/Connector/bl/sync/jumpserver
cp $C3BASEPATH/open-c3/Connector/bl/sync/jumpserver/jumpserver _tempdata/open-c3/Connector/bl/sync/jumpserver/
chmod +x _tempdata/open-c3/Connector/bl/sync/jumpserver/jumpserver
mv _tempdata tempdata
