# mybatis plus 分页查询 left join 子查询参数无法找到报错

```sql
SELECT
*
FROM a
LEFT JOIN ( SELECT * FROM b WHERE #{condition} ) b
```
在自定义分页SQL中进行letf join语句查询报错,假如有3个#{}参数,一个在left join中，
最终会报java.sql.SQLException: Parameter index out of range 实际参数有3个，在SQL中只找到2个#{}
```shell
org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.type.TypeException: Could not set parameters for mapping: ParameterMapping{property='__frch_id_16', mode=IN, javaType=class java.lang.String, jdbcType=null, numericScale=null, resultMapId='null', jdbcTypeName='null', expression='null'}. Cause: org.apache.ibatis.type.TypeException: Error setting non null for parameter #18 with JdbcType null . Try setting a different JdbcType for this parameter or a different configuration property. Cause: java.sql.SQLException: Parameter index out of range (18 > number of parameters, which is 17).
	at org.mybatis.spring.MyBatisExceptionTranslator.translateExceptionIfPossible(MyBatisExceptionTranslator.java:92) ~[mybatis-spring-2.0.5.jar:2.0.5]
	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:440) ~[mybatis-spring-2.0.5.jar:2.0.5]
	at com.sun.proxy.$Proxy156.selectList(Unknown Source) ~[na:na]


Caused by: org.apache.ibatis.type.TypeException: Could not set parameters for mapping: ParameterMapping{property='__frch_id_16', mode=IN, javaType=class java.lang.String, jdbcType=null, numericScale=null, resultMapId='null', jdbcTypeName='null', expression='null'}. Cause: org.apache.ibatis.type.TypeException: Error setting non null for parameter #18 with JdbcType null . Try setting a different JdbcType for this parameter or a different configuration property. Cause: java.sql.SQLException: Parameter index out of range (18 > number of parameters, which is 17).
	at com.baomidou.mybatisplus.core.MybatisParameterHandler.setParameters(MybatisParameterHandler.java:215) ~[mybatis-plus-core-3.4.1.jar:3.4.1]
	at org.apache.ibatis.executor.statement.PreparedStatementHandler.parameterize(PreparedStatementHandler.java:94) ~[mybatis-3.5.6.jar:3.5.6]
	at or


```

Mybatis-plus 分页插件的问题。分页SQL中left join 中进行子查询参数无法找到 会报错
## 解决方法
- 关闭page 参数的sql优化
- 将#{}替换为${} 不会报错
- RIGHT JOIN 或者 INNER JOIN 不会触发此问题


