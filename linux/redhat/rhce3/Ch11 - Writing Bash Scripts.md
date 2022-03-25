# Ch11 - Writing Bash Scripts

1. Shebang Line
2. Shell Script
3. 指令順序

## 1. Shebang Line

* 預設執行程式, 寫在第一行

```sh
$ echo '#!/bin/bash' > hi.sh
$ echo  "echo I am Smart" >> hi.sh
$ chmod +x hi.sh
$ ./hi.sh
I am Smart
```

```sh
$ echo '#!/usr/bin/python' > hi.py
$ echo 'print("I am Smart")' >> hi.py
$ chmod +x hi.py
$ ./hi.py
I am Smart
```


## 2. Shell Script

```sh
$ First=Chou
$ Last=Tony
$ echo $First$Last          # 必較沒那麼好
$ echo ${First}${Last}      # 比較建議
$ echo "${First}${Last}"    # 在 if then 裏頭, 用 "" 包起來比較好
# ↑ (好像是比較早期的 CentOS 版本需要這樣...)
# EX:
# size=30
# if [ $size -gt 20 ]; then
#   echo "Too big"
# fi
```


## 3. 指令順序

1. 相對/絕對路徑下的指令 (但因為 Linux 安全性問題, 執行本地資料夾檔案, 需使用 「./」 開頭)
2. alias
3. bash builtin script
4. 利用 $PATH 查找

