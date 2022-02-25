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

### set_real_ip_from

```conf
Syntax:	    set_real_ip_from address | CIDR | unix:;
Default:	—
Context:	http, server, location

# 讓 Nginx 信任這個來源 IP
```


### real_ip_header

```conf
Syntax:	    real_ip_header field | X-Real-IP | X-Forwarded-For | proxy_protocol;
Default:	real_ip_header X-Real-IP;
Context:	http, server, location

# 藉由 Request Header 的特定欄位, 用來取代原始的 client address
```


### real_ip_recursive 

```conf
Syntax:	    real_ip_recursive on | off;
Default:	real_ip_recursive off;
Context:	http, server, location

# - off: 把 Request Header 最後一個 IP,                      設為 read_ip
# - on:  把 Request Header 最後一個非 set_real_ip_from 的 IP, 設為 read_ip
```


# Embedded Variables

- $realip_remote_addr : keeps the original client address
- $realip_remote_port : keeps the original client port
