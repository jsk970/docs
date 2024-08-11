# SpringBoot高级特性 - 参数校验

## 简单使用

Java API规范 (JSR303) 定义了Bean校验的标准validation-api，但没有提供实现。hibernate validation是对这个规范的实现，并增加了校验注解如@Email、@Length等。
Spring Validation是对hibernate validation的二次封装，用于支持spring mvc参数自动校验。

对于web服务来说，为防止非法参数对业务造成影响，在Controller层一定要做参数校验的！大部分情况下，请求参数分为如下两种形式：
- POST、PUT请求，使用requestBody传递参数；
- GET请求，使用requestParam/PathVariable传递参数。

### 引入依赖
如果spring-boot版本小于2.3.x，spring-boot-starter-web会自动传入hibernate-validator依赖。如果spring-boot版本大于2.3.x，则需要手动引入依赖：
```xml
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>6.0.1.Final</version>
</dependency>
```

### @RequestBody参数校验

POST、PUT请求一般会使用requestBody传递参数，这种情况下，后端使用 DTO 对象进行接收。只要给 DTO 对象加上@Validated注解就能实现自动参数校验。
比如，有一个保存User的接口，要求userName长度是2-10，account和password字段长度是6-20。如果校验失败，会抛出MethodArgumentNotValidException异常，Spring默认会将其转为400（Bad Request）请求。
DTO 表示数据传输对象（Data Transfer Object），用于服务器和客户端之间交互传输使用的。在 spring-web 项目中可以表示用于接收请求参数的Bean对象。

在DTO字段上声明约束注解
```java
@Data
public class UserDTO {

    private Long userId;

    @NotNull
    @Length(min = 2, max = 10)
    private String userName;

    @NotNull
    @Length(min = 6, max = 20)
    private String account;

    @NotNull
    @Length(min = 6, max = 20)
    private String password;
}
```

在方法参数上声明校验注解
```
@PostMapping("/save")
public Result saveUser(@RequestBody @Validated UserDTO userDTO) {

    return Result.ok();
}
```
这种情况下，使用@Valid 和 @Validated都可以。

### @RequestParam/@PathVariable参数校验

GET请求一般会使用@RequestParam/@PathVariable传参。如果参数比较多 (比如超过 6 个)，还是推荐使用DTO对象接收。
否则，推荐将一个个参数平铺到方法入参中。在这种情况下，必须在Controller类上标注@Validated注解，并在入参上声明约束注解 (如@Min等)。
如果校验失败，会抛出ConstraintViolationException异常。代码示例如下：

```java
@RequestMapping("/api/user")  
@RestController  
@Validated  
public class UserController {

    @GetMapping("{userId}")  
    public Result detail(@PathVariable("userId") @Min(10000000000000000L) Long userId) {  
  
        UserDTO userDTO = new UserDTO();  
        userDTO.setUserId(userId);  
        userDTO.setAccount("11111111111111111");  
        userDTO.setUserName("xixi");  
        userDTO.setAccount("11111111111111111");  
        return Result.ok(userDTO);  
    }  
  
    @GetMapping("getByAccount")  
    public Result getByAccount(@Length(min = 6, max = 20) @NotNull String  account) {  
  
        UserDTO userDTO = new UserDTO();  
        userDTO.setUserId(10000000000000003L);  
        userDTO.setAccount(account);  
        userDTO.setUserName("xixi");  
        userDTO.setAccount("11111111111111111");  
        return Result.ok(userDTO);  
    }  
}  
```
### 统一异常处理

前面说过，如果校验失败，会抛出MethodArgumentNotValidException或者ConstraintViolationException异常。
在实际项目开发中，通常会用统一异常处理来返回一个更友好的提示。比如我们系统要求无论发送什么异常，http的状态码必须返回200，由业务码去区分系统的异常情况。
```java

@RestControllerAdvice  
public class CommonExceptionHandler {

    @ExceptionHandler({MethodArgumentNotValidException.class})  
    @ResponseStatus(HttpStatus.OK)  
    @ResponseBody  
    public Result handleMethodArgumentNotValidException(MethodArgumentNotValidException ex) {  
        BindingResult bindingResult = ex.getBindingResult();  
        StringBuilder sb = new StringBuilder("校验失败:");  
        for (FieldError fieldError : bindingResult.getFieldErrors()) {  
            sb.append(fieldError.getField()).append("：").append(fieldError.getDefaultMessage()).append(", ");  
        }  
        String msg = sb.toString();  
       return Result.fail(BusinessCode.参数校验失败, msg);  
    }  
  
    @ExceptionHandler({ConstraintViolationException.class})  
    @ResponseStatus(HttpStatus.OK)  
    @ResponseBody  
    public Result handleConstraintViolationException(ConstraintViolationException ex) {  
        return Result.fail(BusinessCode.参数校验失败, ex.getMessage());  
    }  
}  
```
## 进阶使用

### 分组校验

在实际项目中，可能多个方法需要使用同一个DTO类来接收参数，而不同方法的校验规则很可能是不一样的。
这个时候，简单地在DTO类的字段上加约束注解无法解决这个问题。因此，spring-validation支持了分组校验的功能，专门用来解决这类问题。
还是上面的例子，比如保存User的时候，UserId是可空的，但是更新User的时候，UserId的值必须>=10000000000000000L；其它字段的校验规则在两种情况下一样。这个时候使用分组校验的代码示例如下：
约束注解上声明适用的分组信息groups
```java
@Data
public class UserDTO {

    @Min(value = 10000000000000000L, groups = Update.class)
    private Long userId;

    @NotNull(groups = {Save.class, Update.class})
    @Length(min = 2, max = 10, groups = {Save.class, Update.class})
    private String userName;

    @NotNull(groups = {Save.class, Update.class})
    @Length(min = 6, max = 20, groups = {Save.class, Update.class})
    private String account;

    @NotNull(groups = {Save.class, Update.class})
    @Length(min = 6, max = 20, groups = {Save.class, Update.class})
    private String password;

    public interface Save {
    }

    public interface Update {
    }
}
```
### @Validated注解上指定校验分组
```
@PostMapping("/save")
public Result saveUser(@RequestBody @Validated(UserDTO.Save.class) UserDTO userDTO) {

        return Result.ok();
        }

@PostMapping("/update")
public Result updateUser(@RequestBody @Validated(UserDTO.Update.class) UserDTO userDTO) {

        return Result.ok();
}
```
### 嵌套校验

前面的示例中，DTO类里面的字段都是基本数据类型和String类型。但是实际场景中，有可能某个字段也是一个对象，这种情况先，可以使用嵌套校验。
比如，上面保存User信息的时候同时还带有Job信息。需要注意的是，此时DTO类的对应字段必须标记@Valid注解。
```java

@Data  
public class UserDTO {

    @Min(value = 10000000000000000L, groups = Update.class)  
    private Long userId;  
  
    @NotNull(groups = {Save.class, Update.class})  
    @Length(min = 2, max = 10, groups = {Save.class, Update.class})  
    private String userName;  
  
    @NotNull(groups = {Save.class, Update.class})  
    @Length(min = 6, max = 20, groups = {Save.class, Update.class})  
    private String account;  
  
    @NotNull(groups = {Save.class, Update.class})  
    @Length(min = 6, max = 20, groups = {Save.class, Update.class})  
    private String password;  
  
    @NotNull(groups = {Save.class, Update.class})  
    @Valid  
    private Job job;  
  
    @Data  
    public static class Job {  
  
        @Min(value = 1, groups = Update.class)  
        private Long jobId;  
  
        @NotNull(groups = {Save.class, Update.class})  
        @Length(min = 2, max = 10, groups = {Save.class, Update.class})  
        private String jobName;  
  
        @NotNull(groups = {Save.class, Update.class})  
        @Length(min = 2, max = 10, groups = {Save.class, Update.class})  
        private String position;  
    }  
  
    public interface Save {  
    }  
  
    public interface Update {  
    }  
}  
```
嵌套校验可以结合分组校验一起使用。还有就是嵌套集合校验会对集合里面的每一项都进行校验，例如List<Job>字段会对这个list里面的每一个Job对象都进行校验。
### 集合校验

如果请求体直接传递了json数组给后台，并希望对数组中的每一项都进行参数校验。此时，如果我们直接使用java.util.Collection下的list或者set来接收数据，参数校验并不会生效！我们可以使用自定义list集合来接收参数：
包装List类型，并声明@Valid注解
```java

public class ValidationList<E> implements List<E> {

    @Delegate  
    @Valid  
    public List<E> list = new ArrayList<>();  
  
    @Override  
    public String toString() {  
        return list.toString();  
    }  
}  
```
@Delegate注解受lombok版本限制，1.18.6以上版本可支持。如果校验不通过，会抛出NotReadablePropertyException，同样可以使用统一异常进行处理。
比如，我们需要一次性保存多个User对象，Controller层的方法可以这么写：
```
@PostMapping("/saveList")  
public Result saveList(@RequestBody @Validated(UserDTO.Save.class) ValidationList<UserDTO> userList) {

    return Result.ok();  
}  
```
### 自定义校验

业务需求总是比框架提供的这些简单校验要复杂的多，我们可以自定义校验来满足我们的需求。自定义spring validation非常简单，假设我们自定义加密id（由数字或者a-f的字母组成，32-256长度）校验，主要分为两步：
自定义约束注解
```java
@Target({METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER})
@Retention(RUNTIME)
@Documented
@Constraint(validatedBy = {EncryptIdValidator.class})
public @interface EncryptId {

    String message() default "加密id格式错误";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
```
实现ConstraintValidator接口编写约束校验器
```java
public class EncryptIdValidator implements ConstraintValidator<EncryptId, String> {

    private static final Pattern PATTERN = Pattern.compile("^[a-f\\d]{32,256}$");

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {

        if (value != null) {
            Matcher matcher = PATTERN.matcher(value);
            return matcher.find();
        }
        return true;
    }
}
```
这样我们就可以使用@EncryptId进行参数校验了！
### 编程式校验

上面的示例都是基于注解来实现自动校验的，在某些情况下，我们可能希望以编程方式调用验证。这个时候可以注入javax.validation.Validator对象，然后再调用其api。
```
@Autowired  
private javax.validation.Validator globalValidator;

@PostMapping("/saveWithCodingValidate")  
public Result saveWithCodingValidate(@RequestBody UserDTO userDTO) {  
Set<ConstraintViolation<UserDTO>> validate = globalValidator.validate(userDTO, UserDTO.Save.class);

    if (validate.isEmpty()) {  
  
    } else {  
        for (ConstraintViolation<UserDTO> userDTOConstraintViolation : validate) {  
  
            System.out.println(userDTOConstraintViolation);  
        }  
    }  
    return Result.ok();  
}  
```
### 快速失败 (Fail Fast)

Spring Validation默认会校验完所有字段，然后才抛出异常。可以通过一些简单的配置，开启Fali Fast模式，一旦校验失败就立即返回。
```
@Bean
public Validator validator() {
        ValidatorFactory validatorFactory = Validation.byProvider(HibernateValidator.class)
        .configure()
        .failFast(true)
        .buildValidatorFactory();
        return validatorFactory.getValidator();
}
```
@Valid和@Validated区别
- @Validated：用在方法入参上无法单独提供嵌套验证功能。不能用在成员属性（字段）上，也无法提示框架进行嵌套验证。能配合嵌套验证注解@Valid进行嵌套验证。
- @Valid：用在方法入参上无法单独提供嵌套验证功能。能够用在成员属性（字段）上，提示验证框架进行嵌套验证。能配合嵌套验证注解@Valid进行嵌套验证。

实际上，不管是requestBody参数校验还是方法级别的校验，最终都是调用Hibernate Validator执行校验，Spring Validation只是做了一层封装。