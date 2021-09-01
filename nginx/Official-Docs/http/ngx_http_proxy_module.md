# [Module ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)

> The `ngx_http_proxy_module` module allows passing requests to another server.


## Directives

### proxy_cache_path

```conf
### Context: http
proxy_cache_path path [levels=levels] [use_temp_path=on|off] 
    keys_zone=name:size [inactive=time] 
    [max_size=size] [min_free=size] 
    [manager_files=number] [manager_sleep=time] 
    [manager_threshold=time] [loader_files=number] 
    [loader_sleep=time] [loader_threshold=time] 
    [purger=on|off] [purger_files=number] 
    [purger_sleep=time] [purger_threshold=time];
```

- levels
    - 定義 cache 的階層架構, 可用範圍為 1~3
        - 而每個 level 背後又可接 1 or 2 的值
    - ex: proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=one:10m;
- 快取背後, 在檔案系統看到的樣子長得像這樣:
    - /data/nginx/cache/c/29/b7f54b2df7773722d382f4809d65029c

### proxy_redirect

