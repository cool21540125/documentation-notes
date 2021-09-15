[Module ngx_http_upstream_module](http://nginx.org/en/docs/http/ngx_http_upstream_module.html)

`ngx_http_upstream_module` 模組用來定義可被底下 directives 參照的 server group:

- proxy_pass
- fastcgi_pass
- uwsgi_pass
- scgi_pass
- memcached_pass
- grpc_pass


```conf
### 範例
upstream backend {   # ← 參照的 server group
    server backend1.example.com       weight=5;
    server backend2.example.com:8080;
    server unix:/tmp/backend3;

    server backup1.example.com:8080   backup;
    server backup2.example.com:8080   backup;
}

server {
    location / {
        proxy_pass http://backend;
    #   ↑↑↑↑↑↑↑↑↑↑
    }
}
```


# Directives
