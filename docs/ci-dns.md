# CI/流水线构建过程使用自建DNS

## 使用场景
```
在实际使用中可能会遇到这样的情况，流水线通过docker容器构建项目的时候，会遇到dns解析错误的情况。

举个例子：

2025年1月8号
Open-C3所在区域的"goproxy.cn" 域名解析到了"163.181.140.200" 上，导致下载依赖文件失败。
在办公网解析goproxy.cn，指向的是106.60.64.105。办公网上是能正常下载依赖的。

这样就需要把Open-C3上的构建环境，把goproxy.cn指向106.60.64.105。
```

## 使用方式

```
# 1.在Open-C3上启动DNS服务。

docker run -d --name dns --restart=always --publish 53:53/udp andyshinn/dnsmasq

# 2. 配置 DNS 服务器的域名解析规则。进入容器并编辑 /etc/dnsmasq.conf。

docker exec -it dns sh
echo "address=/goproxy.cn/106.60.64.105" >> /etc/dnsmasq.conf
kill -HUP $(cat /var/run/dnsmasq.pid)

#如果kill -HUP $(cat /var/run/dnsmasq.pid)不生效可以重启一下容器

# Open-C3在检查到Open-C3的机器上有dns容器运行，在构建的时候会自动通过"docker run --dns=<DNS_SERVER_IP> ..."来指定新的dns地址

# 注: Open-C3在对流水线中的项目进行构建的时候，每个流水线都会保留容器，避免下次构建的时候重新拉取依赖(为了减少网络流量和加快构建速度)。
# 建议尽早启动dns容器，这样需要解析域名的时候就可以方便的指定。
# 在没有dns容器的情况下启动了dns、或者在有dns的情况下想停止dns。都会影响已经生成的容器。如果需要做这样的切换，需要把旧容器删除。
# 比如流水线编号是 123, 可以在c3的机器上执行 docker ps -a|grep 123 看到这个流水线的容器。
```
