# MyBatis

引言

JDBC访问数据库

    大量冗余代码
    不能自动处理结果集  ,封装成实体对象 
    JDBC查询效率低

![这里写图片描述](https://img-blog.csdn.net/20180730210227608?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

MyBatis框架(前身  ibatis)

    对JDBC技术封装.用来替换JDBC技术实现.	Cliton Begin 2002
    	Google 2006 收购
    	托管 Github
    特点：
    	1. 消灭了所有发送sql的代码
    	2. 消灭了处理结果集，映射成实体Entity对象。
    	3. 自带缓存实现，支持继承第三方分布式缓存，体查询效率
    	4. 自带连接池: POOLED

设计思想

    用SQL的语句替换JDBC实现类的方法
    1:用SQL映射文件实现DAO的接口
    2:ORM	实体和表中的数据关系映射(一个实体---一条数据)
    3:MyBatis支持查询缓存
![这里写图片描述](https://img-blog.csdn.net/20180730210254227?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


    总结:
    	DAO开发
    		DAO接口+MyBatis SQL映射文件
    		【DAO的实现类是MyBatis自动根据SQL映射文件生成一个DAOImpl实现类】

MyBatis第一个程序

搭建MyBatis框架

    1.导入MyBatis相关jar
    	mybatis.xxx.jar
    	mybatis依赖的jar 
    	ojdbcX.jar
    		和Mybatis执行日志相关的jar
    2.导入mybatis相关的配置文件
    	mybatis-config.xml	----和mybatis数据库连接相关配置信息 【放在src的任意目录下】
    	log4j.properties	---- 和mybatis运行日志相关 [src的根目录]
    	
    3. 配置mybatis环境变量。
![这里写图片描述](https://img-blog.csdn.net/20180730210322157?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


    3.测试框架搭建
    	SqlSession	---- 代表数据库的连接 connection
    	SqlSessionFactory----SqlSession的工厂对象.是mybatis-config.xml在内存中表现 用来获得sqlSession对象
    	Resources ---- 读取配置文件. 获得读配置文件的流对象(输入流)
    	测试使用:
    		//1.读取配置文件   获得配置文件输入流
    		InputStream is = Resources.getResourceAsStream("mybatis-config.xml");
    		//2.获得sqlSesion工厂
    		SqlSessionFactory sf = new SqlSessionFactoryBuilder().build(is);//读
    		//3.获得sqlSession  相当于connection
    		SqlSession sqlSession = sf.openSession();

---

第一个MyBatis程序

插入user一条数据

1. 实体
2. UserDAO
3. 书写UserDAOImpl.xml配置文件
4. 将xml文件的路径在mybaits-config中注册一下。
   <mappers>
   <mapper resource="com/baizhi/demo1/UserDAOImpl.xml"></mapper>
   </mappers>

5. 使用Mybatis API实现功能
   @Test
   public void test1() throws Exception{
   //1. 获得config配置文件的输入流
   InputStream is = Resources.getResourceAsStream("mybatis-config.xml");

       		//2. 加载配置文件到SqlSessionFactory 对象
       		SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(is);
       		//3. 获得SqlSession
       		SqlSession sqlSession = factory.openSession();
       		//4. 通过SqlSEssion获得DAO对象
       		UserDAO userDAO = sqlSession.getMapper(UserDAO.class);
       		
       		//5. 调用dao
       		userDAO.insert(new User(null, "李浩然", "123321"));
       		
       		sqlSession.commit(true);
       		
       		sqlSession.close();
       	}

根据id查询users表中的一条数据*

    1.声明DAO接口   方法
    2.写SQL Mapper文件(写实现类)
    	xxxDAOImpl.xml
    	<mapper namespace="实现的接口全类名">
    		<select id='要实现的查询方法名' parameterType='形参类型全类名' resultType='返回值实体的全类名'>
    			查询sql			*不能有分号
    			*select的结果字段名必须要和实体属性名一致
    				id	username	password
    				100	zhangsan	1234
    					User(id,username,password)
    		</select>
    	</mapper>
    	PS:select内部的查询语句,会自动根据结果字段名对应实体的属性名,自动封装成实体对象.
![这里写图片描述](https://img-blog.csdn.net/20180730210413832?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


    3.在mybatis-config中注册mapper文件
    		<mappers>
    			<mapper resource='com/zpark/day1/impl/UserDAOImpl.xml'></mapper>
    		</mappers>



    4.调用DAO的方法
    	//原jdbc时,获得实现类
    		UserDAO dao = new UserDAOImpl();
    	//MyBatis获得实现类
    		UserDAO dao = sqlSession.getMapper(UserDAO.class);
    		dao.selectById(100);

---

配置文件的提示

    将confg的dtd和mapper的dtd导入MyEclipse
    	mybatis-config.dtd:
    		uri:http://mybatis.org/dtd/mybatis-3-config.dtd
    	mapper.dtd:
    		uri:http://mybatis.org/dtd/mybatis-3-mapper.dtd
![这里写图片描述](https://img-blog.csdn.net/20180730210443835?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


---

MyBatis基本语法

查询集合User对象

    UserDAO:
    	public List<User> selectUsers();
    UserDAOImpl.xml
    	resultType:
    		查询结果中每1条数据所对应的实体类型的全类名
    	如果方法没有参数:不写 parameterType
![这里写图片描述](https://img-blog.csdn.net/20180730210501721?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


    <select id='方法名' resultType="查询结果每条数据对应的实体类型">
    	select id,username,password from users
    </select>

如果表中的列明和实体属性名不一致,可以通过查询as 起别名的方式,使查询结果的列明和实体属性名保持一致

MyBatis操作 CUD(增删改)

    必须提交事务
    sqlSession.commit();

删除

    UserDAO:
    	public void delete(Integer id);
    UserDAOImpl.xml
    	<delete id="delete" parameterType="java.lang.Integer">
    		delete from users where id = #{id}
    	</delete>
    *调用dao的delete方法后,要手动提交事务(sqlSession.commit())

多参数的查询

    1:如果dao的方法中只有一个参数,写parameterType
    	sql.......#{xxxx}
    2:如果dao方法中有多个参数,不写parameterType
    	方案①
    	 在sql语句中用
    		#{0}	代表第一个参数
    		#{1}	代表第二个参数
    		ps:可读性稍微差
    	方案②
    		需要在DAO接口方法声明中,对方法的形参定义名字
    			@Param("名字")形参类型  形参名
    			在sql语句中使用  #{名字}
    			*为了可读性,通常将参数名字,和形参变量名保持一致
    			
    		eg:
    			接口方法:xxx(@Param("name")String username,@Param("pwd")String password);
    			Mapper文件的查询:...where username = #{name} and  password = #{pwd}
![这里写图片描述](https://img-blog.csdn.net/20180730210526786?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


插入insert

    1.如果参数是自建类型(实体类型)
    	Mapper的sql语句:
    		#{属性名}	绑定参数实体的属性值
    2:任何一个User对象,如果数据库中存在了与之对应的一条数据
    	如果User被执行insert,User对象必须有id属性值
    	*应用:添加银行账户信息,返回卡号
    	<selectKey keyProperty=''></selectKey>
    	<!-- 插入user -->
    	<insert id="insert" parameterType="com.zpark.day1.User">
    		<!-- keyProperty:
    			会将selectKey中查询结果的值赋值给   id 属性
    				user.setId(..);
    			selectKey:
    				在insert执行之前,先通过序列获得值,并且将结果赋值给参数user的id属性
    		  -->
    		<selectKey keyProperty="id" resultType="java.lang.Integer" order="BEFORE">
    			select seq_user.nextval from dual
    		</selectKey>
    		insert into users(id,username,password)
    		values(#{id},#{username},#{password})
    	</insert>
![这里写图片描述](https://img-blog.csdn.net/20180730210611714?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


封装MybatisUtil

    在属性中定义static的SqlSessionFactory
    需要将sqlSession放入当前Thread,使用ThreadLocal

ThreadLocal

    	在单一线程中共享资源(对象)
    存: set(obj)
    取: get()
    移除:remove()

知识点总结

任务:将personSYstem中的PersonDAO使用MyBatis实现,并且所有方法全部测试通过

MyBatis是用SQLMapper实现DAO接口

DAO接口方法单个参数

	基本类型	(sdaf,delete)

	自建类型 (insert,update)

DAO接口是多个参数

	@Param其别名

insert操作,将插入后的user对象绑定id[属性]

MyBatis在执行增删改   提交事务

总结API及其作用

	Resources

	SqlSessionFactory

	SqlSession

		getMapper()

		commit();

		rollback();

MyBatis框架搭建步骤:

	1:导入jar包.	ojdbc5.jar	mybatisxx.jar	导入log4j日志相关jar

	2:导入配置文件

		log4j.properties	必须放在src根目录

		mybatis-config.xml	数据库连接环境

			注册mapper.xml

			数据库连接相关参数 driver url username password

			datasource   POOLED	

			支持 ConnectionPool	连接池

			手动提交

	3.Resources	读取配置文件

    SqlSessionFactory sf = SqlSessionFactoryBuilder.build(is)
    		SqlSession	获得DAO实现类对象	相当于connection
    			sf.openSession();
    
    interface PersonDAO{
    	public Person selectId(Integer id);
    	public Person selectByab(@Param("name")String name,Integer age);
    }
    //表person(id,p_name,p_age)
    //实体Person(id,name,age)
    <mapper namespace='PersonDAO'>
        <select id='selectId' parameterType='java.lang.Integer' resultType='Person全类名'>
            select id,p_name as name ,p_age as age from person where id = #{id}
        </select>
    
        <select id='selectByab' resultType='Person' >
    
        </select>
    </mapper>

---

总 结

    API：
    	Resources
    		获得读取mybatis-config.xml的输入流
    	SqlSessionFactory
    		sqlSession工厂. 重量级资源  功能强大  占用内存
    
    	sqlSession
    实现接口:
    	参数
    	单个参数基本类型(selectById,delete)
    		标签中必须有parameterType
    		在sql语句绑定	#{id}
    	单个参数实体类型(insert update)
    		标签中有parameterType
    		sql语句绑定 #{属性名}
    		
    	多个参数
    		标签中必须没有parameterType
    		1:SQL  绑定  #{0}	第一个参数
    					#{1}	第二个参数
    					...
    		2:
    			select(@Param("name")String name,@Param("age")int age);
    			sql绑定   #{别名}

---

ORM映射

1. 数据库的表中的数据,关系本身就是双向
2. 实体关系往往创建成双向(互相保留对象的关系属性)
3. 实际业务操作中针对每个单一的操作,只有单向的.

1*1关系

业务背景:1个学生有1台电脑

学生表

ID  	stu_name	stu_age	cid（外键）
101 	苏三      	18     	102    
102 	李四      	19     	104    
103 	龙       	21     	103

电脑表

id  	name        
101 	MacbookPro  
102 	dell 外星人    
103 	ThinkPad IBM
104 	Macbook air

建表

表中的数据双向1对1关系

    表示1对1
    	①在学生表中创建cid外键+Unique
    	②在电脑表中创建sid外键+unique
    *在其中一张表中添加  fk+uk(外键+唯一约束)
    *在业务主表中添加数据
    create table t_computer(
        id integer primary key,
        name varchar2(100)
      );
    create table t_students(
        id integer primary key,
        stu_name varchar2(40),
        stu_age number(3),
        cid integer references t_computer(id) unique
      );
    create sequence seq_stus start with 10000;
    *添加测试数据
    	先添加没有外键的表

DAO实现

查询学生信息(id,name,age,电脑编号,电脑名称)

创建实体

    *彼此保留对方的一个关系属性	实体双向关系
    class Student{
    	Integer id			//主属性   主键
    	String stuName;		//一般属性
    	Integer stuAge		//一般属性
    	Computer computer	//关系属性
    }
    class Computer{
    	Integer id		//主
    	String name		//一般
    	Student student	//关系属性
    }

MyBatis实现表查询

    StudentDAO{
    	public Student selectById(Integer id);
    }

ResultMap

口诀:用来映射sql的执行结果的字段与封装的实体的属性之间的关系

    是MyBatis在对查询结果封装成实体时看的说明书

    <!-- 映射查询结果和属性 -->
    <resultMap type="resultMap最终要映射的实体类型全类名" id="被select标签的resultMap属性引用">
    	<!-- 主属性 将sid列和id属性映射       -->
    	<id property="主属性名" column="主属性对应的查询结果字段"/>
    	<!-- 一般属性 -->
    	<result property="一般属性名" column="一般属性对应的查询结果字段"/>
    	<!-- 关系属性        1对1 关系   关系属性是1个 用association -->
    	<association property="关系属性名" javaType="关系属性全类名">
    		<id property="关系属性的主属性名" column="查询结果中对应的字段"/>
    		<result property="关系属性的一般属性名" column="查询结果中对应的字段"/>
    	</association>
    </resultMap>
    <select id="selectById" parameterType="java.lang.Integer" 
    		resultMap="映射依据的resultMap标签的id">
    	select s.id as sid,s.stu_name,s.stu_age,c.id as cid,c.name
    	  from t_students s left join t_computer c on s.cid=c.id
    	  where s.id = #{id}
    </select>

![这里写图片描述](https://img-blog.csdn.net/20180730210653221?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

<center style='color:red'>查询select标签的resultMap属性指向 resultMap标签的id值</center>

---

练习

    查询电脑信息(编号,名称,所有者学号,名字,年龄)	?

---

1对多

需求： 查询类别信息，及其类别包含的商品信息。

商品和类别关系

1. 一个商品===1个类别
2. 一个类别===n个商品

建表

    商品表 t_product
    	id		pro_name		price		cid
    	101		火腿肠			3.5			101
    	102		卫龙			3			 101
    	103		老干妈			10			101
    	104		Thinkpad		5999		103
    	105		xxxx			99999		104
    类别表 t_category
    	id		name	
    	101		食品	
    	102		手机		
    	103		电脑
    	104		其他
    *在多的一方创建外键列
    create table t_category(
    	id integer primary key,
    	name varchar2(600)
    );
    create table t_product(
    	id integer primary key,
    	pro_name varchar2(1000),
    	price number(12,3),
    	cid integer references t_category(id)
    );

DAO实现

创建实体

互相保留对方的关系属性

    在n的一方法保留1的一方的一个关系属性
    在1的一方保留n的一方的一个集合关系属性
    
    public class Category implements Serializable{
    	private Integer id;
    	private String name;
    	private List<Product> products;
    	
    public class Product implements Serializable {
    	private Integer id;
    	private String proName;
    	private Double price;
    	private Category category;

MyBatis实现查询1对n

查询一个类别(食品)得到类别的信息,及其所有商品的信息(类别编号,类别名称,包含的多个商品)

    public interface CategoryDAO{
    	public Category selectById(Integer id);
    }

ResultMap配置

    <resultMap type="day2.one2many.Category" id="cat">
    	<id property="id" column="cid"/><!-- 主属性 -->
    	<result property="name" column="name"/><!-- 一般属性 -->
    	<!-- 关系属性    关系属性和集合    collection-->
    	<collection property="products" ofType="关系属性集合中单个对象类型全类名">
    		<id property="id" column="pid"/>
    		<result property="proName" column="pro_name"/>
    		<result property="price" column="price"/>
    	</collection>
    </resultMap>
    
    *collection标签会自动将多行的product信息,封装成多个Product对象,并存入list集合中.	
    *使用collection时,用ofType指定集合中单个对象的全类名

n对n

本质就是1对n

学生和课程

建表

    学生表 t_student
    	id 		name 		age
    	101		gold龙		21
    	102		2鹏			19
    	103		苏3			18
    	104		赵4			40
    课程表 c_course
    	id 		name			
    	1		CoreJava		
    	2		Oracle		
    选课表(外键关系表)  t_stu_course
    	sid		cid
    	101		1
    	102		1
    	103		1
    	104		1
    	101		2
    *使sid和cid联合为主键.
    create table t_stu_course(
    	sid integer references t_student(id),
    	cid	integer references t_course(id),
    	primary key(sid,cid)
    );
    *创建第三张表,存储两张表的外键列


实体创建

    public class Student{
    	Integer id;
    	String name;
    	Integer age;
    	List<Course> courses;
    }
    
    public class Course{
    	Integer id;
    	String name;
    	List<Student> students;
    }

n对n本质就是两个单向的1 对 n

	完成商品和类别查询商品信息(id,name,价格,类别名称,类别编号) 1 - 1?

    完成查询课程,得到课程编号,课程名称,及选该课程的学生信息?


---

mybatis配置文件引入外部的properties文件;

    将数据库连接相关的配置信息,从mybatis-config.xml中抽取出来,
    放在一个*.properties;
    1.在mybatis-config.xml中引入properties文件
    	<!-- 导入外部的文件 -->
    	<properties resource='com/zpark/day3/oracle.properties'></properties>
    2.在使用值位置
    	${名字}

可以为mapper中使用的实体起别名

    <typeAliases>
    	<typeAlias type="com.zpark.day1.User" alias="User"></typeAlias>
    </typeAliases>
    在mapper文件中如果需要使用全类名(com.zpark.day1.User),可以写User替代

---

MyBatis高级特性

sql的复用

    1.定义被复用的sql
    	<sql id="selectUser">
    		select id,username,password from users
    	</sql>
    2.通过定义sql的id值,引用重复sql
    	<include refid="selectUser"></include>
    3:好处:
    	代码复用,减少冗余,加快开发效率
    	可维护性强


![这里写图片描述](https://img-blog.csdn.net/20180730210722840?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

动态sql

    create table t_stu(
      id varchar2(36) primary key,
      name varchar2(30),
      birth date,
      status number(1)
    );
    
    insert into t_stu values(sys_guid(),'zhangsan',sysdate,1);
    insert into t_stu values(sys_guid(),'list',sysdate,1);
    insert into t_stu values(sys_guid(),'wang5',sysdate,1);
    commit;

通用查询：where+if

    StudentDAO
    
    
    StudentDAOImpl.xml
    <select id="select" parameterType="com.baizhi.demo2.Student" resultType="com.baizhi.demo2.Student">
    		select
    			<include refid="stu_column"></include>
    		from t_stu
    		<where>
    			<if test="id!=null  &amp;&amp; id!=''">
    				id = #{id}
    			</if>
    			<if test="name!=null  &amp;&amp; name!=''">
    				and name = #{name}
    			</if>
    			<if test="birth!=null &amp;&amp; birth!=''">
    				and birth = #{birth}
    			</if>
    			<if test="status!=null &amp;&amp; status!=''">
    				and status = #{status}
    			</if>
    		</where>
    	</select>
    	1:相当于where关键,
    	2:自动移除多余前缀的and和or


高效修改：set+if

    *修改时,如果绑定参数是null,报错.
    *自己的通用update语句,效率低
    *希望:给那个字段,修改那个字段
    	
    	1.修改了username 
    		update users set username = #{username} where id = #{id}
    	2.修改password
    		update users set password = #{password} where id = #{id}
    
    	update users 
    	<set>
    		<if test="username !=null">
    			username = #{username},
    		</if>
    		<if test="password !=null">
    			password = #{password}
    		</if>
    	</set>
    	where id = #{id}
    	<set>
    		1:相当于set关键字
    		2:默认可以将多余的后缀(逗号) 删除


批量删除：foreach

    //UserDAO:
    	//批量删除
    public void delete(@Param("ids")List<Integer> ids);

    UserDAOImpl.xml
    	<delete id='delete'>
    		delete from users where id in 
    		...
    	</delete>

![这里写图片描述](https://img-blog.csdn.net/2018073021074772?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

动态sql总结

    口诀:由于调用时传入的值不一样,导致最终执行的sql语句也不一样.


缓存[最重要]
![这里写图片描述](https://img-blog.csdn.net/20180730210807563?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


    概念:用来存储用户查询的数据
    作用:加快(被缓存过的数据)查询效率.
    核心思路： 
       1. 数据尽可能从内存中获取，较少硬盘检索需要花费的时间
       2. 减少服务器tomcat通过网络URL和数据库交互次数，提高查询效率，降低数据库访问压力。
    
    缓存机制:
    	每次查询数据,会先尝试从缓存中获得数据,
    		如果得到,则查询结束(不会查询数据库, 不会发送sql)
    		如果没有得到数据,发送sql从数据库中获得数据,同时将结果数据存入缓存中.


MyBatis缓存

    *开发步骤
    1.开启MyBatis全局缓存设置
    	<settings>
    		<setting name="cacheEnabled" value="true"/>
    	</settings>		
    2.在要使用缓存的mapper文件中,添加
    	<cache></cache>		
    	*当前mapper中的查询将会使用缓存;
    3.将实体实现Serializable接口	
    	*对象在缓存中将会被序列化存储.

MyBatis缓存注意
![这里写图片描述](https://img-blog.csdn.net/20180730210829485?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


    1.查询的数据只有明确写了sqlSession.close(),该数据才会被放入缓存中.
    2.MyBatis全局缓存,二级缓存.
    	是全局,是SqlSessionFactory级别.
    3.MyBatis一级缓存,sqlSession级别;
    4.MyBatis是以namespace管理缓存.
    	如果当前的namespace下的insert  update  delete语句执行,将会清空缓存(clear cache)


MyBatis整合Ehcache分布式缓存

    Ehcache：
    EhCache 是一个纯Java编写的的进程内的缓存框架
    
    特点：
    1.效率高。(相比memcache和Redis效率最高。)
    2.易于使用(java程序实现，仅需进入ehcache的相关jar包即可)
    3.支持多种缓存策略：LRU、LFU、FIFO
    4.数据两段存储，内存+磁盘。
    5.缓存的数据会在jvm虚拟机重启的时候将数据写入磁盘。
    6.支持分布式缓存
    7.默认提供MyBatis和Hibernate缓存整合。

Ehcache缓存数据结构

		!ehcache

Ehcache+MyBatis 缓存架构图1
![这里写图片描述](https://img-blog.csdn.net/20180730210853879?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


Ehcache+MyBatis 缓存架构图2
![这里写图片描述](https://img-blog.csdn.net/20180730210859988?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4OTI4OTQ0/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)


    MyBatis+ehcache开发步骤
    1. 导入ehcache的jar和mybatis-ehcache的jar
    2. 导入ehcache配置文件
    3. 在mapper文件中的cache标签中使用type属性指定缓存使用Ehcache的实现方式

缓存应用场景:

1. 电商类别，抢拍商品，热卖商品（所有用户都需要，相同数据，查询频率非常高，修改频率比较低）
2. 猜你喜欢，用户推荐商品(不需要缓存。)