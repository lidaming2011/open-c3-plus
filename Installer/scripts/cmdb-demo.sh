#!/bin/bash

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )

$C3BASEPATH/open-c3/AGENT/monitor/node-query/dev/install-dev-data.sh     demo
$C3BASEPATH/open-c3/AGENT/monitor/mysql-query/dev/install-dev-data.sh    demo
$C3BASEPATH/open-c3/AGENT/monitor/redis-query/dev/install-dev-data.sh    demo
$C3BASEPATH/open-c3/AGENT/monitor/mongodb-query/dev/install-dev-data.sh  demo
