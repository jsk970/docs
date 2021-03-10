# Oracle基础

```sql
--连接数据库(若是当前已经有用户连接了数据库，那么将会中断当前的连接)
conn[ect] [<username>/<password>]
--解锁Scott用户名设置Scott用户的密码为123
alert user scott identified by 123 account unlock;
--SET命令是SQL*Plus内部命令中最重要、使用频率最高的命令
set pagesize 20
--为了查看命令所消耗的系统时间，可以设置TIMING选项为ON
set timing on;
--命令提示符前显示当前系统的时间
set time on;
--describe命令，查看列出其各个列的名称以及属性
desc 表名;
--使用spool命令生成employees.txt文件，并将查询结果保存至该文件
spool d:\employees.txt
```

- 带有中文的字符串日期转换成日期格式
  ```sql
  select to_date('2015年2月15日','yyyy"年"mm"月"dd"日"') from dual;--结果2015/02/15
  select to_date('2015年2月15日','yyyy-MM--dd') from dual;--Error
  ```

## 一、Oracle前置知识：

- 1、相关服务启动： 运行 > services.msc
    - OracleServiceXE（ORCL）：Oracle主（核心）服务，开启后才可通过本机访问数据库。
    
    - OracleXE（oraDb11g_home1）TNSListener：Oracle监听服务，对外提供连接访问，开启后才可通过应用程序或其他客户端进行访问。


- 2、解锁HR用户：
  ```sql
  sqlplus /nolog > conn sys as sysdba > alteruser hr identified by 密码 account unlock;
  ```
  登录：C: sqlplus hr/123456
  
  登录：SQL> conn hr > 123456
  
  查当前用户下的表：

  ```sql
  select table_name from user_tables;
  ```

- 3、设置hr用户会话特权和操作权限：
  > user test lacks create sessionprivilege logon denied  缺少特权
  
  ```sql
  grantconnect to hr;
  grantresource to hr;
  grantcreate session to hr;
   ```
## 一、现有数据的存储：

1.    Java存储数据的方式（变量、数组、对象、集合），存储在内存中，称为瞬时存储、临时存储。
2.    IO操作文件（File）：存储在硬盘上，持久化存储。
>缺点： 1、 没有数据类型。 2、没有访问安全性。 3、存储数据容量太小。 4、没有备份、恢复机制。

## 二、数据库管理系统（Database Management System）

1.    网状结构数据库：节点形式
2.    层次结构数据库：树状结构
3.    关系结构数据库：表格存储（Table：Row、Column）
4.    非关系型数据库：Redis、MongDB

## 三、Oracle数据库：

1.    Oracle服务器：RDBMS（Relationship），对外提供服务（增、删、改、查）
2.    启动服务：Services.msc
      I.     OracleServiceXE（Orcl）：数据库核心服务（实例），开启之后可通过本机SQL*Plus进行访问。
      II.    OracleXETNSListener：Oracle监听服务，对外提供链接访问，包含Oracle访问客户端（Navicat、PLSQL）通过远程形式访问。
3.    Oracle客户端：
      I.     SQL Plus：DOS界面窗口，本地访问。
      II.    iSQL Plus：Web界面。
      III.   PLSQL：Oracle集成开发工具。
4.    Oracle数据库管理员：DBA（sys、system）

## 四、结构化查询语言（Structured Query Language）：用于存储数据、更新、查询的程序设计语言。

## 五、数据查询：

1).   查询部分列：

查询员工表中所有员工编号、名字、邮箱。
```sql
select employee_id , first_name , email
from employees;
```

2).   查询所有列：
查询员工表中所有员工的所有信息。
```sql
 select * from employees;                     
```
注意：生产环境中，建议使用列名（效率高）。

3).   对列中数据的运算：+ - * / （%：通配符）
查询编号、名字、年薪
```sql
select employee_id , first_name , salary * 12
from employees;
```

4).   列的别名：列 as "别名"
查询编号、名字、年薪
```sql
select employee_id as "编号" , first_name as "名字" , salary * 12 as "年薪" from employees;
```

5).   拼接字符串：字符串1 || 字符串2
查询编号和“姓名”（first_name || last_name）
```sql
 select employee_id , first_name || '.' || last_name as "姓名" from employees;
```
注意：SQL中字符或字符串是使用 ' （单引号）表示，查询结果中的字符串拼接使用 || 和 '字符串'，"本文"应用在别名。

6).   查询结果去重：（单列中，重复结果只保留一个）
查询所有经理的ID
```sql
select distinct manager_id from employees;
```

2.    排序：对查询后的数据进行排序。
I.     语法：select ... from ... order by 排序列
II.    详解：order by 排序列 [asc] [desc] 默认升序
III.   用例：

       1).   依据单列排序：

查询员工的编号，名字，薪资。按照工资高低进行升序排序。

```sql
 select employee_id , first_name , salary
 from employees order by salary desc;
```

                     2).   依据多列排序：

查询员工的编号，名字，薪资。按照工资高低进行升序排序（薪资相同时，按照编号进行升序排序）。

```sql
select employee_id , first_name , salary
from employees order bysalary asc , employee_id asc
```

       3.    条件查询：筛选符合条件的结果。

              I.     语法：select... from ... where 布尔表达式

              II.    详解：where布尔表达式 //可执行条件筛选

              III.   用例：

1).   等值判断（=）：

查询薪资是11000的员工信息（编号、名字、薪资）

```sql
select employee_id , first_name , salary
from employees
where salary = 11000;
```

注意：与Java不同，SQL中的"="代表表达式左右的两值相等

2).   多条件查询（and、or、not）：

查询薪资是11000并且提成是0.30的员工信息（编号、名字、薪资）

```sql
select *
from employees
where salary = 11000 or commission_pct = 0.30

```

3).   不等值判断：（>、<、>=、<=、!=、<>）

查询员工的薪资在6000~10000之间的员工信息（编号，名字，薪资）

```sql
select *
from employees
where salary >= 6000 and salary <= 10000;
```

查询员工的薪资不是24000员工信息

```sql
select *
from employees
where salary <> 24000;
```

4).   区间判断（betweenand）：

查询员工的薪资在6000~10000之间的员工信息（编号，名字，薪资）

```sql
select *
from employees where salary between 6000 and 10000;
```

5).   null值判断：DBNull（is null、is not null）

查询没有提成的员工信息（编号，名字，薪资 , 提成）

```sql
select *
from employees
where commission_pct is not null;
```

6).   枚举判断（in(v1,v2,v3,...)）：

查询部门编号为70、80、90的员工信息（编号，名字，薪资, 部门编号）

```sql
select *
from employees
where department_id in(70,80,90);
```

7).   模糊查询：（%：任意长度的任意字符； _：长度为1的任意字符）

查询名字以"L"开头的员工信息（编号，名字，薪资 , 部门编号）

```sql
select *
from employees
where first_name like 'L%' ;
```

查询名字以"L"开头并且长度为4的员工信息（编号，名字，薪资 , 部门编号）
```sql
select *
from employees
where first_name like 'L___';
```
4.    时间查询：
- 语法：select系统时间 from 表名[虚表]
- 详解：
   - sysdate：当前系统时间（年、月、日、时、分、秒、星期、上下午），常见格式。
   - systimestamp：当前系统时间（年、月、日、时、分、秒、毫秒），默认格式
   - dual表：虚表（一行一列），保证查询语句完整性。

查询当前系统时间
```sql
select sysdate from dual;
select systimestamp from dual;
```

5.    单行函数：

- 语法：select单行函数(列名) from 表名
- 详解： 
  - to_char( 日期 , '日期格式' )：将日期通过指定格式进行字符串转换。
  - to_date( 字符串 , '日期格式' )：将字符串通过指定格式进行日期转换。

1).   日期转字符串：
将当前系统时间转换成（yyyy-mm-dd hh:mi:ss day）格式。

```sql
select to_char(sysdate , 'yyyy-mm-dd hh:mi:ssday')fromdual;

```

2).   字符串转日期：
将和日期兼容的字符串按照（yyyy-mm-dd hh24:mi:ss:ff day）转换成日期。

```sql
select to_date('19950101','yyyy-mm-dd') fromdual;
```

3).   查询2008.08.08是星期几？

 1.获得代表这个时间的日期对象
```sql
select to_date('2008/8/8','yyyy/mm/dd') from dual;--日期
```
2.获得该对象的"星期"组成部分

```sql
select to_char( to_date('2008/8/8','yyyy/mm/dd') , 'yyyy-mm-dd day')from dual;
```

4).   中文格式的日期转换
```sql
select to_date('2015年2月15日','yyyy-mm--dd')from dual;     --Error
select to_date('2015年2月15日','yyyy"年"mm"月"dd"日"') from dual;       --结果2015/02/15
```

5).   mod(被除数 , 除数)：模运算，求余数
```sql
select mod(5,3)  from dual;
select mod(salary,10000) from employees;
```

为107行数据的salary列，进行取余的调用，结果为107行

6.    聚合函数（组函数）：对表中数据进行统计，并返回统计后的结果（往往都是一行数据）。
- 语法：select聚合函数(列名) from 表名

- 详解： 
  - sum()：求和 
  - avg()：平均数
  - max()：最大值
  - min()：最小值
  - count()：总行数、计数器

7.    分组查询：
- 语法：select... from ... where ... group by 分组依据
- 详解：分组依据（列） //此列具有几个不同值，及分为几组



8.  分组过滤：

- 语法：select... from ... where ... group by ... having 过滤规则
- 详解：过滤规则（分组后的数据进行筛选）

>注意：where可判断表中存在的列（未分组前数据），having可判断表中不存在的列（聚合函数统计出来的列）。

9.    SQL顺序：

- 书写顺序：select... from ... where ... group by ... having ... order by [asc|desc]
-  执行顺序：
   - from：数据来源
   - where：首次过滤
   - group by：分组
   - having：二次过滤
   - select：选取需展示的列
   - order by：排序

10.  伪列：虚列，在原表中不存在的列，

- 语法：select伪列 from 表名
- 详解：
  - rowid【了解】：一行数据唯一的物理标识。file# block# row# //Oracle内部优化器
  - rownum【重要】：为查询出每一行数据进行逻辑编号 //必须从1开始生成，依次递增1
  

基于rowid进行一行数据的查询（速度快）
```sql
select *
from employees
where rowid ='AAAC9EAAEAAAABXAAA';
```

查询所有列和rowid（表别名 e ，不允许使用as）
```sql
select e.* , rowid from employees e

```

查询员工表中前5名员工信息（编号，名字，薪资）
```sql
select e.* ,rownum 
from employeese
where rownum<= 5
```

查询员工表中第6名之后员工信息（编号，名字，薪资）
```sql
select e.* ,rownum
from employeese
where rownum > 6;
```

>注意：rownum总是从1开始生成，原生rownum只能在 <= 的环境下使用，无法直接应用在 >= 的环境下

查询员工表中工资排名前5员工的信息（编号，名字，薪资）
>思路： 1).   先将表中数据进行依次降序排序 2).   在有序的表中，进行rownum的生成 3).   在对有编号的表，进行条件的筛选
原因：order by 在where之后生效

11.  子查询：嵌套查询

- 语法：与查询相同。
- 详解：
  - 将子查询"一行一列"的结果作为条件判断完成第二次（外层）查询。
  - 将子查询"多行一列"的结果作为枚举查询条件判断完成第二次（外层）查询。
  - 将子查询"多行多列"的结果作为一张临时表完成第二次（外层）查询。

查询工资大于平均工资的员工信息(工号，名字，薪资)

1).   先查询平均工资
```SQL
select avg(salary) from employees; --6461.68224299065
```
2).   再依据平均工资作为条件，查询大于该值的数据行
```SQL
 select * from employees where salary > 6461.68224299065;
```
 整合：
```SQL
select * from employees where salary > (select avg(salary)from employees);
```

查询与姓氏为‘King’的员工在同一部门的员工信息(工号，名字，薪资，部门id)

思路： 1).   先查询姓氏为'King'的员工所在的部门;2).   再查询部门编号为80,90的所有员工信息
```SQL
select department_id from employees where last_name = 'King'; --80,90
select * from employees where department_id in(80,90);
```
整合：
```SQL
select * from employees where department_id in (select department_id from employees where last_name = 'King');
```


查询员工表中工资排名前5员工的信息（编号，名字，薪资）

思路：1).   先对员工表进行薪资的降序排序; 2).将“临时表”作为查询数据来源表，生成rownum; 3).通过判断rownum保留前5行数据（薪资最高的前5名）
```sql
select * from employees order by salary desc;
select e.* , rownum from(select * from employees order by salary desc) e --临时表
select e.* , rownum from(select * from employees order by salary desc) e where rownum <= 5
```
12.  分页查询【重点】：

对工资降序后的员工表进行分页查询（每页显示10条数据,查看第1页数据(1~10),第2页11~20）
思路：1).降序; 2).生成行号; 3).分页查询（区间判断）
```SQL
select *from employees order by salary desc;
select e.* , rownum from(select * from employees order by salary desc) e
```
```SQL
select *
from (select e.* , rownum as "RN" --为原表添加行号列
from (select * from employees order by salarydesc) e) --对带有行号的临时表进行条件筛选
where RN >= 11 and RN <= 20 --对表中已存在的物理列进行判断
```

在一张具有行号的临时表中进行条件筛选
```sql
select *from (select e.* , rownum RN from employees e where RN between 10 and 20;
```

13.  集合运算符：将多个查询结果合并成一张临时表

- 语法：A查询结果 集合运算符 B查询结果

- 详解：
  - union：并集（联合去重）
  - unionall：并集（联合）
  - minus：差集（减法）
  - intersect：交集（交叉）
  
查询60、70号部门员工信息,查询70、90号部门员工信息

两个查询结果的合并

```sql
select * fromemployees where department_id in(60,70);
union --联合去重
unionall --联合
minus-- 减法（A - B的重复项）
intersect--交叉（保留相同项）
select * fromemployees where department_id in(90,70)
```
>注意：查询结果可以来自于一张表、多张表，多张表的列数和类型必须一致。

14.  表连接查询【重点】：

- 语法：table1连接关键字 table2 连接条件
- 详解：
  - 外连接：
    - 左外连接： 主表 left join 从表
    - 右外连接： 从表 right join 主表
    - 全外连接： 主表 full join 主表

  - 内连接：从表 inner join 从表
  - 自连接：主表 left join 从表（自己连自己）


查询员工工号，名字，薪资，部门id，部门名称

```sql
select employee_id , first_name, salary , employees.department_id , department_name
from employees left join departments -- 主表 left join 从表
on employees.department_id =departments.department_id;

select employee_id , first_name, salary , departments.department_id , department_name
from employees right joindepartments -- 从表 right join 主表
on employees.department_id =departments.department_id;

select employee_id , first_name, salary , departments.department_id , department_name
from employees full joindepartments -- 主表 full join 主表
on employees.department_id =departments.department_id;
 
select employee_id , first_name, salary , departments.department_id , department_name
from employees inner joindepartments -- 从表 inner join 从表
on employees.department_id = departments.department_id;
               
select e.* ,d.* from employeese , departments d
where e.department_id = d.department_id; -- 从表where条件连接 从表 

```
查询员工编号，名字，直接领导(经理)id，直接领导的名字

```sql
select e1.employee_id , e1.first_name , e1.manager_id , e2.first_name 
from employees e1 left join employees e2
-- 物理上的一张表、逻辑上的两张表（自己连自己） 
on e1.manager_id = e2.employee_id;
```

多表连接查询

```sql
select e.* , d.* ,l.* , c.*
from employees e left join departments d
on e.department_id = d.department_id
left join locations l
on d.location_id = l.location_id
left join countries c
on l.country_id = c.country_id;
```

## 一、自定义表：

数据类型：

I.     字符串：

char(n)：固定长度的字符串，上限2000，最大长度为n，实际长度为n，其余使用空格填充 //默认长度为1

例如：char(5)  'abcd'最大长度5，实际长度5，空格填充

varchar(n)：可变长度的字符串，上限4000工业标准，支持空字符串，Oracle中使用varchar2(n)，未来版本中可能无法向下兼容

例如：varchar(5) 'abcd' 最大长度5，实际长度4

varchar2(n)：可变长度的字符串，上限4000，最大长度为n，实际长度存入的字节个数。//必须书写长度

例如：varchar2(5)  '你好' 最大长度5，实际长度4个字节

nvarchar2(n)：可变长度的字符串，上限2000，最大长度为n，实际长度存入的字符个数。

例如：nvarchar2(5) '你好' 最大长度5，实际长度2个字符


II.    数字：

integer：任意长度的整数，超过15位的整数会采用科学计数法，xE10^N。（只保留整数部分，忽略小数）

number / number(n) / number(n,m)：用于描述整数+小数

例如：number 任意长度的小数

例如：number(n) 长度为n的整数

 number(5) 1234

例如：number(n , m) 长度为n的整数+小数 （n最大取值为38）

number(5, 2)  12.3 --> 12.30 //√


III.   日期：

date：年、月、日、时、分、秒、星期，只精确到秒。

timestamp：年、月、日、时、分、秒、毫秒、时区。

IV.   大对象类型【了解】：

CLOB：存储大本文（字符）数据。

BLOB：存储大二进制数据（多媒体，最大上限4GB）。

约束：

- 主键约束：primary key:一行数据的唯一标识，此列的值不能为null，不可重复，数据不变的列适合作为主键，全表只能存在一个主键列。
- 唯一约束：unique:一行数据的唯一标识，此列的值可以为null，不可重复，表中可以存在多个唯一列。
- 非空约束：not null:此列必须有值。
- 检查约束：check:通过制定规则，约束此列的值必须满足某个条件。
  
  列：email，要求必须包含@zparkhr
  ```sql
  check(email like '%@zparkhr%')
  ```
  列：password，要求长度必须为6
  ```sql
  check(password like '______')
  check( length(password) = 6 )
  ```
  列：sex，要求必须录入'男'或'女'
  ```sql
  check(sex in('男','女'))
  check(sex = '男' orsex = '女')
  ```
  列：age，要求取值范围在1 ~ 253之间
  ```sql
  check(age>= 1 and age<= 253)
  check(age between 1 and 253)
  ```

- 外键约束：foreign key 引用外部表的某个列，作为当前表某列的取值，约束此列值必须是引用表中已存在的数据，二者的数据类型必须相同。

语法：references 外部表表名(列名)

建表【重点】：

- 语法：
  ```sql
  create table 表名(
  
  列名       数据类型       [约束],
  
  列名       数据类型       [约束],
  
  .......
  
  列名       数据类型       [约束]  //最后一个列没有逗号
  
  )
  ```
  ```sql
  create table 表名( 列名数据类型 [约束], 列名 数据类型 [约束], 列名 数据类型 [约束] )
  
  ```

  >注意：删除表 drop table 表名（1.创建关系表时，先创建主表，再创建从表；2.删除关系表时，先删除从表，再删除主表）


## 二、数据操作：

插入：（insert）：

  I.     语法：insert into 表名(列1,列2,列3...) values(值1,值2,值3)
  
  II.    详解：表名后的列名应与values后的值一一对应。
  
  III.   用例：
  
  添加一条数据，到班级表中
  ```sql
  insert into t_class(class_id , class_name) values(10,'2018级Java118班');
  ```
  
  添加一条数据，到学生表中
  ```sql
  insert into t_student(student_id , student_name ,sex , borndate , phone , email , class_id)
  
  values(1001,'tom','M',to_date('1995-1-1','yyyy-mm-dd'),'13888888888','aaron@zparkhr.com.cn',10);
  ```
  
  省略列名
  ```sql
  insert into t_studentvalues(1004,'annie','F',to_date('1995-1-1','yyyy-mm-dd'),'13988887777',null,30);
  ```
  >注意：值的顺序和个数必须和列的定义相同，允许为空的值，使用null填充


修改（update）：

I.     语法：update 表名 set 列1 = 新值1 , 列2 = 新值2 where 条件

II.    详解：set后跟随多个 "列 = 值"，绝大多数情况下伴有where条件。

III.   用例：

修改tom的手机号码为13333333333
```sql
update t_student set phone = '13333333333' wherestudent_name = 'tom';
```
修改1002同学的电话为13900000000，邮箱为jack123@zparkhr.com.cn
```sql
update t_student set phone = '13900000000' , email ='jack123@zparkhr.com.cn' where student_id = 1002;
```
修改班级名称为“2018级Java120班”的班级编号为20
```sql
update t_student set class_id = 20 

where class_id = (select class_id from t_class whereclass_name = '2018级Java120班')
```


删除：（delete）：

I.     语法：delete from 表名 where 条件

II.    详解：删除表中满足where条件的数据

III.   用例：

```sql
--先删从表（数据没有依赖）

delete from t_student where class_id =30;

--再删主表（被引用的数据行）

delete from t_class where class_id = 30;

```

4.    约束补充：联合主键、联合唯一、联合约束

问题：约束一位同学在一门科目中，只能有一个成绩


解决：将学生ID和科目名称作为联合主键。


## 三、事务【重点】：
银行账户表：t_account（cardNo , password, balance , ...）

A账户(6222020200001234567)给B账户(6222020200007654321)转账1000

```sql
update t_account set balance = balance - 1000 where cardNo ='6222020200001234567';--断电、宕机
```

```sql
update t_account set balance = balance + 1000 where cardNo ='6222020200007654321';
```

### 1.    事务的概念：

事务是一个原子操作，可以由多条SQL组成，所有的SQL全部成功，则整个事务成功，其中有任何一条SQL失败，则整个事务失败。

### 2.    事务的边界：

#### I.     开始：

1).   一个新的连接建立（打开一个新的客户端）。

2).   上一个事务结束后的第一条增、删、改语句。

#### II.    结束：

1).   提交：

a.    显示提交：commit;

b.    隐式提交：create、drop、正常退出

2).   回滚：

a.    显示回滚：rollback;

b.    隐式回滚：非正常退出（断电、宕机）

### 3.    事务的原理：

数据库会为每个客户端私有的维护一个回滚段（缓存），一个客户端的所有增删改语句，都存入回滚段中，只有当所有的操作均执行成功时，提交事务（commit），才会真正将数据更新到数据库中；如果其中的任何一步操作发生了问题，可以回滚事务（rollback），清空回滚段，取消当次操作。

4.    生产环境：基于增删改语句的操作结果（受影响行数）进行逻辑判断或异常处理决定是否提交事务、回滚事务。

5.    事务的特性：（ACID）

I.     原子性（Atomic）：同一个事务中的所有SQL被视为一个整体，要成功都成功，有一个失败，都失败。

II.    一致性（Consistency）：事务操作开始，事务操作的结束，数据库中的数据是一致的。

III.   隔离性（Isolation）：事务与事务之间各自独立，互不影响。

IV.   持久性（Durability）：事务提交后，对数据库的操作影响是持久的。


## 四、操作优化：

1.    序列【重点】：

I.     语法：create sequence 序列名 [参数] ;

II.    详解：用来生成一组自动增长的整数值。

III.   参数：

```sql
start with --起始值

increment by --递增值

minvalue --最小值

maxvalue --最大值

cycle --是否循环生成

cache --缓存，一次性访问数据库所获取到的序列值

order --保证获取顺序
```

IV.   用例：

获取下一个值（生成一个新值）

```sql
select xxx_seq.nextval from dual;
```

获取已生成的当前值
```sql
select xxx_seq.currval from dual;
```

使用序列作为数据的主键生成器
```sql
insert into t_student values(student_seq.nextval,'eric','M',to_date('1995-1-1','yyyy-mm-dd'),'13988887777',null,20);
```

删除序列

```sql
drop sequence 序列名;
```

2.    视图：

I.     语法：create view 视图名 as select ...

II.    详解：保存SQL语句的虚表，简化查询。（如同Java中的方法）

III.   用例：

封装学生表视图，便于查询。

```sql
create view stu_v as select s.student_id , student_name, sex , borndate , phone , email , class_name , subject_name , score
from t_student s left join t_class cl
on s.class_id = cl.class_id
left join t_score sc
on sc.student_id = s.student_id
```

注意：视图不会独立存储数据，原表发生改变，视图查询结果也会改变。查询方便，效率没有任何提高。

```sql
drop view xxx_v; --删除视图
grant create view to hr; --授予权限
revoke create view from hr; --撤销权限
```

3.    索引：

I.     语法：create index 索引名 on 表(列)

II.    详解：索引类似于字典目录，加快数据查询效率。

III.   用例：

为employees表的salary字段增加索引

```sql
create index EMP_SALARY_IX on employees(salary);
--Oracle自动使用查询引擎检索，自动优化。
```

注意：

1).   查询频率较高的列。

2).   索引需要独立维护，不代表越多越好。

3).   主键、唯一键自动添加索引。

4).  删除索引

```sql
 drop index 索引名;
```

## 五、SQL（Structured Query Language）：

1.    数据查询语言DQL（Data QueryLanguage）：select、where、group by、order by、having

2.    数据操作语言DML（DataManipulation Language）：insert、delete、update

3.    数据定义语言DDL（Data Definition Language）：create、drop、alter

4.    事务处理语言TPL（Transaction Process Language）：commit、rollback

5.    数据控制语言DCL（Data Control Language）：grant、revoke