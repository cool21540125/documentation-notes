[Module ngx_http_upstream_module](http://nginx.org/en/docs/http/ngx_http_upstream_module.html)

> The ngx_http_upstream_module module is used to define groups of servers that can be referenced by the proxy_pass, fastcgi_pass, uwsgi_pass, scgi_pass, memcached_pass, and grpc_pass directives.

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


### [least_conn](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_conn)

```
Syntax:	    least_conn;
Default:	—
Context:	upstream
```

做 round-robin 用



