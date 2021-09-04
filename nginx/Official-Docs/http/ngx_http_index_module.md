[Module ngx_http_index_module](http://nginx.org/en/docs/http/ngx_http_index_module.html)

> `ngx_http_index_module` 用來處理 「/」結尾的請求. 這類型請求也可用: `ngx_http_autoindex_module` && `ngx_http_random_index_module` 來處理

```conf
### Example
location / {
    index index.$geo.html index.html;
}
```

其實這篇我都讀完了, 但並不是很懂上面所說的重點


# Directives

### [index](http://nginx.org/en/docs/http/ngx_http_index_module.html#index)

- Syntax: `index file ...;`
- Default: `index index.html;`
- Context: http, server, location

> Defines files that will be used as an index.

file 可用變數取代. 若有多個 file, 則依序檢視, 最後一個 file 可使用 絕對路徑, ex:

```conf
index index.$geo.html index.0.html /index.html;
#                                  ↑↑↑↑↑↑↑↑↑↑↑
```

需要留意的是, 如果使用了 index file, 則會發生 `internal redirect`, 而 redirect 後的請求, 則可能被其他 location 來處理, ex:

```conf
location = / {
    index index.html;
}

location / {
    ...
}
# 這個範例看起來有點智障, 但其實只是要說, 
# "/index.html" 的 request 最終會被底下那個 location 處理
```