# [Module ngx_http_core_module](http://nginx.org/en/docs/http/ngx_http_core_module.html#try_files)

> 此為 Nginx 的 http 核心模組

## Directives:

### root

- Syntax:
    - `root path;`
        - path 可以包含變數, 但 `$document_root` && `$realpath_root` 除外
- Default: `root html;`
- Context: http, server, location, if in location

> root directory for requests

```conf
location /i/ {
    root /data/w3;
}
# 「/i/top.gif」 的 Request, 會以 「/data/w3/i/top.gif」 做為 Response
```

文件路徑是基於 `root` 再增加一個 URI 來構成. 如果必須修改 URI, 則須再搭配 `alias` 來使用


### alias

- Syntax:
    - `alias path;`
        - path 可以包含變數, 但 `$document_root` and `$realpath_root` 除外
- Default: -
- Context: location

> Defines a replacement for the specified location.

```conf
location /i/ {
    alias /data/w3/images/;
}
# 「/i/top.gif」的 Request, 會以 「/data/w3/images/top.gif」做為 Response
```


### try_files

- Syntax:
    - `try_files file ... uri;`
    - `try_files file ... =code;`
- Default: -
- Context: server, location

> Checks the existence of files in the specified order and uses the first found file for request processing; the processing is performed in the current context. The path to a file is constructed from the file parameter according to the `root` and `alias` directives. It is possible to check directory’s existence by specifying a slash at the end of a name, e.g. “$uri/”. If none of the files were found, an internal redirect to the uri specified in the last parameter is made. (看的不是很懂=.=)

### 