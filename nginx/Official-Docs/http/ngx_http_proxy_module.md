[Module ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)

> The `ngx_http_proxy_module` module allows passing requests to another server.

```conf
location / {
    proxy_pass       http://localhost:8000;
    proxy_set_header Host      $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

# Directives

### [proxy_cache_path](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path)

- Syntax:
    ```conf
    proxy_cache_path path [levels=levels] [use_temp_path=on|off] 
    keys_zone=name:size [inactive=time] 
    [max_size=size] [min_free=size] 
    [manager_files=number] [manager_sleep=time] 
    [manager_threshold=time] [loader_files=number] 
    [loader_sleep=time] [loader_threshold=time] 
    [purger=on|off] [purger_files=number] 
    [purger_sleep=time] [purger_threshold=time];
    ```
- Default: -
- Context: http

> Sets the path and other parameters of a cache. Cache data are stored in files.

`levels` 定義 cache 的階層架構, 可用範圍為 1~3, 而每個 level 背後又可接 1 or 2 的值, ex:

```conf
proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=one:10m;
#                                         ↑ ↑
```

*file names* in a cache, 是做了 MD5(cache key), 看起來則是像:

```conf
/data/nginx/cache/c/29/b7f54b2df7773722d382f4809d65029c
```

...


### [proxy_redirect](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_redirect)


# Embedded Variables

`ngx_http_proxy_module` 模組提供的變數, 可藉由 *proxy_set_header directive* 用來組合 headers

- $proxy_host :                *proxy_pass directive* 紀錄的 proxied server
- $proxy_port :                *proxy_pass directive* 紀錄的 proxied server port, 或是協定預設 port
- $proxy_add_x_forwarded_for : 