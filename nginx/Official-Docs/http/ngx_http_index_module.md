
[Module ngx_http_index_module](http://nginx.org/en/docs/http/ngx_http_index_module.html)

> `ngx_http_index_module` 用來處理 「/」結尾的請求. 這類型請求也可用: `ngx_http_autoindex_module` && `ngx_http_random_index_module` 來處理

```conf
### Example
location / {
    index index.$geo.html index.html;
}
```

- Syntax: `index file ...;`
    - Default: `index index.html;`
    - Context:
        - http
        - server
        - location
    - 說明: 