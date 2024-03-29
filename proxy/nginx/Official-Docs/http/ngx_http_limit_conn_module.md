[Module ngx_http_limit_conn_module](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html)

> The ngx_http_limit_conn_module module is used to limit **the number of connections per the defined key**, in particular, the number of connections from a single IP address.

對每個來源 IP 作連線訪問的限制

```conf
http {
    limit_conn_zone $binary_remote_addr zone=addr:10m;
    server {
        location /download/ {
            limit_conn addr 1;
        }
    }
}
```


# Directives

### [limit_conn](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn)
- Syntax: `limit_conn zone number;`
- Default: -
- Context: http / server / location


### [limit_conn_dry_run](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_dry_run)

- Syntax: `limit_conn_dry_run on | off;`
- Default: `limit_conn_dry_run off;`
- Context: http / server / location


### [limit_conn_log_level](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_log_level)

- Syntax: `limit_conn_log_level info | notice | warn | error;`
- Default: `limit_conn_log_level error;`
- Context: http / server / location


### [limit_conn_status](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_status)

- Syntax: `limit_conn_status code;`
- Default: limit_conn_status 503;
- Context: http / server / location

連線訪問若達到上限, 設定 Response Status Code


### [limit_conn_zone](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_conn_zone)

- Syntax: `limit_conn_zone key zone=name:size;`
- Default: -
- Context: http


### [limit_zone](http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html#limit_zone)

- Syntax: `limit_zone name $variable size;`
- Default: -
- Context: http


# Embedded Variables

- $limit_conn_status : keeps the result of limiting the number of connections.
    - 如下幾種:
        - PASSED
        - REJECTED
        - REJECTED_DRY_RUN