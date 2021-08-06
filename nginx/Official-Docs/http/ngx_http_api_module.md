# [Module ngx_http_api_module](https://nginx.org/en/docs/http/ngx_http_api_module.html)

> The ngx_http_api_module module (1.13.3) provides REST API for accessing various status information, configuring upstream server groups on-the-fly, and managing key-value pairs without the need of reconfiguring nginx.

此模組(v1.13.3以後) 取代過去的 `ngx_http_status_module` && `ngx_http_upstream_conf_module`

若使用 `PATCH` / `POST`, 必須確保 payload 沒有超過 `buffer size`, 否則會拋出 413(Request Entity Too Large)


## Directives

- Key: `api [write=on|off]`
    - Default: -
    - Context: location
    - 可用來做為開關 `/api` 介面的快速開關


## Example

```bash

```