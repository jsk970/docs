# 注解

> 什么是注解（Annotation）？注解是放在Java源码的类、方法、字段、参数前的一种特殊“注释”.

## 定义注解

> Java语言使用@interface语法来定义注解（Annotation）

## 元注解
> 有一些注解可以修饰其他注解，这些注解就称为元注解（meta annotation）。Java标准库已经定义了一些元注解，我们只需要使用元注解，通常不需要自己去编写元注解。

### @Target
> @Target可以定义Annotation能够被应用于源码的哪些位置。

- 类或接口：ElementType.TYPE；
- 字段：ElementType.FIELD；
- 方法：ElementType.METHOD；
- 构造方法：ElementType.CONSTRUCTOR；
- 方法参数：ElementType.PARAMETER。

### @Retention
> @Retention定义了Annotation的生命周期。

- 仅编译期：RetentionPolicy.SOURCE；
- 仅class文件：RetentionPolicy.CLASS；
- 运行期：RetentionPolicy.RUNTIME。

### @Repeatable
> @Repeatable这个元注解可以定义Annotation是否可重复。
```java
@Repeatable(Reports.class)
@Target(ElementType.TYPE)
public @interface Report {
    int type() default 0;
    String level() default "info";
    String value() default "";
}

@Target(ElementType.TYPE)
public @interface Reports {
    Report[] value();
}
```
> 经过@Repeatable修饰后，在某个类型声明处，就可以添加多个@Report注解
```java
@Report(type=1, level="debug")
@Report(type=2, level="warning")
public class Hello {
}
```

### @Inherited
> @Inherited定义子类是否可继承父类定义的Annotation。@Inherited仅针对@Target(ElementType.TYPE) (类或接口)类型的annotation有效，并且仅针对class的继承，对interface的继承无效
```java
@Inherited
@Target(ElementType.TYPE)
public @interface Report {
    int type() default 0;
    String level() default "info";
    String value() default "";
}
```
在使用的时候，如果一个类用到了@Report：
```java
@Report(type=1)
public class Person {
}
```

则它的子类默认也定义了该注解：
```java
public class Student extends Person {
}
```

## 注解的处理

### 反射获取注解

#### 反射
```
//获取该类
Class<?> clz = object.getClass();
Class stuClass = Class.forName("pojos.Student");
// 获取实体类的所有属性，返回Field数组
Field[] fields = clz.getDeclaredFields();
//获取类中的方法
Method[] method=clazz.getDeclaredMethods();
//获取类的构造方法
Constructor[] constructor=clazz.getDeclaredConstructors();
```


Java提供的使用反射API读取Annotation的方法包括：

判断某个注解是否存在于Class（类）、Field（字段）、Method（方法）或Constructor（构造器）：
```
Class.isAnnotationPresent(Class)
Field.isAnnotationPresent(Class)
Method.isAnnotationPresent(Class)
Constructor.isAnnotationPresent(Class)
```

### 自定义注解+AOP 
- @annotation表示这个切点切到一个注解

```java
@Component
@Aspect // 1.表明这是一个切面类
public class MyLogAspect {

    // 2. PointCut表示这是一个切点，@annotation表示这个切点切到一个注解上，后面带该注解的全类名
    // 切面最主要的就是切点，所有的故事都围绕切点发生
    // logPointCut()代表切点名称
    @Pointcut("@annotation(me.zebin.demo.annotationdemo.aoplog.MyLog)")
    public void logPointCut(){};

    // 3. 环绕通知
    @Around("logPointCut()")
    public void logAround(ProceedingJoinPoint joinPoint){
        // 获取方法名称
        String methodName = joinPoint.getSignature().getName();
        // 获取入参
        Object[] param = joinPoint.getArgs();

        StringBuilder sb = new StringBuilder();
        for(Object o : param){
            sb.append(o + "; ");
        }
        System.out.println("进入[" + methodName + "]方法,参数为:" + sb.toString());

        // 继续执行方法
        try {
            joinPoint.proceed();
        } catch (Throwable throwable) {
            throwable.printStackTrace();
        }
        System.out.println(methodName + "方法执行结束");

    }
}
```








