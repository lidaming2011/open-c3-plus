#!/bin/bash

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )
. $C3BASEPATH/open-c3/Installer/scripts/multi-os-support.sh

BASE_PATH=$C3BASEPATH/open-c3
cd $BASE_PATH || exit 1

function upgradeSelf() {

    if [ "X$1" == "XSS" ];then
        echo =================================================================
        echo "[INFO]check version ..."
        BRANCH=$(git branch|grep ^*|awk '{print $2}'|grep "^v[0-9]*\.[0-9]*\.[0-9]*$")
        echo "VERSION: $BRANCH"

        CHECK=$(LANG=en git remote show origin |grep "^ *$BRANCH *pushes *to *$BRANCH"|grep '(local out of date)'|grep -v grep|wc -l)
        if [ "X0" == "X$CHECK" ]; then
            echo "No update required"
            exit;
        fi
    fi

#    echo =================================================================
#    echo "[INFO]git pull ..."
#
#    git pull
#
#    if [ $? = 0 ]; then
#        echo "[SUCC]git pull success."
#    else
#        echo "[FAIL]git pull fail."
#        exit 1
#    fi

    echo =================================================================
    echo "[INFO]docker pull ..."

    docker pull $(cat $BASE_PATH/Installer/C3/JOB/dockerfile |grep ^FROM|awk '{print $2}')

    if [ $? = 0 ]; then
        echo "[SUCC]docker pull success."
    else
        echo "[FAIL]docker pull fail."
        exit 1
    fi

    echo =================================================================
    echo "[INFO]pkg extract ..."

    $C3BASEPATH/open-c3/Installer/C3/pkg/extract.sh

    if [ $? = 0 ]; then
        echo "[SUCC]pkg extract success."
    else
        echo "[FAIL]pkg extract fail."
        exit 1
    fi

#    echo =================================================================
#    echo "[INFO]install-cache pull ..."
#
#    cd Installer/install-cache && git pull
#
#    if [ $? = 0 ]; then
#        echo "[SUCC]git pull success."
#    else
#        echo "[FAIL]git pull fail."
#        exit 1
#    fi

    cd $BASE_PATH || exit 1

    echo =================================================================
    echo "[INFO]copy node_exporter to Agent.Mon ..."

    rsync -av Installer/install-cache/node_exporter/ AGENT/agent.mon/data/node_exporter/

    if [ $? = 0 ]; then
        echo "[SUCC]copy node_exporter to Agent.Mon success."
    else
        echo "[FAIL]copy node_exporter to Agent.Mon fail."
        exit 1
    fi

    echo =================================================================
    echo "[INFO]agent build ..."

    docker exec openc3-server /data/Software/mydan/AGENT/tools/Build

    if [ $? = 0 ]; then
        echo "[SUCC]agent build success."
    else
        echo "[FAIL]agent build fail."
        exit 1
    fi

    echo =================================================================
    echo "[INFO]c3-front build ..."

    ./Installer/scripts/dev.sh build

    if [ $? = 0 ]; then
        echo "[SUCC]c3-front build success."
    else
        echo "[FAIL]c3-front build fail."
        exit 1
    fi

    echo =================================================================
    echo "[INFO]reload open-c3 service ..."

    CTRL=restart
    if [[ "X$1" == "XS" || "X$1" == "XSS" ]];then
        CTRL=reload
    fi
    ./Installer/scripts/single.sh $CTRL

    echo =================================================================
    echo "[INFO]tt-front build ..."

    mkdir -p $C3BASEPATH/open-c3/c3-front/dist/tt
    rsync  -av $C3BASEPATH/open-c3/Installer/install-cache/trouble-ticketing/tt-front/dist/ $C3BASEPATH/open-c3/c3-front/dist/tt/ --delete
    rsync -av $C3BASEPATH/open-c3/Connector/tt/tt-front/src/assets/images/  $C3BASEPATH/open-c3/c3-front/dist/assets/images/

    if [ $? = 0 ]; then
        echo "[SUCC]tt-front build success."
    else
        echo "[FAIL]tt-front build fail."
        exit 1
    fi

    echo =================================================================
    echo "[INFO]copy trouble-ticketing ..."

    COOKIEKEY=$(cat $C3BASEPATH/open-c3/Connector/config.inix | grep -v '^ *#' | grep cookiekey:|awk '{print $2}'|grep ^[a-zA-Z0-9]*$)
    c3sed "s/\"cookiekey\":\".*\"/\"cookiekey\":\"$COOKIEKEY\"/g" $C3BASEPATH/open-c3/Connector/tt/trouble-ticketing/cfg.json

    cp $C3BASEPATH/open-c3/Connector/pkg/trouble-ticketing $C3BASEPATH/open-c3/Connector/tt/trouble-ticketing/trouble-ticketing.$$
    mv $C3BASEPATH/open-c3/Connector/tt/trouble-ticketing/trouble-ticketing.$$ $C3BASEPATH/open-c3/Connector/tt/trouble-ticketing/trouble-ticketing
    chmod +x $C3BASEPATH/open-c3/Connector/tt/trouble-ticketing/trouble-ticketing

    if [ $? = 0 ]; then
        echo "[SUCC]copy trouble-ticketing success."
    else
        echo "[FAIL]copy trouble-ticketing fail."
        exit 1
    fi

    echo =================================================================
    echo "[INFO]golang build ..."
    find $C3BASEPATH/open-c3/Connector/pp -name golang-build.sh|sed "s/\/golang-build.sh$//"|c3xargs bash -c "echo golang build {} && cd {} && ./golang-build.sh"

    if [ $? = 0 ]; then
        echo "[SUCC]golang build success."
    else
        echo "[FAIL]golang build fail."
        exit 1
    fi

}

function upgradeCluster() {

    Cluster=$1
    Version=$(date +%Y%m%d%H%M)

    if [ "X$2" == "XS" ];then
        Version="S$Version"
    fi

    echo =================================================================
    echo "[INFO]upgrade Cluster $Cluster Version $Version..."

    ./Installer/scripts/cluster.sh deploy -e $Cluster -v $Version
}

if [[ "X$1" == "X" || "X$1" == "XS" || "X$1" == "XSS" ]]; then
    upgradeSelf $1
else
    upgradeCluster $1 $2
fi
