# JavaWeb环境搭建

> 环境基于 CentOS 6.5 64位

## JDK下载安装

### 1、下载jdk（链接地址注意应该是jdk文件,下载弹窗复制链接地址，链接可能无效可以到oracle官网获取）

```
http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
wget 链接地址
```

### 2、解压jdk到/usr/local/目录下

```
tar -zxvf jdk-8u181-linux-x64.tar.gz\?AuthParam=1533393338_257b24330166bb61161aa64b944f91b0 -C /usr/local/
```

### 3、配置环境变量

```
vi /etc/profile	
末尾添加以下配置信息（wq保存）
```

注意：环境变量千万能配置错误，否则可能导致系统崩溃！！

```
JAVA_HOME=/usr/local/jdk1.8.0_181
PATH=$PATH:$JAVA_HOME/bin
CLASSPATH=.
export JAVA_HOME
export PATH
export CLASSPATH
```

### 4、刷新配置文件

```
source /etc/profile
```

### 5、验证配置环境

```
java -version
```

## Tomcat 7下载安装

### 1、下载apache-tomcat-7.0.90.tar.gz

```shell
wget http://www-us.apache.org/dist/tomcat/tomcat-7/v7.0.90/bin/apache-tomcat-7.0.90.tar.gz
```

### 2、解压apache-tomcat-7.0.90.tar.gz

```
tar -zxvf apache-tomcat-7.0.90.tar.gz
```

### 3、启动tomcat

```
cd /usr/local/apache-tomcat-7.0.90/bin
启动命令：
./shartup.sh
```

启动成功：

```
[root@VM_0_15_centos bin]# ./startup.sh 
Using CATALINA_BASE:   /usr/local/apache-tomcat-7.0.90
Using CATALINA_HOME:   /usr/local/apache-tomcat-7.0.90
Using CATALINA_TMPDIR: /usr/local/apache-tomcat-7.0.90/temp
Using JRE_HOME:        /usr/local/jdk1.8.0_181
Using CLASSPATH:       /usr/local/apache-tomcat-7.0.90/bin/bootstrap.jar:/usr/local/apache-tomcat-7.0.90/bin/tomcat-juli.jar
Tomcat started.
[root@VM_0_15_centos bin]#
```

## Mysql5.7安装

**通过yum在线安装MySQL5.7**

### 1、检测系统是否自带安装mysql

```
# yum list installed | grep mysql
```

### 2、删除系统自带的mysql及其依赖 (没有则不需要执行此操作)

```
yum -y remove mysql-libs.x86_64
```

### 3、给CentOS添加rpm源，并且选择较新的源

- 补充：yum的服务器中包含有mysql的版本信息 ,以下命令可以查看，yum服务器默认Mysql版本为5.1版本
```
  # yum list | grep mysql
```

---

### 4、安装mysql 服务器

```
# yum install mysql-community-server
```

### 5、启动mysql

```
# service mysqld start
```

### 6、查看mysql是否自启动,并且设置开启自启动

```
# chkconfig --list | grep mysqld
# chkconfig mysqld on
```

### 7、查看root密码

```
# grep "password" /var/log/mysqld.log
2016-08-10T15:03:02.210317Z 1 [Note] A temporary password is generated for root的root的密码：root@localhost: AYB(&-3Cz-rW
```

### 8、登陆后修改密码

```
mysql> SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpass');
```

#### 可能出现以下错误

```
ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
```

若是用于测试环境，密码复杂度要求不高的情况下；解决办法：修改validate_password_policy值 ;设置validate_password_length的值：

```
mysql> set global validate_password_policy=0;
Query OK, 0 rows affected (0.00 sec)

mysql> set global validate_password_length=4;
Query OK, 0 rows affected (0.00 sec)
```

如果修改了validate_password_number_count，validate_password_special_char_count，validate_password_mixed_case_count中任何一个值，则validate_password_length将进行动态修改。

----

### 9、字符编码的设置

> 修改字符集为UTF-8：
```
vim /etc/my.cnf
```

在[mysqld]部分添加：

```
character-set-server=utf8
```

在文件末尾新增[client]段，并在[client]段添加：

```
default-character-set=utf8
```

修改好之后重启mysqld服务：

```
service mysqld restart
```

-----

**Mysql的远程连接**：Navicat软件

默认只允许localhost本机连接 mysql—server

解决方案：

- ①将user表中的host改为"%"

```
update user set host='%' where user='root';
```

- ②刷新权限

```
flush privileges 
```

- ③关闭linux的防火墙

```
service iptables stop //临时关闭数据库
chkconfig iptables off //永久关闭防火墙，开机不会自动启动
```

**Java连接Mysql**

```
url:jdbc:mysql://192.168.1.67:3306/zhj?useUnicode=true&characterEncoding=UTF-8
driverPath=com.mysql.jdbc.Driver
```

----

## Mysql5.7中的坑

### 1、Establishing SSL

>  Tue May 16 `09:00:00` CST 2017 WARN: Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false, or set useSSL=true and provide truststore for server certificate verification.

解决办法：

在mysql连接上加上&useSSL=true

如下：

```
jdbc:mysql:///:3366:test?useUnicode=true&characterEncoding=utf-8&useSSL=false(或者true)
```

ssl是一种加密技术在客户端连接数据库的中间做了加密，TCP/IP层中。

### 2、mysql 5.7.18版本 sql_mode 问题 （sql 语句执行错误）

> [Err] 1055 - Expression #1 of ORDER BY clause is not in GROUP BY clause and contains nonaggregated column 'information_schema.PROFILING.SEQ' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

> 一旦开启 `only_full_group_by` ，感觉，`group by` 将变成和 `distinct` 一样，只能获取受到其影响的字段信息，无法和其他未受其影响的字段共存，这样，`group by` 的功能将变得十分狭窄了.
>
> `only_full_group_by` 模式开启比较好。
>
> 因为在 `mysql` 中有一个函数： `any_value(field)` 允许，非分组字段的出现（和关闭 `only_full_group_by` 模式有相同效果）。

#### 1、查看sql_mode

查询出来的值为：

```
ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

#### 2、去掉ONLY_FULL_GROUP_BY，重新设置值。

```
set @@global.sql_mode ='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
```

#### 3、上面是改变了全局sql_mode，对于新建的数据库有效。对于已存在的数据库，则需要在对应的数据下执行：

```
set sql_mode ='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
```

---

小编使用以上方法解决问题，下面的方法来源于网络，仅供参考！

---

### 解决办法大致有两种

- 一、在sql查询语句中不需要group by的字段上使用any_value()函数

> 这种对于已经开发了不少功能的项目不太合适，毕竟要把原来的sql都给修改一遍

- 二、修改my.cnf（windows下是my.ini）配置文件，删掉only_full_group_by这一项

> 若我们项目的mysql安装在ubuntu上面，找到这个文件打开一看，里面并没有sql_mode这一配置项，想删都没得删。当然，还有别的办法，打开mysql命令行，执行命令

> 这样就可以查出sql_mode的值，复制这个值，在my.cnf中添加配置项（把查询到的值删掉only_full_group_by这个选项，其他的都复制过去）：

```
sql_mode=STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION;
```

> 如果 [mysqld] 这行被注释掉的话记得要打开注释。然后重重启mysql服务

> 注：使用命令

```
set sql_mode=STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
```

> 这样可以修改一个会话中的配置项，在其他会话中是不生效的。
