# 配置location、proxy_pass时，加“/”与不加“/”的区别

通过nginx代理访问地址：http://127.0.0.1/v1/pt/apply/page

## location、proxy_pass都不加斜杠
```
location /v1 {
    proxy_pass http://127.0.0.1:8899;
}
```
实际访问代理地址：http://127.0.0.1:8899/v1/pt/apply/page

## location加斜杠，proxy_pass不加斜杠
```
location /v1/ {
    proxy_pass http://127.0.0.1:8899;
}
```
实际访问代理地址：http://127.0.0.1:8899/v1/pt/apply/page

## location不加斜杠，proxy_pass加斜杠
```
location /v1 {      
    proxy_pass http://127.0.0.1:8899/;
}
```
实际访问代理地址：http://127.0.0.1:8899//pt/apply/page

## location、proxy_pass都加斜杠
```
location /v1/ {
    proxy_pass http://127.0.0.1:8899/;
}
```
实际访问代理地址：http://127.0.0.1:8899/pt/apply/page

## location不加斜杠，proxy_pass加"v1"
```
location /v1 {
    proxy_pass http://127.0.0.1:8899/v1;
}
```
实际访问代理地址：http://127.0.0.1:8899/v1/pt/apply/page

## location加斜杠，proxy_pass加"v1"
```
location /v1/ {
    proxy_pass http://127.0.0.1:8899/v1;
}
```
实际访问代理地址：http://127.0.0.1:8899/v1pt/apply/page

## location不加斜杠，proxy_pass加"v1/"
```
location /v1 {
    proxy_pass http://127.0.0.1:8899/v1/;
}
```
实际访问代理地址：http://127.0.0.1:8899/v1/pt/apply/page

## location加斜杠，proxy_pass加"v1/"
```
location /v1/ {
    proxy_pass http://127.0.0.1:8899/v1/;
}
```
实际访问代理地址：http://127.0.0.1:8899/v1/pt/apply/page

##总结
- proxy_pass代理地址端口后无任何字符，转发后地址：代理地址+访问URL目录部分
- proxy_pass代理地址端口后有目录(包括 / )，转发后地址：代理地址+访问URL目录部分去除location匹配目录（示例中的"v1"或"v1/"）