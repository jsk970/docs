# Spring Boot 整合 Druid
> Druid官网：https://github.com/alibaba/druid
> 
> Druid官网文档（中文）:https://github.com/alibaba/druid/wiki/%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98


## 方式一：自定义整合
### 引入 Druid 的依赖：
```xml
<dependency>
  <groupId>com.alibaba</groupId>
  <artifactId>druid</artifactId>
  <version>1.2.8</version>
</dependency>
```
### 配置数据源、监控页面的 Servlet、Filter
```java
package cn.daniel.springboot2adminstudy.config;


import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.support.http.StatViewServlet;
import com.alibaba.druid.support.http.WebStatFilter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


import javax.sql.DataSource;
import java.sql.SQLException;


/**
* 描述：  Spring Boot 手动整合 Druid 连接池
  */
  // @Deprecated
  @Configuration
  public class MyDataSourceConfig {

  /**
   *  (注意)默认是使用的java.sql.Datasource的类来获取属性的，有些属性datasource没有。如果我们想让配置生效，需要手动创建Druid的配置文件。
    * 配置 Druid 数据源。（Spring Boot 会在 IoC 容器自动读取类型为 DataSource 的对象。故这个 bean 注入后，即与Spring Boot整合好了）
    * @return DruidDataSource 数据源
    * @throws SQLException
      */
      @Bean
      @ConfigurationProperties(prefix = "spring.datasource",ignoreUnknownFields = false) // 读取配置文件中的数据源信息。Druid会以此建立数据库连接
      public DataSource dataSource() throws SQLException {
      DruidDataSource druidDataSource = new DruidDataSource();
      druidDataSource.setFilters("stat"); // 开启
      return druidDataSource;
      }

  /**
    * （非必要）开启前台监控页面对应的 Servlet，并设置密码（通过 http://域名/druid/index.html 即可访问监控页面）
    * 此 Servlet 是由 Druid 提供的 StatViewServlet
    * @return
      */
      @Bean
      public ServletRegistrationBean<StatViewServlet> druidServlet(){
      ServletRegistrationBean<StatViewServlet> statViewServletServletRegistrationBean = new ServletRegistrationBean<>(new StatViewServlet(), "/druid/*");
      statViewServletServletRegistrationBean.addInitParameter("loginUsername","root");
      statViewServletServletRegistrationBean.addInitParameter("loginPassword","131121");
      return statViewServletServletRegistrationBean;
      }

  /**
    * （非必要配置）配置Druid的Filter，用于记录 web 请求记录。
    * 此 Filter 是由 Druid 提供的 WebStatFilter
    * @return
      */
      @Bean
      public FilterRegistrationBean<WebStatFilter> druidFilter(){
      WebStatFilter webStatFilter = new WebStatFilter();
      FilterRegistrationBean<WebStatFilter> webStatFilterFilterRegistrationBean = new FilterRegistrationBean<>(webStatFilter);
      // 除以下路径的访问不记录，其它都会进行记录
      webStatFilterFilterRegistrationBean.addInitParameter("exclusions","*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");
      // 记录 session 时，记录下 session 中记录的用户名
      webStatFilterFilterRegistrationBean.addInitParameter("principalSessionName","userName");
      return webStatFilterFilterRegistrationBean;
      }
}

```

### yaml配置
```yaml
spring:
    datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost/abc
    username: root
    password: 12345678
```
整合完成，
现在直接使用 Spring IoC 容器中的 DataSource 对象或 JdbcTemplate 即可。

## 方式二：使用 Druid 官方的 Starter
引入 Druid 官方提供的 Starter（引入此 Starter 就不需要引用 Druid 依赖包了，因为已经包含 Druid 的依赖包了）：
```xml
<dependency>
  <groupId>com.alibaba</groupId>
  <artifactId>druid-spring-boot-starter</artifactId>
  <version>1.2.8</version>
</dependency>
```

### 配置数据源（或其它的非必要的插件）
```yaml
spring:
    datasource:
        # JDBC配置：
        driver-class-name: com.mysql.cj.jdbc.Driver
        url: jdbc:mysql://localhost/abc
        username: root
        password: 12345678
        # 连接池配置：
        druid:
          initial-size: 2 # 初始化时建立物理连接的个数。默认0
          max-active: 10 # 最大连接池数量，默认8
          min-idle: 1 # 最小连接池数量
          max-wait: 2000 # 获取连接时最大等待时间，单位毫秒。
          pool-prepared-statements: false # 是否缓存preparedStatement，也就是PSCache。PSCache对支持游标的数据库性能提升巨大，比如说oracle。在mysql下建议关闭。
          max-pool-prepared-statement-per-connection-size: -1 # 要启用PSCache，必须配置大于0，当大于0时，poolPreparedStatements自动触发修改为true。在Druid中，不会存在Oracle下PSCache占用内存过多的问题，可以把这个数值配置大一些，比如说100
          # ……druid节点下的其它参数见官方文档：https://github.com/alibaba/druid/wiki/DruidDataSource%E9%85%8D%E7%BD%AE%E5%B1%9E%E6%80%A7%E5%88%97%E8%A1%A8
    
          # 启用Druid内置的Filter，会使用默认的配置。可自定义配置，见下方的各个filter节点。
          filters: stat,wall
          # StatViewServlet监控器。开启后，访问http://域名/druid/index.html
          stat-view-servlet:
            enabled: true # 开启 StatViewServlet，即开启监控功能
            login-username: daniel # 访问监控页面时登录的账号
            login-password: 1234 # 密码
            url-pattern: /druid/* # Servlet的映射地址，不填写默认为"/druid/*"。如填写其它地址，访问监控页面时，要使用相应的地址
            reset-enable: false # 是否允许重置数据（在页面的重置按钮）。（停用后，依然会有重置按钮，但重置后不会真的重置数据）
            allow: 192.168.1.2,192.168.1.1 # 监控页面访问白名单。默认为127.0.0.1。与黑名单一样，支持子网掩码，如128.242.127.1/24。多个ip用英文逗号分隔
            deny: 18.2.1.3 # 监控页面访问黑名单
          # 配置 WebStatFilter（StatFilter监控器中的Web模板）
          web-stat-filter:
            enabled: true # 开启 WebStatFilter，即开启监控功能中的 Web 监控功能
            url-pattern: /* # 映射地址，即统计指定地址的web请求
            exclusions: '*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*' # 不统计的web请求，如下是不统计静态资源及druid监控页面本身的请求
            session-stat-enable: true # 是否启用session统计
            session-stat-max-count: 1 # session统计的最大个数，默认是1000。当统计超过这个数，只统计最新的
            principal-session-name: userName # 所存用户信息的serssion参数名。Druid会依照此参数名读取相应session对应的用户名记录下来（在监控页面可看到）。如果指定参数不是基础数据类型，将会自动调用相应参数对象的toString方法来取值
            principal-cookie-name: userName # 与上类似，但这是通过Cookie名取到用户信息
            profile-enable: true # 监控单个url调用的sql列表（试了没生效，以后需要用再研究）
          filter:
            wall:
              enabled: true  # 开启SQL防火墙功能
              config:
                select-allow: true # 允许执行Select查询操作
                delete-allow: false # 不允许执行delete操作
                create-table-allow: false # 不允许创建表
                # 更多用法，参考官方文档：https://github.com/alibaba/druid/wiki/%E9%85%8D%E7%BD%AE-wallfilter

```
## 检查整合情况
可通过以下测试方法，查看当前数据源
```java

package cn.daniel.springboot2adminstudy;

//import com.alibaba.druid.pool.DruidDataSource;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@SpringBootTest
@Slf4j
class Springboot2AdminStudyApplicationTests {

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Autowired
    DataSource dataSource;
    @Test
    void contextLoads() {
      // 执行一条sql语句，检查是否正常
        List<Map<String, Object>> maps = jdbcTemplate.queryForList("select * from adm_employee");
        for (Map<String, Object> map : maps) {
            System.out.println(map);
        }

      // 查看当前数据源，如果是Druid连接池，会出现下面两种提示的其中一种：
      // 1. 当使用Starter整合的：当前数据源：com.alibaba.druid.spring.boot.autoconfigure.DruidDataSourceWrapper
			// 2. 当使用自定义整合时：当前数据源：com.alibaba.druid.pool.DruidDataSource
        log.info("当前数据源：{}",dataSource.getClass().getName());
    }

}
```



