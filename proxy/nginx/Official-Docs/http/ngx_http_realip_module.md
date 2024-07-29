[Module ngx_http_realip_module](http://nginx.org/en/docs/http/ngx_http_realip_module.html)

> 這模組用來改變 `client address` 以及 `Request Header 的特定欄位`

> 若使用編譯安裝, 預設沒有這模組, 需要加上 `--with-http_realip_module` 才會有

Example:

```conf
set_real_ip_from  192.168.1.0/24;
set_real_ip_from  192.168.2.1;
set_real_ip_from  2001:0db8::/32;

### (想清楚再這樣設!!)
set_real_ip_from 0.0.0.0/0;
# 針對這些來源, 全部替換為 real ip (而非來訪的 Load Balancer)
# 例如我們只在意進入的 Server 的上一層是誰而已, 而非最根源的 Source, 那麼就不要做 set_real_ip_from
# 因為會嘗試使用 real_ip_header 所揭露的 IP <- 將此視為 Real Client IP
# 又或者
# 已經可以確認所有流量皆來自 ALB, 那就這樣設定吧
# 此設定就是告訴 nginx, 信任來自 set_real_ip_from 所告知的 real_ip_header (相信這一定是真的)
# 將此視為 real client ip
# 反之
# 不要隨意 set_real_ip_from 設定自己不信任的來源
# 避免該來源偽造了一堆假的 real_ip_header

real_ip_header    X-Forwarded-For;  # 例如 AWS ALB, 預設會拋此 Header 過來
real_ip_recursive on;
```


# Directives

### set_real_ip_from

```conf
Syntax:	    set_real_ip_from address | CIDR | unix:;
Default:	—
Context:	http, server, location

# 讓 Nginx 信任這個來源 IP/hostname
```


### real_ip_header

```conf
Syntax:	    real_ip_header field | X-Real-IP | X-Forwarded-For | proxy_protocol;
Default:	real_ip_header X-Real-IP;
Context:	http, server, location

# 藉由 Request Header 的特定欄位, 用來取代原始的 client address
```


### real_ip_recursive

- [nginx real_ip_header and X-Forwarded-For seems wrong](https://serverfault.com/questions/314574/nginx-real-ip-header-and-x-forwarded-for-seems-wrong)
- [NGinx $proxy_add_x_forwarded_for and real_ip_header](https://stackoverflow.com/questions/29279084/nginx-proxy-add-x-forwarded-for-and-real-ip-header/47575872#47575872)

```conf
Syntax:	    real_ip_recursive on | off;
Default:	real_ip_recursive off;
Context:	http, server, location

# - off: 將 real_ip_header 指定的 Request Header 最後一個 IP,      視為 client IP
# - on:  將 real_ip_header 指定的 Request Header 最後一個非信任 IP, 視為 client IP
```

> If recursive search is disabled, the original client address that matches one of the trusted addresses is replaced by the last address sent in the request header field defined by the real_ip_header directive.

> If recursive search is enabled, the original client address that matches one of the trusted addresses is replaced by the last non-trusted address sent in the request header field.


# Embedded Variables

- $realip_remote_addr : keeps the original client address
    - Since nginx v1.9.7+, 上一層的來訪 IP
- $realip_remote_port : keeps the original client port
