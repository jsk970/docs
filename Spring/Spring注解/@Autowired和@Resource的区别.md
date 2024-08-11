# @Autowired与@Resource的区别
Spring内置的@Autowired以及JDK内置的@Resource和@Inject都可以注入Bean。

|Annotaion	|Package	|Source|
|-----------|--------------|---------|
|@Autowired|	org.springframework.bean.factory|	Spring 2.5+|
|@Resource|	javax.annotation |	Java JSR-250|
|@Inject|	javax.inject	|Java JSR-330|

## @Autowired
@Autowired属于Spring内置的注解，默认的注入方式为 byType （根据类型进行匹配），也就是说会优先根据接口类型去匹配并注入 Bean （接口的实现类）。

这会有什么问题呢？
>当一个接口存在多个实现类的话，byType这种方式就无法正确注入对象了，因为这个时候 Spring 会同时找到多个满足条件的选择，默认情况下它自己不知道选择哪一个。
>这种情况下，注入方式会变为 byName（根据名称进行匹配），这个名称通常就是类名（首字母小写）


### @Autowired 示例
假设smsService 为接口类存在两个实现类：SmsServiceImpl1和 SmsServiceImpl2，且它们都已经被 Spring 容器所管理。
```java
// 报错，byName 和 byType 都无法匹配到 bean
@Autowired
private SmsService smsService;

// 正确注入 SmsServiceImpl1 对象对应的 bean，实际是通过byName的方式注入；建议通过 @Qualifier 注解来显示指定名称而不是依赖变量的名称
@Autowired
private SmsService smsServiceImpl1;

// 正确注入  SmsServiceImpl1 对象对应的 bean；smsServiceImpl1 就是我们上面所说的名称
@Autowired
@Qualifier(value = "smsServiceImpl1")
private SmsService smsService;
```

## @Resource
@Resource属于 JDK 提供的注解，默认注入方式为 byName。如果无法通过名称匹配到对应的实现类的话，注入方式会变为byType。

### @Resource注解重要属性
@Resource 有两个比较重要且日常开发常用的属性：name（名称）、type（类型）。
```java
public @interface Resource {
    String name() default "";
    Class<?> type() default Object.class;
}
```
### 注入方式
- 默认注入方式为byName.
- 如果仅指定 name 属性则注入方式为byName。
- 如果仅指定type属性则注入方式为byType。
- 如果同时指定name 和type属性（不建议这么做）则注入方式为byType+byName。

### @Resource 示例
```java
// 报错，byName 和 byType 都无法匹配到 bean
@Resource
private SmsService smsService;

// 正确注入 SmsServiceImpl1 对象对应的 bean;实际是通过byName的方式注入
@Resource
private SmsService smsServiceImpl1;

// 正确注入 SmsServiceImpl1 对象对应的 bean（比较推荐这种方式）
@Resource(name = "smsServiceImpl1")
private SmsService smsService;
```
## 总结

- @Autowired 是 Spring 提供的注解，@Resource 是 JDK 提供的注解。
- Autowired 默认的注入方式为byType（根据类型进行匹配），@Resource默认注入方式为 byName（根据名称进行匹配）。
- 当一个接口存在多个实现类的情况下，@Autowired 和@Resource都需要通过名称才能正确匹配到对应的 Bean。Autowired 可以通过 @Qualifier 注解来显示指定名称，@Resource可以通过 name 属性来显示指定名称。

 