# Mysql 索引

## 1. 简介
索引是对数据库表中一列或多列的值进行排序的一种结构，使用索引可快速访问数据库表中的特定信息。

>举例说明索引：如果把数据库中的某一张看成一本书，那么索引就像是书的目录，可以通过目录快速查找书中指定内容的位置，对于数据库表来说，可以通过索引快速查找表中的数据。

## 2. 索引的原理
索引一般以文件形式存在磁盘中（也可以存于内存中），存储的索引的原理大致概括为以空间换时间，数据库在未添加索引的时候进行查询默认的是进行全量搜索，也就是进行全局扫描，有多少条数据就要进行多少次查询，然后找到相匹配的数据就把他放到结果集中，直到全表扫描完。而建立索引之后，会将建立索引的KEY值放在一个n叉树上（BTree）。因为B树的特点就是适合在磁盘等直接存储设备上组织动态查找表，每次以索引进行条件查询时，会去树上根据key值直接进行搜索。

## 3. 索引的优点
建立索引的目的是加快对表中记录的查找或排序！
- ① 建立索引的列可以保证行的唯一性，生成唯一的rowId
- ② 建立索引可以有效缩短数据的检索时间
- ③ 建立索引可以加快表与表之间的连接
- ④ 为用来排序或者是分组的字段添加索引可以加快分组和排序顺序

## 4. 索引的缺点
- ① 创建索引和维护索引需要时间成本，这个成本随着数据量的增加而加大
- ② 创建索引和维护索引需要空间成本，每一条索引都要占据数据库的物理存储空间，数据量越大，占用空间也越大（数据表占据的是数据库的数据空间）
- ③ 会降低表的增删改的效率，因为每次增删改索引需要进行动态维护，导致时间变长

## 5、索引的使用场景
数据库中表的数据量较大的情况下，对于查询响应时间不能满足业务需求，可以合理的使用索引提升查询效率。

## 6、基本索引类型
- ① 普通索引（单列索引）
- ② 复合索引（组合索引）
- ③ 唯一索引
- ④ 主键索引
- ⑤ 全文索引

① 普通索引（单列索引）
>普通索引（单列索引）：单列索引是最基本的索引，它没有任何限制。

（1）直接创建索引
```sql
CREATE INDEX index_name ON table_name(col_name);
```
（2）修改表结构的方式添加索引
```sql
ALTER TABLE table_name ADD INDEX index_name(col_name);
```
（3）创建表的时候同时创建索引
```sql
CREATE TABLE `news` (
`id` int(11) NOT NULL AUTO_INCREMENT ,
`title` varchar(255)  NOT NULL ,
`content` varchar(255)  NULL ,
`time` varchar(20) NULL DEFAULT NULL ,
PRIMARY KEY (`id`),
INDEX index_name (title(255))
)
```

（4）删除索引
```sql
DROP INDEX index_name ON table_name;
-- 或者
alter table `表名` drop index 索引名;
```
② 复合索引（组合索引）
>复合索引：复合索引是在多个字段上创建的索引。复合索引遵守“最左前缀”原则，即在查询条件中使用了复合索引的第一个字段，索引才会被使用。因此，在复合索引中索引列的顺序至关重要。

（1）创建一个复合索引
```sql
create index index_name on table_name(col_name1,col_name2,...);
```

（2）修改表结构的方式添加索引
```sql
alter table table_name add index index_name(col_name,col_name2,...);
```

③ 唯一索引
>唯一索引：唯一索引和普通索引类似，主要的区别在于，唯一索引限制列的值必须唯一，但允许存在空值（只允许存在一条空值）。

如果在已经有数据的表上添加唯一性索引的话：

如果添加索引的列的值存在两个或者两个以上的空值，则不能创建唯一性索引会失败。（一般在创建表的时候，要对自动设置唯一性索引，需要在字段上加上 not null）
如果添加索引的列的值存在两个或者两个以上的null值，还是可以创建唯一性索引，只是后面创建的数据不能再插入null值 ，并且严格意义上此列并不是唯一的，因为存在多个null值。
对于多个字段创建唯一索引规定列值的组合必须唯一。
比如：在order表创建orderId字段和 productId字段 的唯一性索引，那么这两列的组合值必须唯一！

“空值” 和”NULL”的概念：
1：空值是不占用空间的 .
2: MySQL中的NULL其实是占用空间的.

长度验证：注意空值的之间是没有空格的。
```sql
> select length(''),length(null),length(' ');
+------------+--------------+-------------+
| length('') | length(null) | length(' ') |
+------------+--------------+-------------+
|          0 |         NULL |           1 |
+------------+--------------+-------------+
```


（1）创建唯一索引

```sql
-- 创建单个索引
CREATE UNIQUE INDEX index_name ON table_name(col_name);
-- 创建多个索引
CREATE UNIQUE INDEX index_name on table_name(col_name,...);
```

（2）修改表结构

```sql
-- 单个
ALTER TABLE table_name ADD UNIQUE index index_name(col_name);
-- 多个
ALTER TABLE table_name ADD UNIQUE index index_name(col_name,...);
```
（3）创建表的时候直接指定索引

```sql
CREATE TABLE `news` (
`id` int(11) NOT NULL AUTO_INCREMENT ,
`title` varchar(255)  NOT NULL ,
`content` varchar(255)  NULL ,
`time` varchar(20) NULL DEFAULT NULL ,
PRIMARY KEY (`id`),
UNIQUE index_name_unique(title))
```

④ 主键索引
>主键索引是一种特殊的唯一索引，一个表只能有一个主键，不允许有空值。一般是在建表的时候同时创建主键索引：

（1）主键索引(创建表时添加)

```sql
CREATE TABLE `news` (
`id` int(11) NOT NULL AUTO_INCREMENT ,
`title` varchar(255)  NOT NULL ,
`content` varchar(255)  NULL ,
`time` varchar(20) NULL DEFAULT NULL ,
PRIMARY KEY (`id`))
```

（2）主键索引(创建表后添加)
```sql
alter table tbl_name add primary key(col_name);

CREATE TABLE `order` (
`orderId` varchar(36) NOT NULL,
`productId` varchar(36)  NOT NULL ,
`time` varchar(20) NULL DEFAULT NULL
)

alter table `order` add primary key(`orderId`);
```
⑤ 全文索引
在一般情况下，模糊查询都是通过 like 的方式进行查询。但是，对于海量数据，这并不是一个好办法，在 like “value%” 可以使用索引，但是对于 like “%value%” 这样的方式，执行全表查询，这在数据量小的表，不存在性能问题，但是对于海量数据，全表扫描是非常可怕的事情,所以 like 进行模糊匹配性能很差。

这种情况下，需要考虑使用全文搜索的方式进行优化。全文搜索在 MySQL 中是一个 FULLTEXT 类型索引。FULLTEXT 索引在 MySQL 5.6 版本之后支持 InnoDB，而之前的版本只支持 MyISAM 表。

全文索引主要用来查找文本中的关键字，而不是直接与索引中的值相比较。fulltext索引跟其它索引大不相同，它更像是一个搜索引擎，而不是简单的where语句的参数匹配。fulltext索引配合match against操作使用，而不是一般的where语句加like。目前只有char、varchar，text 列上可以创建全文索引。

小技巧：
在数据量较大时候，先将数据放入一个没有全局索引的表中，然后再用CREATE index创建fulltext索引，要比先为一张表建立fulltext然后再将数据写入的速度快很多。

（1）创建表的适合添加全文索引
```sql
CREATE TABLE `news` (
`id` int(11) NOT NULL AUTO_INCREMENT ,
`title` varchar(255)  NOT NULL ,
`content` text  NOT NULL ,
`time` varchar(20) NULL DEFAULT NULL ,
PRIMARY KEY (`id`),
FULLTEXT (content))
```

（2）修改表结构添加全文索引
```sql
ALTER TABLE table_name ADD FULLTEXT index_fulltext_content(col_name)
```
（3）直接创建索引
```sql
CREATE FULLTEXT INDEX index_fulltext_content ON table_name(col_name)
```
注意： 默认 MySQL 不支持中文全文检索！

MySQL 全文搜索只是一个临时方案，对于全文搜索场景，更专业的做法是使用全文搜索引擎，例如 ElasticSearch 或 Solr。
索引的查询和删除

```sql
--查看:
show indexes from `表名`;
--或
show keys from `表名`;
--删除
alter table `表名` drop index 索引名;
```

注:MySQl的客户端工具也可以进索引的创建、查询和删除，如 Navicat Premium!

## 查看索引使用情况

```sql
show status like 'Handler_read%';
```

>handler_read_key:这个值越高越好，越高表示使用索引查询到的次数
>handler_read_rnd_next:这个值越高，说明查询低效

## 常见索引失效的情况：
创建一个students表： 其中stud_id为主键！

```sql
DROP TABLE IF EXISTS `students`;
CREATE TABLE `students` (
`stud_id` int(11) NOT NULL AUTO_INCREMENT,
`name` varchar(50) NOT NULL,
`email` varchar(50) NOT NULL,
`phone` varchar(1) NOT NULL,
`create_date` date DEFAULT NULL,
PRIMARY KEY (`stud_id`))

INSERT INTO `learn_mybatis`.`students` (`stud_id`, `name`, `email`, `phone`, `create_date`) VALUES ('1', 'admin', 'student1@gmail.com', '18729902095', '1983-06-25');
INSERT INTO `learn_mybatis`.`students` (`stud_id`, `name`, `email`, `phone`, `create_date`) VALUES ('2', 'root', '74298110186@qq.com', '2', '1983-12-25');
INSERT INTO `learn_mybatis`.`students` (`stud_id`, `name`, `email`, `phone`, `create_date`) VALUES ('3', '110', '7429811086@qq.com', '3dsad', '2017-04-28');
```

使用 explain 查看 索引是否生效！

1. 在where后使用or，导致索引失效（尽量少用or） 简单实例演示： 创建两个普通索引

```sql
CREATE INDEX index_name_email ON students(email);
CREATE INDEX index_name_phone ON students(phone);
```

使用下面查询sql

```sql
-- 使用了索引
EXPLAIN select * from students where stud_id='1'  or phone='18729902095'
-- 使用了索引
EXPLAIN select * from students where stud_id='1'  or email='742981086@qq.com'
-- 没有使用索引
EXPLAIN select * from students where phone='18729902095' or email='742981086@qq.com'
-- 没有使用索引
EXPLAIN select * from students where stud_id='1'  or phone='222' or email='742981086@qq.com'
```

2.使用like ，like查询是以%开头
> 在1的基础上，还是使用 index_name_email 索引。

使用下面查询sql

```sql
-- 使用了index_name_email索引
EXPLAIN select * from students where email like '742981086@qq.com%';
--没有使用index_name_email索引，索引失效
EXPLAIN select * from students where email like '%742981086@qq.com';
-- 没有使用index_name_email索引，索引失效
EXPLAIN select * from students where email like '%742981086@qq.com%';
```

3.复合索引遵守“最左前缀”原则，即在查询条件中使用了复合索引的第一个字段，索引才会被使用
> 删除1的基础创建的 index_name_email 和 index_name_phone 索引。

重新创建一个复合索引：

```sql
create index index_email_phone on students(email,phone);
```

使用下面查询sql

```sql
-- 使用了 index_email_phone 索引
EXPLAIN select * from students where email='742981086@qq.com' and  phone='18729902095'
-- 使用了 index_email_phone 索引
EXPLAIN select * from students where phone='18729902095' and  email='742981086@qq.com'
-- 使用了 index_email_phone 索引
EXPLAIN select * from students where email='742981086@qq.com' and name='admin'
-- 没有使用index_email_phone索引，复合索引失效
EXPLAIN select * from students where phone='18729902095' and name='admin'
```

4. 如果列类型是字符串，那一定要在条件中将数据使用引号引用起来,否则不使用索引
   给name创建一个索引！

```sql
CREATE INDEX index_name ON students(name);
-- 使用索引
EXPLAIN select * from students where name='110'
-- 没有使用索引
EXPLAIN select * from students where name=110
```

5. 使用in导致索引失效

```sql
-- 使用索引
EXPLAIN select * from students where name='admin'
-- 没有使用索引
EXPLAIN SELECT * from students where name in ('admin')
```

6. DATE_FORMAT()格式化时间，格式化后的时间再去比较，可能会导致索引失效。
   删除 students 上的创建的索引！重新在create_date创建一个索引！

```sql
CREATE INDEX index_create_date ON students(create_date);
-- 使用索引
EXPLAIN SELECT * from students where create_date >= '2010-05-05'
-- 没有使用索引
EXPLAIN SELECT * from students where DATE_FORMAT(create_date,'%Y-%m-%d') >= '2010-05-05'
```

7. 对于order by、group by 、 union、 distinc 中的字段出现在where条件中时，才会利用索引！


## 索引使用技巧
- (1)越小的数据类型通常更好：越小的数据类型通常在磁盘、内存和CPU缓存中都需要更少的空间，处理起来更快。
- (2)简单的数据类型更好：整型数据比起字符，处理开销更小，因为字符串的比较更复杂。在MySQL中，应该用内置的日期和时间数据类型，而不是用字符串来存储时间；以及用整型数据类型存储IP地址。
- (3)尽量避免NULL：应该指定列为NOT NULL，除非你想存储NULL。在MySQL中，含有空值的列很难进行查询优化，因为它们使得索引、索引的统计信息以及比较运算更加复杂。你应该用0、一个特殊的值或者一个空串代替空值。
- (4)索引不会包含有NULL值的列。

> 注意: 但是如果是同样的sql如果在之前能够使用到索引，那么现在使用不到索引，以下几种主要情况:
> - 随着表的增长，where条件出来的数据太多，大于15%，使得索引失效（会导致CBO计算走索引花费大于走全表）
> - 统计信息失效      需要重新搜集统计信息
> - 索引本身失效      需要重建索引

## 不会使用到索引的原因
- 1、 没有查询条件，或者查询条件没有建立索引;
- 2、 在查询条件上没有使用引导列;
- 3、 查询的数量是大表的大部分，应该是30％以上;
- 4、 索引本身失效;
- 5、 查询条件使用函数在索引列上（见12）;
- 6、 对小表查询;
- 7、 提示不使用索引;
- 8、 统计数据不真实;
- 9、 CBO计算走索引花费过大的情况。其实也包含了上面的情况，这里指的是表占有的block要比索引小;
- 10、隐式转换导致索引失效.这一点应当引起重视.也是开发中经常会犯的错误. 由于表的字段tu_mdn定义为varchar2(20);
   但在查询时把该字段作为number类型以where条件传给mysql,这样会导致索引失效.
   - 错误的例子：select * from test where tu_mdn=13333333333;
   - 正确的例子：select * from test where tu_mdn='13333333333';
   
- 11、对索引列进行运算导致索引失效,我所指的对索引列进行运算包括(+，-，*，/，! 等)
   - 错误的例子：select * from test where id-1=9;
   - 正确的例子：select * from test where id=10;

- 12、使用mysql内部函数导致索引失效.对于这样情况应当创建基于函数的索引.
   - 错误的例子：select * from test where round(id)=10;
   说明，此时id的索引已经不起作用了
   - 正确的例子：首先建立函数索引：create index test_id_fbi_idx on test(round(id));
   然后 select * from test where round(id)=10; 这时函数索引起作用了

- 13.不使用NOT IN和<>操作
   - NOT IN和<>操作都不会使用索引将进行全表扫描。NOT IN可以NOT EXISTS代替，id<>3则可使用id>3 or id<3来代替
