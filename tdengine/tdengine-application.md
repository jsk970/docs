# TDengine 应用镜像打包发布

## 驱动版本

```xml
 <dependency>
     <groupId>com.taosdata.jdbc</groupId>
     <artifactId>taos-jdbcdriver</artifactId>
     <version>2.0.34</version>
</dependency>
```
## JDK版本

> java version "1.8.0_191"

|                   | JDBC-RESTFUL                       | JDBC-JNI                     |
| ----------------- | ---------------------------------- | ---------------------------- |
| driver-class-name | com.taosdata.jdbc.rs.RestfulDriver | com.taosdata.jdbc.TSDBDriver |
| jdbc-url（前缀）  | jdbc:TAOS-RS                       | jdbc:TAOS                    |
| port              | 6041                                    | 6030                         |


**注：** 选择使用 **JDBC-JNI模式** 需使用基础镜像 openjdk:8u212-jdk ，openjdk:8u212-jdk-alpine缺少必要资源文件，会导致以下问题

```sh
$ /user/lib/libtaos.so: Error loading shared libary ld-linux-x86-64.so.2: No such file or directory (needed by /usr/lib/libtaos.so)
```

### run.sh 重要参数说明

#### 挂载文件

libtaos.so.2.4.0.0是 **JDBC-JNI 模式 **所必需依赖的**本地函数库**

> 本地函数库版本与TDengine对应 2.4.XX版本

```sh
-v /home/config/tdengine/libtaos.so.2.4.0.0:/usr/lib/libtaos.so \
```

### DNS解析

配置容器内的DNS解析 ：其中 `tdengine` 为 TDengine-service 镜像内的 `hostname`

> JDBC连接的时候不能使用IP地址  故需添加 --add-host=tdengine:172.16.30.22 \

```sh
--add-host=tdengine:172.16.30.22 \
```

### 配置共享

Dengine系统的前台交互客户端应用程序为taos，以及应用驱动，它与taosd共享同一个配置文件taos.cfg。

```sh
 -v /home/config/tdengine/taos/taos.cfg:/etc/taos/taos.cfg \
```