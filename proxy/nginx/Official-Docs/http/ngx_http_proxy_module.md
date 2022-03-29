[Module ngx_http_proxy_module](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)

> The ngx_http_proxy_module module allows passing requests to another server.

```conf
location / {
    proxy_pass       http://localhost:8000;
    proxy_set_header Host      $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```


# Directives

### [proxy_cache_path](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path)

```
Syntax:	    proxy_cache_path path [levels=levels] [use_temp_path=on|off] keys_zone=name:size [inactive=time] [max_size=size] [min_free=size] [manager_files=number] [manager_sleep=time] [manager_threshold=time] [loader_files=number] [loader_sleep=time] [loader_threshold=time] [purger=on|off] [purger_files=number] [purger_sleep=time] [purger_threshold=time];
Default:    —
Context:    http
```

用來設定儲存在本地檔案的 快取路徑 & 快取參數

```conf
# The levels parameter defines hierarchy levels of a cache: from 1 to 3, each level accepts values 1 or 2.
proxy_cache_path /data/nginx/cache levels=1:2 keys_zone=one:10m;
#                                         ↑ ↑
# 第一個數字, 範圍 1~3
# 第二個數字, 範圍 1~2
# 用來定義快取的階層架構
```

```conf
# 快取路徑底下的 filename, 是做了 md5(proxy_cache_key). 看起來則是像:
/data/nginx/cache/c/29/b7f54b2df7773722d382f4809d65029c
```


### [proxy_connect_timeout](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_connect_timeout)

```
Syntax:	    proxy_connect_timeout time;
Default:	proxy_connect_timeout 60s;
Context:	http, server, location
```

> 用來設定 Nginx 與 upstream server 連線 timeout 時間. 官方建議不要設超過 75s


### [proxy_next_upstream](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_next_upstream)

```
Syntax:	    proxy_next_upstream error | timeout | invalid_header | http_500 | http_502 | http_503 | http_504 | http_403 | http_404 | http_429 | non_idempotent | off ...;
Default:    proxy_next_upstream error timeout;
Context:    http, server, location
```

可用來定義那些 Request 應該被轉送給後端 Server


### [proxy_read_timeout](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout)

```
Syntax:	    proxy_read_timeout time;
Default:    proxy_read_timeout 60s;
Context:    http, server, location
```

> 從 upstream server 取得資料的 timeout
> The timeout is set only between two successive read operations, not for the transmission of the whole response.
> If the proxied server does not transmit anything within this time, the connection is closed.


### [proxy_send_timeout](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_send_timeout)

```
Syntax:	    proxy_send_timeout time;
Default:	proxy_send_timeout 60s;
Context:	http, server, location
```

> 傳送資料給 upstream server 的 timeout
> The timeout is set only between two successive write operations, not for the transmission of the whole request. 
> If the proxied server does not receive anything within this time, the connection is closed.



### [proxy_redirect](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_redirect)

```
Syntax:	    proxy_redirect default;
            proxy_redirect off;
            proxy_redirect redirect replacement;
Default:	proxy_redirect default;
Context:	http, server, location
```

用來設定 Proxy Server Response 時, 希望改變的 `Location` 及 `Refresh` Header Field

```conf
# 假設 Proxy Server 回應的 Header Field Location 為 “Location: http://localhost:8000/two/some/uri/”
proxy_redirect http://localhost:8000/two/ http://frontend/one/;
# 則上述配置, 會 rewrite 為  “Location: http://frontend/one/some/uri/”

# 而某些情況下, 可能會被剪寫成下面這樣
proxy_redirect http://localhost:8000/two/ /;
# 則表示改為 80 port
```


### [proxy_set_header](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)

```
Syntax:	    proxy_set_header field value;
Default:	proxy_set_header Host $proxy_host;
            proxy_set_header Connection close;
Context:	http, server, location
```

轉發流量給 Backend 的時候, 可用來 增加/重新定義 Request Header

```conf
proxy_set_header Host       $http_host;
# An unchanged “Host” request header field can be passed like this

proxy_set_header Host       $host;
# 如果原始 Request Header 沒有上一個($http_host)設定方式, 則不會被 pass. 因此建議使用 $host(等同於 Request Header 的 server name)

proxy_set_header Host       $host:$proxy_port;
# the server name can be passed together with the port of the proxied server

proxy_set_header Accept-Encoding "";
# 如果 Header Field 為空字串, 則不會被 passed to a proxied server

proxy_set_header X-Real-IP  $remote_addr;
# 發送給 upstream server 的 Header, X-Real-IP 為 客戶端 IP
```


# Embedded Variables

`ngx_http_proxy_module` 模組提供的變數, 可藉由 *proxy_set_header directive* 用來組合 headers

- $proxy_host :                *proxy_pass directive* 紀錄的 proxied server
- $proxy_port :                *proxy_pass directive* 紀錄的 proxied server port, 或是協定預設 port
- $proxy_add_x_forwarded_for : Nginx 提供的變數. 可用來將 $remote_addr Append 到 X-Forwarded-For 欄位
    - 使用方式範例: 
    ```conf
    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    ```
    - 後續的標準, 則是加入倒 `Forwarded` 欄位. 但是 Nginx 並沒提供 `$proxy_add_forwarded` 這樣的欄位, 若要這樣做, 參考:
        - https://www.nginx.com/resources/wiki/start/topics/examples/forwarded/
        - 但此方式, 依舊無法處理 multiple incoming headers
    