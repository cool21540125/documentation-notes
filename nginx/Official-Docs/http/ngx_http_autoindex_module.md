
[Module ngx_http_autoindex_module](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html)

> `ngx_http_autoindex_module` 模組用來處理 「/」結尾的請求, 用來生成 **目錄清單**. 通常, 如果 `ngx_http_autoindex_module` 找不到對應的 index file 的話, 會傳遞請求給 `ngx_http_index_module`

```conf
### 範例
location / {
    autoindex on;
}
```


## Directives

- Syntax: `autoindex on | off;`
    - Default: `autoindex off;`
    - Context: 
        - http
        - server
        - location
    - 說明: 用來 啟用/關閉 location 請求的目錄清單
- Syntax: `autoindex_exact_size on | off;`
    - Default: `autoindex_exact_size on;`
    - Context:
        - http
        - server
        - location
    - 說明: 對於 HTML 文件, 在目錄清單中, 列出確切的檔案大小(只有 html 才會列出檔案大小)
- Syntax: `autoindex_format html | xml | json | jsonp;`
    - Default: `autoindex_format html;`
    - Context:
        - http
        - server
        - location
    - 說明: (遇到再說)
- Syntax: `autoindex_localtime on | off;`
    - Default: `autoindex_localtime off;`
    - Context: 
        - http
        - server
        - location
    - 說明: 對於 HTML 格式文件, 時間應以 localtime 或 UTC 來呈現