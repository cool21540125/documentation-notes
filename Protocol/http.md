
# Hypertext Transfer Protocol (HTTP)

* http/1.0
* http/1.1 : [2616](https://tools.ietf.org/html/rfc2616)
* http/2   : [7230](https://tools.ietf.org/html/rfc7230)


# 名詞

* Internet Engineering Task Force (IETF)
* Internet Engineering Steering Group (IESG)


# http 這東西

HTTP/2 為 HTTP/1.1 的替代方案 ; 藉由引入 `header field compression` && `allow multiple concurrent exchange on the same connection` 減少網路傳輸延遲, 來提升網路傳輸效能, 減少延遲的知覺.

> `HTTP/1.0` allowed only one request to be outstanding at a time on a given TCP connection.

> `HTTP/1.1` added request pipelining, 
> but this only partially addressed request concurrency and still
> suffers from head-of-line blocking.  Therefore, HTTP/1.0 and HTTP/1.1
> clients that need to make many requests use multiple connections to a
> server in order to achieve concurrency and thereby reduce latency.


# HTTP

* [What does enctype='multipart/form-data' mean?](https://stackoverflow.com/questions/4526273/what-does-enctype-multipart-form-data-mean)

> When you make a POST request, you have to encode the data that forms the body of the request in some way.

HTML form 提供了 3 種方法來做 encoding:

* application/x-www-form-urlencoded (default)
* multipart/form-data
* text/plain


# HSTS

* 2021/05
* [HTTP Strict Transport Security (HSTS) and NGINX](https://www.nginx.com/blog/http-strict-transport-security-hsts-and-nginx/)

Server 透過 Internal redirect 的方式, 強制讓 Client 升級 HTTP -> HTTPS

避免(就算Server 有把請求 redirect 到 HTTPS)首次訪問的時候, 遭受到 man-in-the-middle(MITM) 攻擊

```bash

### Server HTTP Response

Strict-Transport-Security: max-age=31536000
# 一年

### 也可設定底下的所有 sub-domain 都套用

Strict-Transport-Security: max-age=31536000; includeSubDomains
```

Nginx 的設定方式:

```ini
### 
server {
   add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
   # always 確保所有的 response 都有在 header 設定 (目的只是為了盡快讓還沒取得此 header 的 client 盡早套用)

   location /will_inherits {
      # ※ 此 block 會繼承上層的 add_header
      # settings
   }

   location /will_not_inherits {
      # ※ 此 block 「不會」繼承上層的 add_header. 因為遭到 overwrite 了
      add_header X-Served-By "My Servlet Handler";
      # ↓ 必須重新聲明
      add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
      # settings
   }
}
```

IMPORTANT: Server 方, 初期在設置的時候, 務必把 `max-age=5` 調成非常小的數字, 因為一旦改錯, 將非常難撤銷

IMPORTANT: 設置 STS header 的時候, 也要留意設置的地方. 避免設置在 login / 或是 Client 可能經由 cache 拿取的地方

```conf
server {
   listen 80 default_server;
   server_name _;

   # 將請求 301(permanent) 到 home page 來避免深度訪問(/xxx/yyy)
   return 301 https://$host;

   # 或是, redirect all HTTP links to the matching HTTPS page 
   # return 301 https://$host$request_uri;
}

server {
   listen 443 ssl;
   server_name www.example.com;

   add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
```

但依舊有某些情況 HSTS 並非 100% 安全, 例如, 重新安裝OS, 重新安裝Browser, 剛清空了Cache, 訪問從未造訪的URL, .....

出非把 domain 加入到 https://hstspreload.org/

IMPORTANT: 上述加入到 HSTS preload 的作法, 是一條通往 HTTPS 的不歸路!!!!! 只能單向通行.


# HTTP Header

- [Http Header 快取(初學)](https://blog.techbridge.cc/2017/06/17/cache-introduction/)
   - Cache-Control
   - Expires
   - max-age
   - Las-Modified
   - If-Modified-Since
   - Etag
   - If-Non-Match


# X-Forwarded-For

- [What is the difference between X-Forwarded-For and X-Forwarded-IP?](https://stackoverflow.com/questions/19366090/what-is-the-difference-between-x-forwarded-for-and-x-forwarded-ip)
- [Forwarded](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Forwarded#browser_compatibility)

- `X-Forwarded-For` 是非標準表頭, 最早由 squid 引入. 之後則有了標準表頭 `Forwarded`(IETF 於 2014 制定)
   - 雖說 `Forwarded` 為標準表頭, 不過 `X-Forwarded-For`, `X-Forwarded-Host`, `X-Forwarded-Proto` 被視為是時尚的標準
- 若確定 Client 來自 proxy, 則用 `X-Forwarded-For` 或 `Forwarded` 來取得用戶 IP
- 若確定 Client 非來自 proxy, 則用 `REMOTE_ADDR` 來取得用戶 IP
- 不管事 `X-Forwarded-For` 或 `Forwarded`, 都可能被 Client 到 Server 之間的任何 Proxy 竄改