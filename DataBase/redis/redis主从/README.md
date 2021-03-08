## redis 主从配置 
> 前提安装好redis服务器

redis主服务器，创建主库的配置文件

- 修改主服务器上修改配置文件redis-master.conf

```
#在后台启动
daemonize yes
#端口 
port 9002
#绑定IP
#bind 127.0.0.1
#记录日记的级别
loglevel notice
#日志文件  
logfile /app/soft/redis/logs/redis.log
#数据存储目录  
dir /app/soft/redis/data  
pidfile /app/soft/redis/data/redis_master.pid
```

- 修改从服务器上修改配置文件redis-slave.conf

```
daemonize yes
port 9002
bind 127.0.0.1
loglevel notice
logfile /app/soft/redis/logs/redis.log
dir /app/soft/redis/data
slaveof 10.124.210.14 9002
pidfile /app/soft/redis/data/redis_slave.pid

```

```shell
cd /usr/local/redis/bin/
#redis客户端指定端口启动
./redis-cli -h 127.0.0.1 -p 6379
```

通过进程看所占的端口号

```shell
netstat -nap | grep 16256
```

Redis主从配置异常解决：Error condition on socket for SYNC: Connection refused
在docker中搭建的redis主从集群时，从服务器上的redis日志报错：

```shell
32677:S 08 Feb 16:14:38.947 * Connecting to MASTER 172.168.10.70:6379
32677:S 08 Feb 16:14:38.948 * MASTER <-> SLAVE sync started
32677:S 08 Feb 16:14:38.948 # Error condition on socket for SYNC: Connection refused
32677:S 08 Feb 16:14:39.950 * Connecting to MASTER 172.168.10.70:6379
32677:S 08 Feb 16:14:39.950 * MASTER <-> SLAVE sync started
32677:S 08 Feb 16:14:39.950 # Error condition on socket for SYNC: Connection refused
32677:S 08 Feb 16:14:40.952 * Connecting to MASTER 172.168.10.70:6379
32677:S 08 Feb 16:14:40.952 * MASTER <-> SLAVE sync started
32677:S 08 Feb 16:14:40.953 # Error condition on socket for SYNC: Connection refused
```

解决方案：
在redis主服务器上的redis.conf中修改bind字段，将

```shell
bind 127.0.0.1
```
修改为

```shell
bind 0.0.0.0
```

又或者直接注释掉bind字段

```shell
 bind 127.0.0.1
```

`原因： 如果redis主服务器绑定了127.0.0.1，那么跨服务器IP的访问就会失败，从服务器用IP和端口访问主的时候，主服务器发现本机6379端口绑在了127.0.0.1上，也就是只能本机才能访问，外部请求会被过滤，这是linux的网络安全策略管理的。如果bind的IP地址是172.168.10.70，那么本机通过localhost和127.0.0.1、或者直接输入命令redis-cli登录本机redis也就会失败了。只能加上本机ip才能访问到。 所以，在研发、测试环境可以考虑bind 0.0.0.0，线上生产环境建议绑定IP地址。`
