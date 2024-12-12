#!/bin/bash
set -ex

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

cd $C3BASEPATH/open-c3/Installer/C3/pkg/trouble-ticketing || exit

bash -c "cd $C3BASEPATH/open-c3/Connector/tt/trouble-ticketing && ./build.sh"

mkdir -p _tempdata/open-c3/Connector/pkg
cp $C3BASEPATH/open-c3/Connector/tt/trouble-ticketing/trouble-ticketing _tempdata/open-c3/Connector/pkg/
mv _tempdata tempdata
