#!/bin/bash

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

$C3BASEPATH/open-c3/AGENT/monitor/node-query/dev/install-dev-data.sh     demo
$C3BASEPATH/open-c3/AGENT/monitor/mysql-query/dev/install-dev-data.sh    demo
$C3BASEPATH/open-c3/AGENT/monitor/redis-query/dev/install-dev-data.sh    demo
$C3BASEPATH/open-c3/AGENT/monitor/mongodb-query/dev/install-dev-data.sh  demo
