# [Module ngx_http_stub_status_module ](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html)

> The ngx_http_stub_status_module module provides access to basic status information.

```bash
### 此模組並不會預設安裝
nginx -V | grep --whth-http_status_module
# 用來測試 Nginx 主機能否使用此功能
# 若要啟用, 安裝時必須搭配 --with-http_stub_status_module
```

```conf
# Example
location = /nginxstatus {
    stub_status on;
    # ↑ v1.7.5 以前用法
    # ↓ v1.7.5 以後用法
    stub_status;
}
```


## Directives

- Key: `stub_status;`
    - Default: -
    - Context: server / location


## Example

```bash
$# curl 127.0.0.1/nginxstatus
Active connections: 291 
server accepts handled requests
 16630948 16630948 31070465 
Reading: 6 Writing: 179 Waiting: 106 
# Active connections: Active client 的目前連線數(包含 Waiting connections)
#    Reading + Writing + Waiting
# accepts: 已接受的連線數
# handled: 已處理的連線數. 
#    此值基本上同 accepts, 除非請求達到 resource limits(ex: worker_connections limit)
# requests: Client Requests 的總數
# Reading: Nginx 正在 Reading Request Header 的當前連線數
# Writing: Nginx 正在 Writing 給 Client 的 Response 的當前連線數
# Waiting: 連線中的 Idle client 的連線數 (Server 正在等候請求)
```


## Embeded Variables

此模組提供的變數:

- $connections_active  : 等同 Active connections
- $connections_reading : 等同 Reading
- $connections_writing : 等同 Writing
- $connections_waiting : 等同 Waiting