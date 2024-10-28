- [AWS - Configuring CORS on Amazon API Gateway APIs](https://aws.amazon.com/blogs/compute/configuring-cors-on-amazon-api-gateway-apis/#:~:text=Additionally%2C%20it%20only%20allows%20the,control%2Dallow%2Dorigin%20header)
- [MDN - CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- 2024/05/05


```mermaid
flowchart LR;

client["Client App"]
browser["Browser"]
server["Server"]

client -- "1. initiate a request" --> browser;
browser -- "2. preflight request" --> server;
server -- "3. preflight response" --> browser;
browser -- "4. actual reqeust" --> server;
server -- "5. actual response" --> browser;
browser -- "6. receive actual response" --> client;
```


# pre-flight request

- `Access-Control-Request-Method` : 此 header 只會出現在 preflight request 之中, 且必須用 OPTIONS 發出
- preflight request 會由 Browser 自行發出, Front-end developers 無需自行實作
- 而對於 **simple request** 的話, 則可免除 preflight request
- 底下的 headers 稱之為 *CORS-safelisted request header*, 無需出現在 `Access-Control-Request-Headers` 隨著 preflight request 發出:
    - Accept
    - Accept-Language
    - Content-Language
    - Content-Type
    - Range

```yaml
OPTIONS /path HTTP/1.1
Origin: https://web.example.com                           # required
Access-Control-Request-Method: POST                       # required
Access-Control-Request-Headers: x-api-key, authorization  # optional
```


# pre-flight response

- NOTE: Servers 對於 preflight response 會有不同的響應內容
    - e.g. 對於 preflight request 的 `Access-Control-Request-Headers`, server 似乎會用不同的 header 做回應(假設文件都沒寫錯):
        - MDN 上頭寫, 會使用 `Access-Control-Allow-Headers`
        - AWS 上頭寫, 會使用 `Access-Control-Request-Headers`
    - e.g. 有的 Server 如果 origin, method, headers 都符合的話, 只會回傳 Access-Control-Request-Headers, 但如果不 Match, 則不會有任何 Access-Control-Request-Headers
- Server 可藉由 `Access-Control-Max-Age` 來讓 Browser 做 cache
    - 然而此 cache, 並不會 cache 在 browser 的 general HTTP cache 之中
        - 也就是會使用 Browser 所管理的 cache 機制 (而此機制與 general HTTP cache 是分開的)
- `Access-Control-Allow-Origin` : 只能夠塞入 "single origin" 或 "*"
- `Vary` : 用來告知 client, server 的 Response 會基於你發來的 Origin 而異

```yaml
HTTP/1.1 204 No Content
Content-Length: 0
Connection: keep-alive
Access-Control-Allow-Origin: https://web.example.com  # necessary
Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE
Access-Control-Allow-Headers: x-api-key, authorization, other-allowed-header
Access-Control-Max-Age: 86400
Vary: Origin
```


# actual request

```yaml
POST https://api.example.com HTTP/1.1
Origin: https://web.example.com            # required
Access-Control-Request-Headers: x-api-key  # optional
x-api-key: 4rfv5tg6yhn7ujm8ik4rfws
authorization: Bearer 38ughoeiauvaiehrfyouv...
Content-Type: text/plain; charset=UTF-8
...
```


# actual response

- 對於 AWS Api Gateway 來說, `Rest | Http` Api Gateway 需要挾帶的 CORS 資訊不相同
    - 無論 preflight 及 actual response 夾帶 `Access-Control-Allow-Origin`
        - 也就是說在這兩階段都會分別做一次驗證

```yaml
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://web.example.com  # necessary
Vary: Accept-Encoding, Origin
Content-Encoding: gzip
Content-Length: 337
...
```
