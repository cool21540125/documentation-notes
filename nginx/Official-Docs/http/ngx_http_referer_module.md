[Module ngx_http_referer_module](http://nginx.org/en/docs/http/ngx_http_referer_module.html)

> `ngx_http_referer_module` 用來禁止 Request Header: "Referer" field 含有非法值 的請求

要自行修改 Request Header: "Referer" 是件容易的事情, 此 module 的目的並非阻止此類型請求, 而是避免 regular browsers 發送大量的請求流量. 此外還需要考量, regular browsers 可能也不會發送 Referer" field

```conf
### Example
valid_referers none blocked server_names
               *.example.com example.* www.example.org/galleries/
               ~\.google\.;

if ($invalid_referer) {
    return 403;
}
```

# Directives

### [referer_hash_bucket_size](http://nginx.org/en/docs/http/ngx_http_referer_module.html#referer_hash_bucket_size)

- Syntax: `referer_hash_bucket_size size;`
- Default: `referer_hash_bucket_size 64;`
- Context: server, location

用來設定 bucket size for the valid referers hash tables. 可參考: [Setting up hashes](http://nginx.org/en/docs/hash.html)


### [referer_hash_max_size](http://nginx.org/en/docs/http/ngx_http_referer_module.html#referer_hash_max_size)

- Syntax: `referer_hash_max_size size;`
- Default: `referer_hash_max_size 2048;`
- Context: server, location

用來設定 maximum size of the valid referers hash tables. 同上參考


### [valid_referers](http://nginx.org/en/docs/http/ngx_http_referer_module.html#valid_referers)

- Syntax: `valid_referers none | blocked | server_names | string ...;`
- Default: -
- Context: server, location


# Embedded Variables

- `$invalid_referer`: 如果 Request Header: "Referer" 被視為 vaild, 則為 "", 否則為 "1"