# Ch12 - Bash Conditionals and Control Structures

1. Shell Script
2. exit code
3. if
4. for


## 1. Shell Script

```sh
# 假如有個腳本 /usr/bin/useme
$# echo '#!/bin/bash' > /usr/bin/useme
$# echo 'echo $((${1}+${2}))' >> /usr/bin/useme
$# chmod +x /usr/bin/useme
$# /usr/bin/useme 3 8
11
# 可執行該腳本, 並且傳入第一個參數 3, 第二個參數 8
# 則腳本裏頭, 使用
# 「$1」抓出第一個參數
# 「$2」抓出第二個參數
# 「${10}」 抓出第十個參數, 勿用「$10」, 因為會被當成 「$1」+'0'
```


## 2. exit code

回傳 `最近一次` 指令的執行結果(0代表無誤)

```sh
### 範例1
$ ls /nothing
ls: cannot access /nothing: No such file or directory

$ echo $?
2           # ← 回傳的 非0 值

### 範例2
$ ls /home
tony

$ echo $?
0           # ← 「最近一次指令」執行後, 沒有任何錯誤的話, 會回傳 0

### 範例3
$ grep no_such_user /etc/passwd

$ echo $?
1           # ← 上一個指令, 看起來是沒有任何錯誤, 但卻回傳 非0 值...
```


## 3. if

```sh
#!/bin/bash

USER=$1   # 第一個參數放 USER

if [ "$#" -eq 0 ]; then
    echo '沒給參數'
    exit 1
fi

if [ "$USER" = 'root' ]; then   # if [], 記得加上「"$OOXX"」
    echo '妳腦殘嗎'
    exit 87
fi

useradd ${USER}
```


## 4. for

```sh
#!/bin/bash

for i in $(seq 1 50); do
    echo $i
done
```

