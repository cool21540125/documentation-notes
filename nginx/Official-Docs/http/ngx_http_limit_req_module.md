# [Module ngx_http_limit_req_module](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html)

> The ngx_http_limit_req_module module is used to limit **the request processing rate per a defined key**, in particular, the processing rate of requests coming from a single IP address. The limitation is done using the “leaky bucket” method.

對每個來源 IP 作請求訪問的限制

```conf
http {
    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
    server {
        location /search/ {
            limit_req zone=one burst=5;
        }
    }
}
```

關於 `leaky bucket` 的解釋, 參考 [Nginx下limit_req模块burst参数超详细解析](https://blog.csdn.net/hellow__world/article/details/78658041)

可用 `Traffic Shaping` 或是 `Traffic Policing` 來處理:

- Traffic Shaping : 流量整形, 暫時停止過多來源流量, 等到流量疏通後, 在予以放行. (核心思想: 等待~)
- Traffic Policing : 流量管制, 對於過多流量, 則予以丟棄. (核心思想: 太多就扔)


## Directives

- Key: `limit_req zone=name [burst=number] [nodelay | delay=number];`
    - Default: -
    - Context: http / server / location
    - 解讀:
        - 設定 shared memory zone 及 最大的請求突發大小. 若請求超出此 zone 定義的大小, 請求會被 delay
            - 這些被 delay 的過多請求, 若超過了 burst size, 則拋出 `limit_req_status code` 的錯誤
        - 預設的 burst = 0
            - ex:
                ```conf
                limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;

                server {
                    location /search/ {
                        limit_req zone=one burst=5;
                    }
                ```
                - http block 的 **zone=one:10m** : 產生一個大小為 10M, 名字為 one 的內存區域, 用來儲存訪問的頻率資訊
                - http block 的 **rate=1r/s** : 限制來自相同用戶的訪問限制. 此為每秒只處理一次請求. 若要每 2 秒處理 1 次請求, 則要寫成 **rate=30r/m**
                - location block 的 **zone=one** : 使用 http block 的 **zone=one** 配置 來作限制
                - location block 的 **burst=5** : 過量訪問的緩衝區(等待區), 也就是有 5 個排隊的名額, 超出的話就會被丟棄
                - 允許每秒不超過 1 次的請求, burst 不超過 5 次請求
            - 如果有設定 `nodelay`:
                - 可瞬間提供額外的 **burst + rate** 的請求處理能力 (但超出者一樣丟棄), 也就是不會有 **請求需要等待的狀況**
                    - rate 指的是 r/s
                    - ex: `limit_req zone=one burst=5 nodelay;`
                - 如果沒設定的話, 則所有請求都會排隊等待....
            - v1.15.7+, `delay` 被預設為 0, 也就是, 所有過多請求都會被 delay
        - 可同時存在多個 `limit_req`, ex:
            ```
            limit_req_zone $binary_remote_addr zone=perip:10m rate=1r/s;
            limit_req_zone $server_name zone=perserver:10m rate=10r/s;

            server {
                ...
                limit_req zone=perip burst=5 nodelay;
                limit_req zone=perserver burst=10;
            }
            ```
            - 上述配置會限制 來自單一 IP 的 request processing rate, 同時
- Key: `limit_req_dry_run on | off;`
    - Default: `limit_req_dry_run off;`
    - Context: http / server / location
- Key: `limit_req_log_level info | notice | warn | error;`
    - Default: `limit_req_log_level error;`
    - Context: http / server / location
- Key: `limit_req_status code;`
    - Default: `limit_req_status 503;`
    - Context: http / server / location
    - 請求達到訪問限制, 則 Response Status Code 503
- Key: `limit_req_zone key zone=name:size rate=rate [sync];`
    - Default: -
    - Context: http
    - 自己的了解:
        - 為來源請求端的 states, 設定 parameters 到 Shared memory zone
            - 此 states 儲存了 目前過多的請求數.
            - key 可以是 text, variables, text + variables
            - ex: `limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;`
                - states 維持了 10MB 的 "one"(zone名稱) zone
                - 這個 zone 的平均請求, 每秒不能超過 1 次
                - 此範例拿 client IP address 當成 key
                    - `$binary_remote_addr`
                        - 會用 4 bytes 紀錄 IPv4, 並用 16 bytes 紀錄 IPv6
                        - 32位元電腦, 會用 64 bytes 紀錄 states
                        - 64位元電腦, 會用 128 bytes 紀錄 states
                    - `$remote_addr` : 尚未知
            - 如果 zone storage 被耗盡了. 則最久以前的 state 會被移除
            - 如果 new state 無法被建立的話, 請求會被中斷, 並拋出 `limit_req_status code` 的錯誤
        - sync 參數則是允許同步到 memory zone