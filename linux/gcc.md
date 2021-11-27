


# Problems


```sh
### CentOS7 的 docker image 內部, 編譯安裝 git 發生錯誤的解法
$# make
    * new build flags
    CC credential-store.o
In file included from credential-store.c:1:0:
cache.h:42:18: fatal error: zlib.h: No such file or directory
 #include <zlib.h>
                  ^
compilation terminated.
make: *** [credential-store.o] Error 1

### Solution
$# yum install zlib-devel
```