## 1、关于服务发现

在微服务架构中，服务发现（Service Discovery）是关键原则之一。手动配置每个客户端或某种形式的约定是很难做的，并且很脆弱。Spring Cloud提供了多种服务发现的实现方式，例如：Eureka、Consul、Zookeeper。

>Spring Cloud支持得最好的是Eureka，其次是Consul，最次是Zookeeper。



## 2、多实例启动
通过指定不同的配置文件，实现不同端口，多实例的启动
- -Dspring.profiles.active=peer1
- -Dspring.profiles.active=peer2