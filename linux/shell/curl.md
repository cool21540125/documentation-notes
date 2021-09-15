# curl 指令工具

- [curl command](https://gist.github.com/subfuzion/08c5d85437d5d4f00e58)
- 2019/01/16


```sh
### 基本語法
$# curl -X<Verb> '<Protocol>://<Host>:<Port>/<Path>?<Query_String>' -d '<Body>'
# -H : 預設的 Content-Type: application/x-www-form-urlencoded
# -d : Request Body (Key1=Value1&Key2=Value2)
# -L : 若 URL 經由 3XX 作重導, 則自動導向該頁面
# -X <VERB> : Request Method (GET, POST, PUT, HEAD, DELETE, ...)
# -O : 把爬下來的東西寫入到檔案系統
# -I : 僅擷取 HTTP-head
# -i : 包含 HTTP-header
# -k : 允許不安全的 https(未經過)
# -s : (silent) 不顯示進度及錯誤訊息
# -4 : 使用 IPv4 位址作解析
# -6 : 使用 IPv6 位址作解析
# -v : 列出詳細資訊(Debug使用居多)


### ----------------------------------------------------------------------
### Example
# 使用檔案作 POST
curl -X POST -d "@data.txt" http://localhost:3000/data

# 使用 JSON 作 POST
curl -d '{"k1": "v1", "k2": "v2"}' -H "Content-Type: application/json" -X http://localhost:8000/data
```

## hacking curl (讓 curl 變好用!? )

```sh
$# mkdir ~/bin
$# vim ~/bin/curl
$# echo '#!/bin/bash' > ~/bin/curl
$# echo '/usr/bin/curl -H "Content-Type: application/json" "$@"' > ~/bin/curl
$# chmod +x bin/curl

# 將來使用 curl 就可以省略掉 application/json 那一包了~
```

```sh
curl --unix-socket /path-to-docker/docker.sock http://localhost/version
```

```bash
$# DOMAIN=tonychoucc.com
$# IP=1.2.3.4
$# curl -sv --resolve www.${DOMAIN}:${IP} https://www.${DOMAIN}/checked
```