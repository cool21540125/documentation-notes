# CloudFlare Cache

CF 的快取行為, 基本上會遵照 origin server 的配置, 然而如果有配置 Edge Cache TTL cache rule, 則會覆寫掉 origin server 的快取規則

- CF 針對下列因素對 static content 做快取:
  - Caching levels
  - File extensions
  - Presence of query strings
  - Origin cache-control headers
  - Origin headers that indicate dynamic content
  - Cache rules that bypass cache on cookie
- CF 在下列情況下, 不會快取:
  - `Cache-Control` 設為 `private, no-store, no-cache, or max-age=0`
  - `Set-Cookie` header 存在
  - HTTP method 非為 `GET`
- CF 在下列情況下, 會快取:
  - `Cache-Control` 設為 `public and max-age > 0`
  - `Expires` header 設為 future date
- 如果 Origin 並沒有配置 `Cache-Control 或 Expires` header, CF 會對不同的 HTTP response status code 做不同時間的快取
  - HTTP 200, 206, 301 : Cache 120 mins
  - HTTP 302, 303 : Cache 20 mins
  - HTTP 404, 410 : Cache 3 mins
  - other (不會快取)
- CF 的「預設快取副檔名」(並非 MIME type)如下 (並且預設不會快取 HTML 及 JSON):
  - CSS / CSV / JS / PNG / JPG / ....(基本上都是常見的靜態資源副檔名)