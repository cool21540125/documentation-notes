


```conf
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

### log example
162.158.119.85 - - [14/Sep/2021:09:07:32 +0000] "GET /ping HTTP/1.1" 200 2 "-" "Mozilla/5.0 ... Safari/537.36" "172.105.196.31"
```