[Module ngx_http_autoindex_module](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html)

> `ngx_http_autoindex_module` 模組用來處理 「/」結尾的請求, 用來生成 **目錄清單**. 通常, 如果 `ngx_http_autoindex_module` 找不到對應的 index file 的話, 會傳遞請求給 `ngx_http_index_module`

```conf
### 範例
location / {
    autoindex on;
}
```


# Directives

### [autoindex](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex)

- Syntax: `autoindex on | off;`
- Default: `autoindex off;`
- Context: http, server, location

用來 啟用/關閉 location 請求的目錄清單


### [autoindex_exact_size](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_exact_size)

- Syntax: `autoindex_exact_size on | off;`
- Default: `autoindex_exact_size on;`
- Context: http, server, location

對於 HTML 文件, 在目錄清單中, 列出確切的檔案大小(只有 html 才會列出檔案大小)


### [autoindex_format](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_format)

- Syntax: `autoindex_format html | xml | json | jsonp;`
- Default: `autoindex_format html;`
- Context: http, server, location

(遇到再說)


### [autoindex_localtime](https://nginx.org/en/docs/http/ngx_http_autoindex_module.html#autoindex_localtime)

- Syntax: `autoindex_localtime on | off;`
- Default: `autoindex_localtime off;`
- Context: http, server, location

如果沒配置(預設, off) 的話, 看到的檔案時間會是 UTF 時間


# 範例

```conf
server {
    listen 80;
    server_name log.DOMAIN;
    
    access_log off;

    location / {
        root /data/log;
        autoindex on;           # 可查看目錄內容
        autoindex_localtime on; # 顯示 localtime, 而非 UTC time

        allow 9.4.8.7;
        deny all;
    }
}
```