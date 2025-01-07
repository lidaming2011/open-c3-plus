#!/bin/bash
set -e

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )

if [[ "X$1" == "Xforce" || "X$1" == "X-f" ]];then
    $C3BASEPATH/open-c3/open-c3.sh upgrade
else
    $C3BASEPATH/open-c3/open-c3.sh upgrade S
fi

$C3BASEPATH/open-c3/open-c3.sh sup
$C3BASEPATH/open-c3/open-c3.sh dup

echo "upgrade done. !!!"
