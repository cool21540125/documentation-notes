
- 2019/05/02
- [鳥哥 shell script - $@](http://linux.vbird.org/linux_basic/0340bashshell-scripts.php)

```sh
$ vim publishconf

# ------------------------
#!/bin/bash
if [ $# >=3 ]; then
    shift 1

    for flat in "$@"; do
        echo "ip: ${flat}"
    done
fi
# $@ 與 $* 為特殊變數, 表示所有的參數位置
# 建議使用「"$@"」 而非 「$@」, 說明請見 鳥哥
# ------------------------

$ chmod u+x publishconf

# 透過 script, 移除第一個參數
$ ./publishconf   -p   1.1.1.1   2.2.2.2   3.3.3.3   4.4.4.4
ip: 1.1.1.1
ip: 2.2.2.2
ip: 1.2.3.6
ip: 4.4.4.4
```