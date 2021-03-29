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













