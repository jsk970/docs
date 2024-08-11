# REST出现其任何超类对此上下文都是未知的

swagger-ui:发送的请求：

```
curl 'http://localhost:8080/pullDownList' 
-H 'Accept: */*' 
-H 'Connection: keep-alive' 
-H 'Accept-Encoding: gzip, deflate, br'
-H 'Referer: http://localhost:8080/swagger-ui.html' 
-H 'Accept-Language: zh-CN,zh;q=0.9'
-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36' 
--compressed
```

Chrome浏览器地址栏直接发送的请求：

```
curl 'http://localhost:8080/pullDownList' 
-H 'Connection: keep-alive' 
-H 'Cache-Control: max-age=0' 
-H 'Upgrade-Insecure-Requests: 1' 
-H 'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36' 
-H'Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' 
-H 'Accept-Encoding: gzip, deflate, br' 
-H 'Accept-Language: zh-CN,zh;q=0.9' 
--compressed
```

`浏览器告知服务器Accept 接收的类型，服务端会转化成为相应的类型返回给浏览器。`