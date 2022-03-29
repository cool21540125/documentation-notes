[Module ngx_http_rewrite_module](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html)

- 參考: https://www.nginx.com/blog/creating-nginx-rewrite-rules/



## break



## if (罪惡!)

if 會破壞 nginx conf 的閱讀!! 除非必要, 不然不要使用!!

```
Syntax:	    if (condition) { ... }
Default:	—
Context:	server, location
```

## return



## rewrite

```
Syntax:	    rewrite regex replacement [flag];
Default:	—
Context:	server, location, if
```




## rewrite_log



## set



## uninitialized_variable_warn


