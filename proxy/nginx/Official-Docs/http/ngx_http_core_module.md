[Module ngx_http_core_module](https://nginx.org/en/docs/http/ngx_http_core_module.html)

> 此為 Nginx 的 http 核心模組

# Directives:

### [root](https://nginx.org/en/docs/http/ngx_http_core_module.html#root)

- Syntax:
    - `root path;`
        - path 可改用 `$document_root`, `$realpath_root` 以外的變數
- Default: `root html;`
- Context: http, server, location, if in location

> Sets the root directory for requests.

```conf
# Request to "/i/top.gif"
location /i/ {
    root /data/w3;
}
# 以 "/data/w3/i/top.gif" 做為 Response (容易與 alias 混淆)
```

> A path to the file is constructed by merely adding a URI to the value of the root directive. If a URI has to be modified, the alias directive should be used. (不是很懂)


### [alias](https://nginx.org/en/docs/http/ngx_http_core_module.html#alias)

- Syntax:
    - `alias path;`
        - path 可改用 `$document_root`, `$realpath_root` 以外的變數
- Default: -
- Context: location

可用來對 location 做取代, 如下範例:

```conf
# Request to "/i/top.gif"
location /i/ {
    alias /data/w3/images/;
}
# 以 "/data/w3/images/top.gif" 做為 Response (容易與 root 混淆)
```

如果 `alias` 放在了 regex location 裏頭, 則 *such regular expression should contain captures* && *alias should refer to these captures*

```conf
### 使用 Regex 的 location, 裡面有 alias...
location ~ ^/users/(.+\.(?:gif|jpe?g|png))$ {
    alias /data/w3/images/$1;
}
# Regex 應有 () 來劃分
# alias 應有 $x 來補獲
# 資源位於 FS 的 /data/w3/images/XXX
```

```conf
### 使用 Regex 的 location, 裡面有 alias...
location ~ ^/download/(.+\.apk)$ {
    alias /data/project/apk_download/$1;
}
# 用戶訪問 http://DOMAIN/download/XXX.apk
# 可下載   /data/project/apk_download/XXX.apk
```

```conf
location /images/ {
    alias /data/w3/images/;
}
# 與其寫這樣 ↑
# 不如寫這樣 ↓
location /images/ {
    root /data/w3;
}
# 一樣都是 Request to /images/$1, 然後會拿 /data/w3/images/$1 回應
```


### [http](https://nginx.org/en/docs/http/ngx_http_core_module.html#http)

- Syntax
    - `http { ... }`
- Default: -
- Context: main

> Provides the configuration file context in which the HTTP server directives are specified.


### [log_not_found](http://nginx.org/en/docs/http/ngx_http_core_module.html#log_not_found)

> Enables or disables logging of errors about not found files into error_log.

```conf
Syntax:	    log_not_found on | off;
Default:	log_not_found on;
Context:	http, server, location
```

```conf
    # Example Usage
    # 避免產生過多 favicon.ico 的 Error Log, 回應一個空值 Status 200
    location ~ ^/favicon.ico$ {
         default_type text/html;
         return 200 '';
         log_not_found off;
         access_log off;
    }
```



### [try_files](https://nginx.org/en/docs/http/ngx_http_core_module.html#try_files)

- Syntax
    - `try_files file ... uri;`
    - `try_files file ... =code;`
- Default: -
- Context: server, location

> Checks the existence of files in the specified order and uses the first found file for request processing; the processing is performed in the current context. The path to a file is constructed from the file parameter according to the `root` and `alias` directives. It is possible to check directory’s existence by specifying a slash at the end of a name, e.g. “$uri/”. If none of the files were found, an internal redirect to the uri specified in the last parameter is made.

```conf
location /images/ {
    try_files $uri /images/default.gif;
}

location = /images/default.gif {
    expires 30s;
}
# 如上範例, 也可直接指向 named location (明確已存在的資源)
```

以 PHP 的角度, try_files 會先確認 PHP file 存在, 再 pass Request to FastCGI Server



# Embedded Variables

底下的變數, 都屬於 Request Header fields (僅節錄自認為重要的)

- `$arg_name` :          Request Line 的 argument name
- `$args` :              Request Line 的 arguments
- `$body_bytes_sent` :   Response 大小(bytes)(不含 Header)
- `$bytes_sent` :        Response 大小(bytes)
- `$connection_time` :   Request 的連線時間(毫秒)
- `$content_length` :    Request "Content-Length"
- `$content_type` :      Request "Content-Type"
- `$cookie_name` :       the name cookie
- `$document_root` :     Request 的 root/alias directive 的值
- `$host` :              按照底下的順序取值:
    - Request Line 裏頭的 host name
    - Request Header 的 "Host" field
    - 與 Request 匹配的 server name
- `$hostname` :          hsot name
- `$http_name` :         arbitrary request header field.
    - the last part of a variable name is the field name converted to lower case with dashes replaced by underscores
- `$nginx_version` :     Nginx Version (為了安全, 應該讓它消失)
- `$pid` :               Worker process 的 PID
- `$query_string` :      同 `$args`
- `$remote_addr` :       Request of client address
- `$remote_port` :       Request of client port
- `$remote_user` :       Request 使用 Basic authentication 的 user name
- `$request` :           Request Line
- `$request_body` :      Request Body
- `$request_body_file` : Request Body 內的 temporary file
- `$request_length` :    Request Line + Header + Body 的 length
- `$request_method` :    Request Method
- `$request_time` :      Request 的處理時間(直到 Client 讀取到 first bytes of Response)
- `$request_uri` :       完整的 Request URI (含 arguments)(最原始的 URI)
    - Nginx 變數的使用, 大多時候應該都使用 `$uri` 來替代 `$request_uri` (誤用的話, 會造成 URL 被重覆 decode)
    - 若需要 map URI 及 query string, 則使用 `$request_uri`
    - 在 `proxy_pass` directive, 務必使用 `$request_uri` 而非 `$uri`(會有漏洞)
- `$scheme` :            http/https
- `$server_addr` :       接收 Request 的 Server address
    - 計算此變數需要呼叫 system call. 為了避免此開銷, the *listen directives* must specify addresses and use the bind parameter.
- `$server_port` :       接收 Request 的 Server port
- `$server_protocol` :   "HTTP/1.0" or "HTTP/1.1" or "HTTP/2.0" or ...
- `$status` :            Response Status
- `$time_iso8601` :      local time in the ISO 8601 standard format
- `$time_local` :        local time in the Common Log Format
- `$uri` :               current URI in Request, normalized
    - 變數會隨 Request 處理方式而不同, . ex: 使用 internal redirects、使用 index files、...
    - Nginx 目前正在處理的 URI, 但也受到底下規範:
        - 刪除了 ? 及後續的 query string
        - 連續多的 / 替換成單一個 /
        - URL encoded characters are decoded