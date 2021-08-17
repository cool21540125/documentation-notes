# caddyserver

- 2020/04/02
- [官網](https://caddyserver.com/)
- [一堆Caddy使用範例](https://github.com/caddyserver/caddy)
- [Caddy Documentation 1](https://caddyserver.com/v1/docs)
- [Caddy Documentation 2](https://caddyserver.com/docs/getting-started)


## Install

```bash
### macbook
$# brew install caddy
Updating Homebrew...
==> Auto-updated Homebrew!
Updated 1 tap (homebrew/cask).
==> Updated Casks
ithoughtsx                                                                                 shinhan-ezplus

==> Downloading https://homebrew.bintray.com/bottles/caddy-1.0.5.catalina.bottle.tar.gz
Already downloaded: /Users/tony/Library/Caches/Homebrew/downloads/d23f06644034092ed9f38815513df252b948766a914d4ea74ecead264d63f6b5--caddy-1.0.5.catalina.bottle.tar.gz
==> Pouring caddy-1.0.5.catalina.bottle.tar.gz
==> Caveats
To have launchd start caddy now and restart at login:
  brew services start caddy
Or, if you don\'t want/need a background service you can just run:
  caddy -conf /usr/local/etc/Caddyfile
==> Summary
🍺  /usr/local/Cellar/caddy/1.0.5: 6 files, 20.7MB
```


# Usage

```bash
### for v1
### http://mygitea.com -> http://localhost:3000
# https://caddy.community/t/redirect-http-port-8080-to-https-80/4680
$# caddy -conf mygitea80_3000
Activating privacy features... done.

Serving HTTP on port 80
http://mygitea.com
```



# 對照

- 2020/04/03
- [使用 Caddy 替代 Nginx](https://diamondfsd.com/caddy-instand-nginx-support-https/)


```ini
### caddy
diamondfsd.com {  # 启动 http 和 https，访问 http 会自动转跳到 https
        log access_log.log  # 日志
        gzip  # 使用gzip压缩
        proxy / http://127.0.0.1:3999 { # 路径转发
                header_upstream Host {host}
                header_upstream X-Real-IP {remote}
                header_upstream X-Forwarded-For {remote}
                header_upstream X-Forwarded-Proto {scheme}
        }
}
```
```ini
server {
		server_name diamondfsd.com www.diamondfsd.com;
		listen 443;
		ssl on;
		ssl_certificate /etc/letsencrypt/live/diamondfsd.com/fullchain.pem;
		ssl_certificate_key /etc/letsencrypt/live/diamondfsd.com/privkey.pem;

		location / {
			proxy_pass http://127.0.0.1:3999;
			proxy_http_version 1.1;
			proxy_set_header X_FORWARDED_PROTO https;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_set_header Host $host;
		}

		location = /__check {
			return 200 'OK';
			add_header Content-Type text/plain;
		}

		# 可透過這樣來允許特定客戶端進行訪問
		location /__server_status {
			deny all;
			allow 100.101.102.103;
		}
    }
```