# [Module ngx_http_log_module](https://nginx.org/en/docs/http/ngx_http_log_module.html)

> ngx_http_log_module 可自訂 log format

> Requests are logged in the context of a location where processing ends. It may be different from the original location, if an internal redirect happens during request processing.

```conf
### 範例
log_format compression '$remote_addr - $remote_user [$time_local] '
                       '"$request" $status $bytes_sent '
                       '"$http_referer" "$http_user_agent" "$gzip_ratio"';

access_log /spool/logs/nginx-access.log compression buffer=32k;
```


## Directives

### 1. access_log

- Key: 
    - `access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];`
    - `access_log off;`
- Default:
    - access_log logs/access.log combined;
        - 若沒給 `access_log`, 則預設為 **combined**
- Context:
    - http
    - server
    - location
    - if in location
    - limit_except

說明

- 如果要讓 Nginx log 紀錄到 syslog, 則在第一個參數之前加上 `syslog:` 即可
- 若使用了 `buffer` 或 `gzip`, writes to log will be buffered
    - 若使用了 `gzip`, 則 log 會先被壓縮再寫入到 file
        - 使用 gzip 以前, 必須先安裝 `zlib library`
        - compression level 介於 1~9 (越大則壓縮率越大, 速度越慢)
    - 預設, buffer size 為 64K bytes, compression level 為 1.
    - 要改用 zcat 來查看 log file
    - 範例:
        - `access_log /path/to/log.gz combined gzip flush=5m;`


### 2. log_format

- Key: 
    - `log_format name [escape=default|json|none] string ...;`
- Default:
    - `log_format combined "...";`
- Context:
    - http

說明

配置都有個預先定義好的 log format, 名為 `combined`:

```conf
log_format combined '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';
# $remote_addr : Client Address
# $remote_user : Basic authentication 之下的 username
# $time_local : local time
# $request : 完整的 Request Line
# $status : Response Status
# $body_bytes_sent : 回應給 Client 的 Bytes(不包含 Response Headers) (與 Apache 的 mod_log_config 的 "%B" 相容)
# $http_referer : 
# $http_user_agent : 用戶端使用的代理
```


### 3. open_log_file_cache

暫略