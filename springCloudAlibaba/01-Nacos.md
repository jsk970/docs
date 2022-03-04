# Spring cloud Alibaba Nacos 配置中心和服务注册
Nacos （Naming Configuration Service）:Nacos就是注册中心+配置中心的组合 等价于 Eureka + Config + bus。
可以代替Eureka做服务注册中心，可以代替config做配置中心

## 安装Nacos

安装步骤待完善。。。

## Nacos 作为服务注册中心
```xml
<!--nacos 服务注册核心pom-->
<dependency>
    <groupId>com.alibaba.cloud<groupId>
    <artifactId>spring-cloud-starter-alibaba-nacos-discovery<artifactId>
<dependency>
```
## 服务yaml 文件
```yaml
server:
  port: 9001
spring:
  application:
    name: nacos-payment
  cloud:
    nacos:
      discovery:
        server-addr: 127.0.0.1:8848 #nacos服务注册中心地址
management:
  endpoints:
    web:
      exposure:
        include: '*'
```

## 服务启动类
```java
//启动类添加注解 @EnableDiscoveryClient
@SpringBootApplication
@EnableDiscoveryClient
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(NacosPaymentMain9001.class,args);
    }
}
```

## Nacos 作为服务的配置中心
Nacos中配置文件的后缀名需为yaml

${spring.application.name}-${spring.profilr.active}.${spring.cloud.nacos.config.file-extension}




