#!/bin/bash

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac) 

# 制作AWS AMI时可以执行这个脚本清理文件

if [ "X$1" != "Xforce" ] ;then
    echo "./$0 force"
    exit
fi


$C3BASEPATH/open-c3/upgrade.sh

sudo touch $C3BASEPATH/open-c3-data/lotus/ooze

sudo passwd -l root
sudo shred -u /etc/ssh/*_key /etc/ssh/*_key.pub
shred -u ~/.*history
history -c

#docker exec openc3-server  c3mc-base-adduser --user open-c3
