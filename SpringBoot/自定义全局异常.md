# springboot 异常处理
> 关键字、 全局异常 、自定义异常 、自定义异常信息内容
## 1、自定义异常类

```java
package com.example.learning.common.exception;

import lombok.Data;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.lang3.StringUtils;

/**
 * @author solin.jiang
 * 2020-12-02 14:20
 * 自定义异常
 */
@Data
public class LearningException extends RuntimeException {

    /**
     * 错误码
     */
    protected String errorCode;
    /**
     * 错误信息
     */
    protected String[] errorMsg;

    /**
     * 根据key构造带参数或不带参数的异常信息
     * @param key
     * @param values
     */
    public LearningException(String key, String... values) {
        this.errorCode = key;
        this.errorMsg = values;
    }

}
```
## 2、定义异常处理handler

```java
package com.example.learning.common.exception;

import com.example.learning.common.ResultVo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.text.MessageFormat;
import java.util.Locale;


/**
 * @author solin.jiang
 * 全局异常处理
 * 2020-12-02 14:15
 *
 * 
 *
 * SpringBoot中有一个@ControllerAdvice的注解，使用该注解表示开启了全局异常的捕获，
 * 只需在自定义一个方法使用@ExceptionHandler注解然后定义捕获异常的类型即可对这些捕获的异常进行统一的处理。
 * 但是还要得加上@ResponseBody注解，所以使用的是@RestControllerAdvice注解
 *
 * MessageFormat.format()可以实现this is {0},{1} demo. 格式模板
 */
@Slf4j
@RestControllerAdvice
public class BaseExceptionHandler {
    /**
     * 项目开发过程中的提示文字信息可以在资源文件中进行定义，而且资源文件是实现国际化技术的主要手段。
     * 如果想在SpringBoot里面进行资源文件的配置，只需要做一些简单的application.yml配置即可，
     * 而且所有注入的资源文件都可以像最初的Spring处理那样，直接使用MessageSource进行读取。
     *
     */
    @Autowired
    private MessageSource messageSource;

    /**
     * 处理自定义的业务异常
     * @param e
     * @return ResultVo
     */
    @ExceptionHandler(value = LearningException.class)
    public ResultVo LearningExceptionHandler(LearningException e){
        String message = messageSource.getMessage(e.getErrorCode(), null, Locale.getDefault());
        String format = MessageFormat.format(message, e.getErrorMsg());
        return ResultVo.error(format);
    }

}
```
## 3、添加配置

```yaml
# 定义资源文件，多个资源文件使用逗号进行分割
spring:
  messages:
    basename: exception/error
    encoding: UTF-8
```
## 4、resource目录下创建error.properties
```properties
system.exception.500=系统异常{0}，{1}
```