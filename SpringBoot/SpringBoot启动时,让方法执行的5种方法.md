# Spring Boot 启动时，让方法自动执行的 5 种方法

## 1、实现ServletContextAware接口并重写其setServletContext方法
```java
@Component
public class TestStarted implements ServletContextAware {
    /**
     * 在填充普通bean属性之后但在初始化之前调用
     * 类似于initializingbean的afterpropertiesset或自定义init方法的回调
     *
     */
    @Override
    public void setServletContext(ServletContext servletContext) {
        System.out.println("setServletContext方法");
    }
}

```
>注意：该方法会在填充完普通Bean的属性，但是还没有进行Bean的初始化之前执行。

## 2、实现ServletContextListener接口

```java
/**
 * 在初始化Web应用程序中的任何过滤器或servlet之前，将通知所有servletContextListener上下文初始化。
 */
@Override
public void contextInitialized(ServletContextEvent sce) {
        //ServletContext servletContext = sce.getServletContext();
        System.out.println("执行contextInitialized方法");
}

```
## 3、将要执行的方法所在的类交个spring容器扫描(@Component),并且在要执行的方法上添加@PostConstruct注解或者静态代码块执行
```java

@Component
public class Test2 {
    //静态代码块会在依赖注入后自动执行,并优先执行
    static{
        System.out.println("---static--");
    }
    /**
     *  @Postcontruct’在依赖注入完成后自动调用
     */
    @PostConstruct
    public static void haha(){
        System.out.println("@Postcontruct’在依赖注入完成后自动调用");
    }
}

```  
       
## 4、实现ApplicationRunner接口
```java
/**
 * 用于指示bean包含在SpringApplication中时应运行的接口。可以定义多个applicationrunner bean
 * 在同一应用程序上下文中，可以使用有序接口或@order注释对其进行排序。
 */
@Override
public void run(ApplicationArguments args) throws Exception {
        System.out.println("ApplicationRunner的run方法");
}

```
## 5、实现CommandLineRunner接口

```java
/**
* 用于指示bean包含在SpringApplication中时应运行的接口。可以在同一应用程序上下文中定义多个commandlinerunner bean，并且可以使用有序接口或@order注释对其进行排序。
* 如果需要访问applicationArguments而不是原始字符串数组，请考虑使用applicationrunner。
*
*/
@Override
public void run(String... ) throws Exception {
    System.out.println("CommandLineRunner的run方法");
}
```  
