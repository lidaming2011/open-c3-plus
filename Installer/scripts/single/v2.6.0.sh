#!/bin/bash

C3BASEPATH=$( [[ "$(uname -s)" == Darwin ]] && echo "$HOME/open-c3-workspace" || echo "/data" )

#docker exec -i openc3-server /data/Software/mydan/perl/bin/cpan install AnyEvent::HTTPD::Router AnyEvent::HTTPD::CookiePatch AnyEvent::HTTP

#docker cp $C3BASEPATH/open-c3/Installer/install-cache/bin/kubectl    openc3-server:/usr/bin/
#docker cp $C3BASEPATH/open-c3/Installer/install-cache/bin/yaml2json  openc3-server:/usr/bin/
#docker cp $C3BASEPATH/open-c3/Installer/install-cache/bin/json2yaml  openc3-server:/usr/bin/
#docker cp $C3BASEPATH/open-c3/Installer/install-cache/bin/xlsx2csv   openc3-server:/usr/bin/
#docker cp $C3BASEPATH/open-c3/Installer/install-cache/bin/csv2xlsx   openc3-server:/usr/bin/

#TODO 集群发布后，webshell容器需要拷贝kubectl命令到容器中，否则影响webshell进入pod。
#手动创建一个流水线，作为kubernetes管理的流水线默认模版。
#升级的时候可能会报错，确认CI模块的配置里面的端口是否被正确能让api.event生效。

#docker cp $C3BASEPATH/open-c3/CI/bin/aws_c3 openc3-server:/usr/local/bin/

#docker cp $C3BASEPATH/open-c3/lua/lualib/resty/http.lua         openc3-lua:/usr/local/openresty/lualib/resty/http.lua
#docker cp $C3BASEPATH/open-c3/lua/lualib/resty/http_connect.lua openc3-lua:/usr/local/openresty/lualib/resty/http_connect.lua
#docker cp $C3BASEPATH/open-c3/lua/lualib/resty/http_headers.lua openc3-lua:/usr/local/openresty/lualib/resty/http_headers.lua

#oncall 需要的插件
#docker exec -i openc3-server /data/Software/mydan/perl/bin/cpan install DateTime
#mkdir -p $C3BASEPATH/open-c3-data/glusterfs/oncall/{conf,data}

#mail mon
#docker exec -i openc3-server /data/Software/mydan/perl/bin/cpan install Mail::POP3Client Email::MIME Email::MIME::RFC2047::Decoder
#mkdir -p $C3BASEPATH/open-c3-data/glusterfs/mailmon/{conf,data,run}

#mkdir -p $C3BASEPATH/open-c3-data/monitor-sender

#update webshell
cp $C3BASEPATH/open-c3/web-shell/private/tty.js/static/tty.js $C3BASEPATH/open-c3/web-shell/node_modules/tty.js/static/tty.js

#localbash clean
docker stop openc3-localbash
docker rm   openc3-localbash

#mkdir -p $C3BASEPATH/open-c3-data/logs/CI/webhooks_data
#mkdir -p $C3BASEPATH/open-c3-data/logs/CI/webhooks_logs

#docker exec -i openc3-server /data/Software/mydan/perl/bin/cpan install Paws Hash::Flatten

#docker exec -i openc3-server touch /etc/openc3.supervisormin.on

mkdir -p $C3BASEPATH/open-c3-data/cloudmon
if [ ! -f $C3BASEPATH/open-c3-data/cloudmon/docker-compose ]; then
    cp $C3BASEPATH/open-c3/Installer/docker-compose $C3BASEPATH/open-c3-data/cloudmon/docker-compose 
    chmod +x $C3BASEPATH/open-c3-data/cloudmon/docker-compose
fi

#docker exec -i openc3-server /data/Software/mydan/perl/bin/cpan install Net::LDAP

#docker exec -i openc3-server bash -c "curl -L http://openc3-srv-docker/api/scripts/installAgent.sh |OPEN_C3_ADDR=http://openc3-srv-docker bash"

#mkdir -p $C3BASEPATH/open-c3-data/cache/nodeinfo
#mkdir -p $C3BASEPATH/open-c3-data/cache/treemap
#mkdir -p $C3BASEPATH/open-c3-data/cache/userinfo
#mkdir -p $C3BASEPATH/open-c3-data/cache/point
#mkdir -p $C3BASEPATH/open-c3-data/cache/usertree

#docker exec -i openc3-server yum install mysql -y

#docker exec -i openc3-server /data/Software/mydan/perl/bin/cpan install Crypt::RC4::XS

#docker cp $C3BASEPATH/open-c3/Installer/install-cache/bin/amtool  openc3-server:/usr/bin/

$C3BASEPATH/open-c3/open-c3.sh sup
$C3BASEPATH/open-c3/open-c3.sh dup
