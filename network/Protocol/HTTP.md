
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


## HTTP Header

- `Connection: Keep-Alive`
  - HTTP/1.0
    - Client Request Header `Connection: Keep-Alive` - Client 希望建立長連接
    - Server Response Header `Connection: Keep-Alive` - Server 接受 Client 長連接
  - HTTP/1.1
    - 預設啟用長連接, 因此毋需額外夾帶此 Header
    - `Connection: Close` 明確聲明, 拒絕長連接
  - 若 Request 是發送給 Proxy
    - `Connection: Cookie` 表示 Client 告訴 Proxy, 轉發給 Server 的話, 不要 forward `Cookie`
      - 之所以這樣子搞, 是因為 Proxy 本身可能過於 Legacy, 不懂這個 Header, 然後把原訊息 forward 給 Server
      - 而 Server 誤以為 Proxy 要建立長連接因而同意, Proxy 收到後, 一樣不懂, 因此在 forward 回 Client
      - 造成了 Client -> Proxy -> Server -> Proxy -> Client 全部都有接收到 `Connection: Keep-Alive`
      - 但是從一開始就沒有長連接
    - `Proxy-Connection: Keep-Alive`
      - 如果是 Legacy Proxy, 它看不懂這個, 因此也會直接 forward 給 Server (Server 當然看不懂, 至於會怎樣不重要)
      - 如果是 Modern Proxy
        - 因應 proxy 長連接 的問題, Client 改用這方式發給 Proxy, 而 Proxy 會有能力得知 Client 要建立長連接
        - 因而改成 forward `Connection: Keep-Alive` 告知 Server 要做長連接



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


# HTTP cache

- 參考文件
   - https://blog.techbridge.cc/2017/06/17/cache-introduction/
   - https://www.cloudflare.com/learning/cdn/glossary/what-is-cache-control/
- `Expires`
   - Since HTTP/1.0
   - Client 拿到 Response 以後, 可得知 Resource **到期時間**
   - ex, Response Header: `Expires: Oct, 12 Oct 2023 13:30:00 GMT`
   - 問題:
      - 如果 Client 的時間錯誤. 例如是西元 3000 年, 則每次都會跟 Server 要 Resources
- Cache-Control
   - 是個 HTTP Header, 用來引導 **Browser** 的快取行為
   - Cache-Control 可能同時存在於 Request 及 Response
   - Cache-Control 的範例:
      - `Cache-Control: private`    : 任何中間元件, 像是 CDN or Proxy 都不可以快取, 只有 Client Browser 可以快取 (適用於 user personal information)
      - `Cache-Control: public`     : 此資源可被 any cache 做儲存
      - `Cache-Control: max-age=0`  : 這類請求通常由 Client 自行發起, 告知 Response 不要 Cached
      - `Cache-Control: max-age=60` : Resource 快取有效時間 60 secs
      - `Cache-Control: no-store`   : 完全不使用快取. 帶有此 Header 的 Response, 任何地方都不准儲存下來作為快取, 也就是所有資源請求, 都必須要回源 (適用於極端機敏資訊, 像是銀行帳戶餘額)
      - `Cache-Control: s-maxage`   : Browser 不會鳥這個. 這僅對 CDN 具備用途. s-maxage 會覆蓋掉 max-age
         - `Cache-Control: public, max-age=60, s-maxage=300` : 對於 Browser 快取 60 secs, 對於 CDN, 快取 300 secs
      - `Cache-Control: no-cache`   : 快取但每次必須驗證. 每次有快取可用時, 都會比對 ETag 版本是否異動了, 若沒動, 才相信快取的內容 (並非如字面上所指的不能快取)
         - `Cache-Control: no-cache` 等同於 `Cache-Control: no-store, max-age=0`
         - 若存在於 Request  : Client 告知 Server, 不要給我 cached resource, 直接回源找到最新的
         - 若存在於 Response : (如下範例)
            - Request (Client 首次請求, 要求 Server 給我回源拿最新的. 此外, 首次請求時, 除非有重新整理, 不然通常不會自帶 **Cache-Control: no-cache**)
               ```
               GET /index.html
               ```
            - Response (此時, Client 會將 /index.html 做快取)
               ```
               HTTP/1.1 200 OK
               Cache-Control: no-cache
               ETag: "abc123"
               ```
            - Request (因為前面 Server 已經告知了 no-cache, 後續 Client 在對相同 Resource 發起請求時, 會去詢問是否版本有異動)
               ```
               GET /index.html
               If-None-Match: "abc123"
               ```
            - Response (ETag 沒變)
               ```
               HTTP/1.1 304 Not Modified
               ```
            - Response (ETag 變動了)
               ```
               HTTP/1.1 200 OK
               Cache-Control: no-cache
               ETag: "xyz456"
               ```
   - 問題:
      - 如果同時拿到 `max-age` 及 `Expires`, 則會以 `max-age` 為主
      - 如果 Resource 到期了, 則可藉由其他的 Response Headers 來判斷能否繼續使用
- `Last-Modified` 及 `If-Modified-Since`
   - 如果要讓 Resource 過期時, Client 能夠繼續使用, Server 平常 Response 除了給 `Cache-Control` 以外, 還要再加上 `Last-Modified`
   - 等到真的到期了, Client Request Header 會加上 `If-Modified-Since`
      - 若 Server 沒更新 Resource, `Status code: 304 (Not Modified)` (此時, Client 可繼續使用 Cached Resource)
   - 問題:
      - 檔案有無被修改, 依據的是 Client Side 的檔案是否被 真正修改 or 開啟後關閉存擋. (但 Server 都沒更動 Resource), 則會使快取失效
- `Etag` 與 `If-None-Match`
   - Server Response 除了給 `Cache-Control` 以外, 還會多給 `Etag`
      - 表彰此 Resource 的 hash
   - 快取過期後, Client Request 發送 `If-None-Match` 詢問 Server 是否有異動 Resource
      - 有異動, 則給 new Resource
      - 無異動, 則回 304
- Http 快取
   - 快取儲存策略
   - 快取過期策略
   - 快取比對策略


# X-Forwarded-For

- [What is the difference between X-Forwarded-For and X-Forwarded-IP?](https://stackoverflow.com/questions/19366090/what-is-the-difference-between-x-forwarded-for-and-x-forwarded-ip)
- [Forwarded](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Forwarded#browser_compatibility)

- `X-Forwarded-For` 是非標準表頭, 最早由 squid 引入. 之後則有了標準表頭 `Forwarded`(IETF 於 2014 制定)
   - 雖說 `Forwarded` 為標準表頭, 不過 `X-Forwarded-For`, `X-Forwarded-Host`, `X-Forwarded-Proto` 被視為是時尚的標準
- 若確定 Client 來自 proxy, 則用 `X-Forwarded-For` 或 `Forwarded` 來取得用戶 IP
- 若確定 Client 非來自 proxy, 則用 `REMOTE_ADDR` 來取得用戶 IP