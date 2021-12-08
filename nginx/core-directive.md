
URI, 統一資源標識符, Uniform Resource Identifier

> scheme:[//[user[:password]@]host[:port]][/path][?query][#fragment]

- Nginx 的應用場景中, URL 與 URI 無明顯區別.
    - 但在 RFC3986 規定, URL 為 URI 的子集
- scheme 常見為 HTTP, HTTPS



```conf
http {
    error_page 404              /404.html;
    error_page 500 502 503 504  /50x.html;

    error_page 403 = @fallback;
    location @fallback {
        proxy_pass http://backend;
    }

    error_page 401 =200    /empty.gif;  # 漂白
}
```