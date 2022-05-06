# maven 安装jar到本地仓库

```shell
mvn install:install-file -Dfile=jar包的位置 -DgroupId=上面的groupId -DartifactId=上面的artifactId -Dversion=上面的version -Dpackaging=jar
```

例如：

```shell
mvn install:install-file -Dfile=G:\PageSecurity-0.0.2.jar -DgroupId=com.ailk.ecs -DartifactId=PageSecurity -Dversion=0.0.2 -Dpackaging=jar
```

# maven setting.xml配置


问题场景
1、国内访问maven默认远程中央镜像特别慢

2、用阿里的镜像替代远程中央镜像

3、大部分jar包都可以在阿里镜像中找到，部分jar包在阿里镜像中没有，需要单独配置镜像

解决方案
settings.xml 中可以使用变量，可以尝试使用变量解决：

```xml
  <mirrors>
        <!-- 阿里云仓库 -->
        <mirror>
            <id>alimaven</id>
            <mirrorOf>central</mirrorOf>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
        </mirror>
    
        <!-- 中央仓库1 -->
        <mirror>
            <id>repo1</id>
            <mirrorOf>central</mirrorOf>
            <name>Human Readable Name for this Mirror.</name>
            <url>http://repo1.maven.org/maven2/</url>
        </mirror>
    
        <!-- 中央仓库2 -->
        <mirror>
            <id>repo2</id>
            <mirrorOf>central</mirrorOf>
            <name>Human Readable Name for this Mirror.</name>
            <url>http://repo2.maven.org/maven2/</url>
        </mirror>
  </mirrors>
```


- 在maven的配置文件setting.xml大里面有个mirrors节点，用来配置镜像URL。mirrors可以配置多个mirror，每个mirror有id,name,url,mirrorOf属性，

- id是唯一标识一个mirror，name节点名，url是官方的库地址，mirrorOf代表了一个镜像的替代位置，例如central就表示代替官方的中央库


- 虽然mirrors可以配置多个子节点，但是它只会使用其中的一个节点，即默认情况下配置多个mirror的情况下，只有第一个生效，只有当前一个mirror

- 无法连接的时候，才会去找后一个；而我们想要的效果是：当a.jar在第一个mirror中不存在的时候，maven会去第二个mirror中查询下载，但是maven不会这样做！

***注意：***

>　配置多个mirror时，mirrorOf不能配置" * "，" * " 的意思就是（根据mirrorOf和repository的id）匹配所有的仓库（repository），

> 这样就是说如果你需要某个jar，他会从镜像地址去下载这个jar。不管你配置了多少个库，即使这些库的地址不一样，仍然会从镜像地址访问