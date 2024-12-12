#!/bin/bash

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac) 

docker run -it -p 9123:9123 -v $C3BASEPATH/open-c3/Installer/C3/tencentcloud-exporter/qcloud.yml:/qcloud.yml openc3/tencentcloud-exporter:20221122
