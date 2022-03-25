# Ch2  - Using Regular Expressions with grep

1. regex
2. grep
3. 玩lab


## 1. regex

    使用 「\」
    可將「有Shell意義的符號」→「純文字」
    或
    將「純文字」→ 「有Shell意義的符號」

```sh
cd /usr/share/dict/

grep '^cat' /usr/share/dict/words               # cat開始
grep 'cat$' /usr/share/dict/words               # cat結尾
grep '^azy.*s$' /usr/share/dict/words           # azy開頭, s結尾, 中間不管(.*)
grep '^p[abc]' /usr/share/dict/words            # p開頭, 緊接著 a 或 b 或 c
grep '[a-c]$' /usr/share/dict/words             # a 到 c 任一字結尾
grep 'c.\{2\}t.' /usr/share/dict/words          # c__t_ 模式的文字, 「__」為中間塞兩個任意字(.\{2\})
grep 'c[aou]*t' /usr/share/dict/words           # c 「a 或 o 或 u」(不限次數)t
grep -v "^[-'a-zA-Z0-9]" /usr/share/dict/words  # 找出 非「a-z && A-Z && 0-9 && - && '」開頭的字

### quiz: 怎麼查出所有 「al開頭, 並且.結尾的所有字」
# 結果可以篩選出
# al.
# alg.
# alk.
# alt.
# alum.

##### 解答在最下面
```


## 2. grep

get regex pattern (Windows用 findstr)

```sh
###
$ ps au | grep 'tony'
tony     15950  0.0  0.1 151772  5772 pts/2    S+   15:13   0:00 vim RH134-Ch2.md
tony     16085  0.0  0.0 182996  3888 pts/0    S+   14:52   0:00 ssh localhost
tony     16208  0.0  0.0 116492  3200 pts/2    Ss   14:52   0:00 -bash
tony     19802  0.0  0.0 116364  3052 pts/0    Ss   14:00   0:00 -bash
tony     21885  0.0  0.0 116232  2928 pts/1    Ss   14:00   0:00 -bash
tony     27829  0.0  0.0 155324  1880 pts/1    R+   15:28   0:00 ps au
tony     27830  0.0  0.0 112720   968 pts/1    S+   15:28   0:00 grep --color=auto tony


### 非 #(註解) 開頭
$ grep -v '^[#;]' /etc/fstab

/dev/mapper/centos-root                     /        xfs        defaults    0 0
UUID=32e1b5c9-e273-4c5f-bb3d-12e3bfb0a0b1     /boot    xfs     defaults    0 0
/dev/mapper/centos-home                     /home    xfs     defaults    0 0
/dev/mapper/centos-var                      /var    xfs     defaults    0 0
```


## 3. 玩 lab

    lab/
        /door.log
        /proxy.log
        /wall.log

使用 `grep` 當偵探

從 `door.log` 找出 `Aug 8 13:00~15:00` 之間的 Log... 並開始尋找蛛絲馬跡.........

最終結果會找到曠世巨作


### Answer

```sh
cat proxy.log | grep -A 24 14:40
# grep 的 -A xxx, 可抓取後面找到的 Pattern 的下 xxx 行
```