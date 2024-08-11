# TDengine 时序数据库部署

## TDengine版本

> tdengine/tdengine:2.4.0.3

## 部署步骤

1、将TDengine时序数据库配置（config文件夹）放置在服务器home目录下

2、将数据放置在 /home/data/tdengine/taos 目录下（可选）

3、创建 /home/logs/tdengine/tao

4、执行run.sh 脚本

## run.sh 脚本示例

```sh
docker stop tdengine-service-dev
sleep 1s
docker rm -f tdengine-service-dev
sleep 1s
docker run -d \
--restart=always \
--name tdengine-service-dev \
--hostname=tdengine \
-v /home/config/tdengine/taos:/etc/taos \
-v /home/data/tdengine/taos:/var/lib/taos \
-v /home/logs/tdengin/taos:/var/log/taos \
-p 6030-6041:6030-6041 \
-p 6030-6041:6030-6041/udp \
tdengine/tdengine:2.4.0.3
```
## 脚本说明

### 指定容器内服务器的hostname
（后续应用以  **JDBC-JNI模式**  访问TDengine-Service时需用到，**JDBC-RESTful模式**可忽略此配置）
```sh
--hostname=tdengine \
```
### 挂载目录

taos配置文件目录

```sh
-v /home/config/tdengine/taos:/etc/taos \
```

taos数据目录

```sh
-v /home/data/tdengine/taos:/var/lib/taos
```
taos日志目录

```sh
-v /home/logs/tdengine/taos:/var/log/taos
```
### 端口

将容器的 6030 到 6041 端口映射到宿主机的 6030 到 6041 端口上

```sh
-p 6030-6041:6030-6041 \
-p 6030-6041:6030-6041/udp \
```

> **UDP端口为客户端JDBC-JNI模式访问所必需**
