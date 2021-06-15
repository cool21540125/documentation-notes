


```bash
### 顯示 Nginx 配置後的目前組態
nginx -T
# 可用來看總體的配置成果

nginx -s reload
nginx -s stop


```

```bash
server {
    listen 80;
    server_name www.tonychoucc.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name               www.tonychoucc.com;
     
    #ssl_certificate           sss/www.tonychoucc.com.crt;
    #ssl_certificate_key       ssl/www.tonychoucc.com.key;
    ### 可改成底下 2 行
    ssl_certificate           sss/$ssl_server_name.crt;
    ssl_certificate_key       ssl/$ssl_server_name.key;

    ssl_protocols             TLSv1.3 TLSv1.2 TLSv1.1;
    ssl_prefer_server_ciphers on;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```