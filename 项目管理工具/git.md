# git修改用户名邮箱
> 用户名和邮箱地址的作用
> 
> 用户名和邮箱地址是本地git客户端的一个变量，不随git库而改变。 
> 
> 每次commit都会用用户名和邮箱纪录。
> 
>github的contributions统计就是按邮箱来统计的。

## 查看用户名和邮箱地址：
```shell
$ git config user.name

$ git config user.email
```

## 修改用户名和邮箱地址：
```shell
$ git config --global user.name "username"

$ git config --global user.email "email"
```
# 


