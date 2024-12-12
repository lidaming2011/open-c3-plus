#!/bin/bash

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

#该工具用于在OPEN-C3开发过程中进行版本切换。
#在开发过程中可能需要管理多个版本的环境，一个环境包含两个目录 $C3BASEPATH/open-c3 和 $C3BASEPATH/open-c3-data
#在这两个目录中放入 .uuid 文件，写入环境名称，比如 foo或者v2.3.5 。通一个环境的两个目录中的uuid文件内容一致。
#
#
#用法：
#$0 列出所有的环境
#$0 envname 切换到某个环境
#
#可以把这个脚本拷贝到$C3BASEPATH目录下。

UUID=$1

if [ "X" == "X$UUID" ]; then
    cat $C3BASEPATH/*/.uuid|sort|uniq
    exit
fi

docker stop openc3-mysql
docker stop openc3-server

#兼容旧版本
docker stop c3_openc3-server_1

#v2.5.1以及以上版本存在的服务
docker stop openc3-prometheus
docker stop openc3-alertmanager
docker stop openc3-grafana

if [ -d $C3BASEPATH/open-c3 ];then
    OPENC3APPUUID=$(cat $C3BASEPATH/open-c3/.uuid)
    if [ "X" == "X$OPENC3APPUUID"  ];then
        echo "$C3BASEPATH/open-c3 没有.uuid文件"
        exit
    fi
    mv $C3BASEPATH/open-c3 $C3BASEPATH/open-c3-$OPENC3APPUUID

fi

if [ -d $C3BASEPATH/open-c3-data ];then
    OPENC3DATUUID=$(cat $C3BASEPATH/open-c3-data/.uuid)
    if [ "X" == "X$OPENC3DATUUID" ]; then
        echo "$C3BASEPATH/open-c3-data 没有.uuid文件"
        exit
    fi
    mv $C3BASEPATH/open-c3-data $C3BASEPATH/open-c3-data-$OPENC3DATUUID
fi

if [[ -d $C3BASEPATH/open-c3 || -d $C3BASEPATH/open-c3-data ]];then
    echo "移走旧目录失败"
    exit
fi

mv $C3BASEPATH/open-c3-$UUID $C3BASEPATH/open-c3
mv $C3BASEPATH/open-c3-data-$UUID $C3BASEPATH/open-c3-data

if [[ -d $C3BASEPATH/open-c3 && -d $C3BASEPATH/open-c3-data ]];then
    echo "移动目录成功"
else
    echo "移动目录失败"
    exit
fi

$C3BASEPATH/open-c3/open-c3.sh  reborn

V=$(cd $C3BASEPATH/open-c3 && git branch |grep ^*|awk '{print $2}' )
Script="$C3BASEPATH/open-c3/Installer/scripts/single/$V.sh"

if [ -x $Script ]; then
    $Script
fi

$C3BASEPATH/open-c3/Installer/scripts/dev.sh  restart
