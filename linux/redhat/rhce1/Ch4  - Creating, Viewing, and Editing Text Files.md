# Channel 及 Vim

1. 標準I/O
2. 重新導向
3. 導向分支 - tee
4. 古老的文字編輯器 Vim


## 4.1 - 標準I/O

> Linux Process 皆由 `numbered channels (file descriptors)` 組成

Channels (File Descriptors) ((下表))

Number | Channel Name | Description
------ | ------------ | -----------
0      | stdin        | 標準輸入(keyboard) from 鍵盤
1      | stdout       | 標準輸出(terminal) to 螢幕
2      | stderr       | 標準錯誤(terminal) to 螢幕
3+     | filename     | Other files


## 4.2 - 重新導向

```sh
## 這邊的指令無法直接執行
> file                  # 重導 stdout -> file (覆蓋寫入)
>> file                 # 重導 stdout -> file (附加)
2> file                 # 重導 stderr -> file
2> /dev/null            # 不理會 stderr
& >> file               # 重導 stdout 及 stderr -> file  「& = stdout 和 stderr」
>> file 2>&1            # (同上)漂白 stderr -> stdout, 並且 -> file
2>&1                    # 漂白 stderr -> stdout
```

```sh
## 範例
date
date > f0.txt

echo 'Good' > f1
echo 'morning' > f2
echo 'bye' > f2         # 比較 > 與 >> 差異
echo ', ' > f3
echo 'POME' > f4
echo '!!' >> f4         # 比較 > 與 >> 差異

cat f1 f2 f3 f4 > pome

# 把 /root 及 /tmp 的東西印出來放到 f8, 錯誤部分 依照 stderr 管道輸出
ls /root /tmp 1> f8

# 把 /root 及 /tmp 的東西印出來放到 f9, 錯誤部分 重導 stderr 至 /dev/null(棄置)
ls /root /tmp 1> f9 2> /dev/null

# 指令
# find <位置> -name <要找的檔名>

# stdout 及 stderr -> 螢幕
find /etc -name passwd

# stdout -> 螢幕 ; stderr -> xxx (常用吧!?)
fild /etc -name passwd 2> ~/xxx

# stdout -> f1 ; stderr -> f2
find /etc -name passwd > f1 2> f2

# stdout -> correct ; stderr -> 丟棄 (常用吧!?)
find /etc -name passwd > correct 2> /dev/null

# stdout 及 stderr -> BB
find /etc -name passwd &> BB

# 忽略所有訊息
find /etc -name passwd &> /dev/null

ls /etc | wc -l > etc_length

ls /etc | head -n 10 > head10_etc
```


### 開啟兩個 Terminal

```sh
# Terminal A
$ tty
/dev/pts/0
```

```sh
# Terminal B
$ tty
/dev/pts/1
```

```sh
# Terminal A - 開始惡搞~~
$ echo '林老師勒~ 掯!' > /dev/pts/1
```

```sh
# Terminal B (不懂的人看了會以為被駭了...XD)
$ 林老師勒~ 掯!
```


## 4.3 - 導向分支 - tee

> 實務上用不太到 tee..., ex: 想把東西 print 出來, 同時又要 Log to File

```sh
# show 出 根目錄 底下的東西, 同時記錄到 f8
ls -l / | tee f8

# (同上), 但用分支 附加到 f8
ls -a ~ | tee -a f8
```


## 4.4 - 古老的文字編輯器 Vim

```sh
### Vim教學
vimtutor


### 產生預設的 vim 設定檔於 ~/.vimrc
mkvimrc


### 操作及設定備註
:x              # 存檔離開 :wq
:q!             # 強制離開不存檔
:set nu         # 顯示行號
:set mouse=a    # 使用滑鼠
:/xxx           # 搜尋  n:下一個 ; N:上一個
:noh            # 取消搜尋

gg              # 第一行
G               # 最後一行
28gg            # 指定行數

V               # 選整行
Ctrl + v        # 區塊選取

x               # 剪下
y               # 複製
p               # 貼上

u               # 回到上一步
.               # 重複上一個動作
Ctrl + r        # 取消上一個動作(回到前一個動作)
```
