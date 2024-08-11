# Docker for Mac Install
> 下载地址：http://get.daocloud.io/#install-docker-for-mac-windows
## Docker 基本命令
- 查看Docker版本
```shell script
docker -v
```
- 查看当前系统中的images信息
```shell script
docker images 
```
- 创建一个容器
> -d: 后台运行容器，并返回容器ID；
> -i: 以交互模式运行容器，通常与 -t 同时使用；
> -t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用；

```shell script
docker run -itd --name centos-test2 centos:latest
docker run -itd centos:latest
docker run -itd <容器 ID>
docker run -itd --name centos-001 -p 22:22 5100d244d951
docker run -itd -p 5022:22 0298da39ef00 /usr/sbin/sshd -D
docker run -d -p 10000:22 -p 9092:9092 -p 2181:2181 --name centos7-ssh 429 /usr/sbin/sshd -D
```

- 查看正在运行的所有镜像
```shell script
docker ps -a
```
- 启动一个已停止的容器
```shell script
docker start b750bbbcfd88(CONTAINER ID)
```
- 停止容器
```shell script
docker stop <容器 ID>
```
- 重启容器
```shell script
docker restart <容器 ID>
```
- 重命名容器
```shell script
docker rename <旧容器名称/容器ID> 新容器名称
```
- 打开容器的shell
```shell script
docker exec -it <容器 ID> /bin/bash
```
- 提交镜像
> -a :提交的镜像作者；
> -c :使用Dockerfile指令来创建镜像；
> -m :提交时的说明文字；
> -p :在commit时，将容器暂停。
```shell script
docker commit -a "jsk" -m "init" 7981530ab0dc  centos:init
docker commit -a "jsk" -m "开启ssh22端口" aaf16a98ffb7  centos:v1.0.1 
```

- 登录docker仓库,将镜像推送到Registry
```shell script
docker login --username=16619732533 registry.cn-hangzhou.aliyuncs.com
docker tag  [ImageId] registry.cn-hangzhou.aliyuncs.com/centos_jsk/centos:v1.0.1
docker tag  5100d244d951 registry.cn-hangzhou.aliyuncs.com/centos_jsk/centos:init
docker push registry.cn-hangzhou.aliyuncs.com/centos_jsk/centos:init
```

- 从Registry中拉取镜像
```shell script
docker pull registry.cn-hangzhou.aliyuncs.com/centos_jsk/centos:v1.0.1
```

- 强制删除容器
```shell script
docker rm -f db01 db02
```
- 删除本地镜像
```shell script
docker rmi [OPTIONS] IMAGE [IMAGE...]
docker rmi -f <镜像 ID>
```


Docker Centos 安装 ssh
```shell script
yum -y update
```
安装必须的插件
```shell script
yum -y install passwd openssl openssh-server  openssh-clients
```
创建目录
```shell script
mkdir  /var/run/sshd/
```
查看修改配置 修改为： UsePAM no
```shell script
cat /etc/ssh/sshd_config
sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
```

```shell script
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
```
启动sshd
```shell script
/usr/sbin/sshd -D &
```
安装
```shell script
yum -y install lsof
lsof -i:22 
```
修改root密码
```shell script
passwd
```
映射端口到宿主机
```shell script
docker run -d -p 10000:22 --name centos7-ssh 429 /usr/sbin/sshd -D
```
测试连接
```shell script
ssh root@Ip 10000
```

