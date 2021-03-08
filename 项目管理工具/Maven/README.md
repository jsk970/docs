# maven 安装jar到本地仓库

```shell
mvn install:install-file -Dfile=jar包的位置 -DgroupId=上面的groupId -DartifactId=上面的artifactId -Dversion=上面的version -Dpackaging=jar
```

例如：

```shell
mvn install:install-file -Dfile=G:\PageSecurity-0.0.2.jar -DgroupId=com.ailk.ecs -DartifactId=PageSecurity -Dversion=0.0.2 -Dpackaging=jar
```