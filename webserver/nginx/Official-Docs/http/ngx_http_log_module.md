# [Module ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html)

> ngx_http_log_module 這個模組會以特定格式來寫 log

> Requests are logged in the context of a location where processing ends. It may be different from the original location, if an internal redirect happens during request processing.

```conf
### 範例
log_format compression '$remote_addr - $remote_user [$time_local] '
                       '"$request" $status $bytes_sent '
                       '"$http_referer" "$http_user_agent" "$gzip_ratio"';

access_log /spool/logs/nginx-access.log compression buffer=32k;
```


## Directives

- Key: 
    - `access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];`
    - `access_log off;`
- Default:
    - access_log logs/access.log combined;
- Context:
    - http
    - server
    - location
    - if in location
    - limit_except
