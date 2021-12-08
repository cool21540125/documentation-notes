[Module ngx_http_realip_module](http://nginx.org/en/docs/http/ngx_http_realip_module.html)

> 這模組用來改變 `client address` 以及 `Request Header 的特定欄位`

> 若使用編譯安裝, 預設沒有這模組, 需要加上 `--with-http_realip_module` 才會有

Example:

```conf
set_real_ip_from  192.168.1.0/24;
set_real_ip_from  192.168.2.1;
set_real_ip_from  2001:0db8::/32;
real_ip_header    X-Forwarded-For;
real_ip_recursive on;
```

# Directives

- Key: `set_real_ip_from`
    - Syntax: set_real_ip_from address | CIDR | unix:;
    - Default: -
    - Context: http, server, location
    - 說明
        - 讓 Nginx 信任這個來源 IP
- Key: `real_ip_header`
    - Syntax: real_ip_header field | X-Real-IP | X-Forwarded-For | proxy_protocol;
    - Default: real_ip_header X-Real-IP;
    - Context: http, server, location
    - 說明
        - 定義用來取代 client address 的 Request Header 欄位. 也可用來取代 client port
        - 看的不是很懂=.="
- Key: `real_ip_recursive`
    - Syntax: real_ip_recursive on | off;
    - Default: real_ip_recursive off;
    - Context: http, server, location
    - 說明
        - off: 把 Request Header 最後一個 IP,                      設為 read_ip
        - on:  把 Request Header 最後一個非 set_real_ip_from 的 IP, 設為 read_ip


# Embedded Variables

- $realip_remote_addr : keeps the original client address
- $realip_remote_port : keeps the original client port