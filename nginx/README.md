

```conf
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