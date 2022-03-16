# Regex

- 2021/03/16

> 須留意, Regex 比對基本上是一種概念, 在各個領域的實作多少有落差!


## 次數

```
? : 0 或 1 次
+ : 1 次以上
* : 0 次以上

\<      單字字首
\>      單字字尾
^       行開頭
$       行結尾

c.\{1,3\}t.     c_t 或 c___t
c.\{2\}t        c__t
c[aou]*t        c 與 t 中間可包含任意多個 a,o,u
```


## grep + re

Option    | Function
--------- | -------------
-i        | 不分大小寫
-v        | 只顯示 NOT Match 到的部分
-r        | 在 Dir 內, recursively 找檔名
-A NUMBER | 後 N 行
-B NUMBER | 前 N 行
-e        | With multiple -e options used, multiple re can be supplied and will be used with a logical or.
-s        | 比對任何空白字元

```sh
# 找出 nginx.conf 非為 註解的部分
$ grep -v '^ *#' /etc/nginx/nginx.conf
user                                    root;
worker_processes                auto;
pid                                     /var/run/nginx.pid;

error_log                       /var/log/nginx/error.log;

events {
    worker_connections  512;
}

http {
    include                     /etc/nginx/mime.types;
    default_type                application/octet-stream;

    access_log                  /var/log/nginx/access.log ;

    sendfile            on;

    keepalive_timeout   65;

    include /etc/nginx/sites-enabled/*;
}

# 找出 linux.words 以 dog 或 cat 開頭的部分
$ grep -e '^dog' -e '^cat' /usr/share/dict/linux.words
cat
cat.
cata-
...等 995 行

# 不分大小寫(("Apr 1 15:53" 或 "Apr 1 15:54") + 任意0~多字元 + 'ERROR') 的每行 |
# 非為 (小寫 && 數字)重複32 次以外的部分
$ grep -i '^Apr 1 15:5[34].*ERROR' /var/log/messages | grep -v '[a-z0-9]\{32\}'

# 符合 14:40 那行之後的 24 行
$ grep -A 24 '14:40' proxy.log
```

> (\w+)\s+\1

```python
>>> p = re.compile(r'\b(\w+)\s+\1\b')
>>> p.search('Paris in the the spring').group()
'the the'
```


# 萬用字元 && Regex

* [^abc] : 非 [abc] 其中一個字
* ^[abc] : [abc] 其中一個字開頭