#!/bin/bash

C3BASEPATH=$(case  $(uname -s) in Darwin*) echo "$HOME/open-c3-workspace";; *) echo "/data";; esac)

logFile=$C3BASEPATH/open-c3-data/logs/singleAutoUpdate.log
exec >> $logFile 2>&1 

echo '############################################################'
echo start update ...
date
$C3BASEPATH/open-c3/open-c3.sh upgrade SS
echo finish
date
