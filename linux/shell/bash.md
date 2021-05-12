# bash


```bash
$ echo $$
1631
# 可看到目前 shell 的 PID
```

## 快速命令

```sh
# 為指令設定別名 (只作用於目前 session)
$ alias lm='ls -al | less'

# 查看已經設過那些變數
$ alias
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias vi='vim'
alias ls='ls --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias lm='ls -al | less'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

# 取消 已經設定過的別名
$ unalias lm
```

```bash
cat <<EOF >> ~/.bashrc

### Docker 懶人指令 ------------
alias d='docker'
alias dis='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dn='docker network'
alias dv='docker volume'
alias dex='docker exec -it'
alias di='docker inspect'
alias dc='docker-compose'
alias dl='docker logs -f'
alias diip='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dienv='docker inspect --format="{{json .Config.Env}}"'

EOF
```


## 變數相關

- export:  自訂變數 -> 環境變數 (子程序就能用到了)
- declare: 環境變數 -> 自訂變數
- 自訂變數 = 區域變數
- 環境變數 = 全域變數

查看 環境變數
```sh
### A. 可看到所有的 環境變數
$ env
HOSTNAME=desktop22                  # 主機名稱
SHELL=/bin/bash
TERM=xterm                          # 終端機環境
HISTSIZE=1000                       # 紀錄指令的筆數(history筆數)
USER=root
SUDO_USER=student
SUDO_UID=1000
USERNAME=root
PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin    # 執行檔 or 指令 搜尋位置
MAIL=/var/spool/mail/root           # MailBox 位置
PWD=/root                           # User 目前位置
LANG=en_US.UTF-8
HOME=/root                          # User Home Dir
LOGNAME=root                        # 登入者用來登入的帳號(疑!?)
SUDO_GID=1000
_=/bin/env
# 節錄大部分

### B. 可看到所有的 環境變數 && bash 相關變數 && 使用者自定義變數
$ set
# 總共有2500多筆@@...

### C. 可看到所有的 環境變數 (還有額外功能)
$ export
declare -x HISTCONTROL="ignoredups"
declare -x HISTSIZE="1000"
declare -x HOME="/home/tony"
declare -x HOSTNAME="tonynb"
declare -x LANG="zh_TW.UTF-8"
...(略)... 約 30 個
```


### 查看 && 宣告 變數 declare (同 typeset?)
bash 環境預設變數都是 `字串`, 如果要計算的話, 頂多只能做 `整數運算`

```sh
$ declare [-aipr] variable
# -a : 讓 variable 變成 陣列
# -i : 讓此變數為 整數  (bash環境的計算, 只能有 int, 無法有 float, decimal 等等的鬼東西)
# -p : 可以看此變數的類型 (類似看到整個變數宣告過程)
# -r : 讓此變數變成常數的概念 (也不能 unset)
# -x XXX: XXX 變成環境變數
# +x XXX: XXX 從環境變數中取消

$ declare -i ss=80+3
$ echo $ss

### 陣列
# var[idx]=content
$ name[1]=tony
$ name[2]=tiffany

$ echo "${name[1]}'s sister is ${name[2]}"
```


### 變數替換 - 「#」 與 「%」

```sh
a="123-456-789"
echo ${a}
#123-456-789

### 移除最短匹配(由前開始)
echo ${a#*-}
#456-789

### 移除最長匹配(由前開始)
echo ${a##*-}
#789

### 移除最短匹配(由後開始)
echo ${a%-*}
#123-456

### 移除最長匹配(由後開始)
echo ${a%%-*}
#123

# --------------------------
### 測試是否包含
name=tonychou
test "${name#*-}" = "${name}"
echo $?
#0

### 測試是否包含
name=tony-chou
test "${name#*-}" = "${name}"
echo $?
#1
```


```bash
### 判斷資料夾是否存在
if [ -d "/data" ]; then
	echo 'Exists'
else
  echo 'No such dir'
fi
```


### 變數取代

```sh
DEMO='a=1,b=2,c=3'
echo ${DEMO}
#a=1,b=2,c=3

echo ${DEMO/a=1,}  # ${xxx/yyy} 裡頭的 /yyy  會把這部分捨去掉
#b=2,c=3
echo ${DEMO/b=2,}  # ${xxx/yyy} 裡頭的 /yyy  會把這部分捨去掉
#a=1,c=3

# ------------------------------------------
NAME=tony
AGE=30;unset AGE
echo ${NAME}
#tony

### 如果存在則印出 ; 若不存在則印出 後者
echo ${NAME-nobody}
#tony

echo ${NAME:-nobody}
#tony

### 會把 不存在 or "" 當成一樣
echo ${AGE-DoesntKnow}  
#DoesntKnow

echo ${AGE:-DoesntKnow}
#DoesntKnow
```


### set 進階用法, docker-entrypoint.sh 常見

- [What does “set --” do in this Dockerfile entrypoint?](https://unix.stackexchange.com/questions/308260/what-does-set-do-in-this-dockerfile-entrypoint)

ex: `set -- redis-server "$@"`

```bash
### 首先, set 的一些基本特性
set a b c
echo $1 $2 $3
#a b c
# ↑ set 指令用來設定 位置參數
```

`set -- xxx "$@"` 裡的 `--` 是一種標準, 用來表示不要把跟隨在 `xxx` 後面的 `"$@"` 當成 option (而是當作 params)

如範例, 因此將會把 `redis-server` 放到 $1 $2 之前

> The other main difference is that if you are sourcing a script inside of another script, using `set -- $arg1 $arg2` will allow your sourced script to read the arguments, otherwise only Bash supports passing arguments directly to a sourced script (and that can be tricky to notice)

↑ 看起來是, 可讓被 source 的腳本可以讀取參數

```bash
set -- redis-server "$@"
```


範例1:

[Registry](https://github.com/docker/distribution-library-image/blob/registry-2.7.1/amd64/docker-entrypoint.sh)

```bash
### 運行容器方式: 「/entrypoint.sh /etc/docker/registry/config.yml」
set -- registry serve "$@"
# ↑ shell 執行上面的動作
# ↓ 腳本內便可使用 「exec "$@"」 來作變數呼叫 & 執行
echo $1
#registry
echo $2 
#serve
echo $3
#/etc/docker/registry/config.yml
```



### 陣列變數
```sh
$ var[1]=Tony
$ var[2]=Chou
$ echo ${var[1]}, ${var[2]}
Tony, Chou
```


### 更改 tty (前置字元)
```sh
[tony@tonynb dev]$ set | grep PS1
PS1='[\u@\h \W]\$ '
# 即為「[使用者@主機名稱 目前位置]$」

[tony@tonynb dev]$ echo ${PS1}
[\u@\h \W]\$                ## 預設的 PS 顯示格式, 玩壞了再從這改回去
# PS1 為命令提示字元
# 另外也可設定 PS2, 在指令行最後面下「 \」 換行後, 格行的命令提示字元(預設為 > )

[tony@tonynb dev]$
  ↑    ↑      ↑
  \u   \h     \W
# 顯示格式的概念啦@@

[tony@tonynb dev]$ echo ${PS2}
>

# 因為有太多太多了... 可去 `man bash` 搜尋 `PS1` 或 `看鳥哥`
# http://linux.vbird.org/linux_basic/0320bash.php
```


##### tty 的相關變數參考
symbolic | Description
-------- | -------------------
\h       | 第一個小數點前的`主機名稱`
\@       | 顯示時間, 格式為 am/pm
\u       | 使用者帳號
\w       | 完整工作名稱
\W       | 最相近的目錄名稱 (用 basename 函數算出來的)
\t       | 24小時格式的時間 HH:MM:SS
\\$      | root為 # ; 否則為 $

```sh
# 自己玩 PS1
# 如果想要看起來是這樣 「<<(使用者帳號)@我最強 (時間)>>$ 」
[tony@tonynb home]$  PS1='[@@ \u最強 \t \W]$ : '
[@@ tony最強 22:17:38 ~]$ :               # 之後就會變成這樣了@@
```


### 查看目前的程序 「$」變數
```sh
$ ps
  PID TTY          TIME CMD
24031 pts/0    00:00:00 bash
31492 pts/0    00:00:00 ps

# 查看目前的程序
$ echo ${$}
24031               # 此即為 程序識別碼 或稱為 PID (Process ID)
```


### 「?」 變數
```sh
# 「?」 代表上次執行完後回傳的值, 若上次指令結束時`沒有出錯`, 則 `?` 為 0 ; 否則會是 > 0 的值

$ echo ${HOME}
$ echo ${?}
0               # 上次指令語法無誤

$ 12name=tony
$ echo ${?}
127             # 上次指令有錯
```


### read (就是 inputBox(vb), prompt(js) 啦)
```sh
$ read [-pt] variable
# -p : 提示字元
# -t : 此 inputbox 的等待秒數

$ read -p "Your name: " -t 5 name
Your name:
# ↑只會等待 5 秒讓使用者輸入

# 底下為簡單用法
$ read name
Tony

$ echo ${name}
Tony
```

### history, CLI: `!<history id>`

快速執行歷史指令
```sh
history
#   784  ...
#   785  echo ${PATH}
#   786  ...

### 執行歷史
!785   
#echo ${PATH}
#/opt/anaconda3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

### 執行歷史(最近一次執行過「echo」開頭的指令)
!echo
#echo ${PATH}
#/opt/anaconda3/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
```


# login shell 與 non-login shell

Note: 載入 環境變數 設定檔的指令, `source ~/.bashrc` 與 `. ~/.bashrc` 相同; 重點在於「source」與「.」

## 1. login shell (取得登入資訊)

登入後, 取得 bash 的讀取順序

```sh
   # 1 系統設定檔
|- /etc/profile
|      |
|      |- /etc/profile.d/*.sh                      : 裡面各個檔案分別建立的 ll, ls, which, vi, --color 等等
|      |- /etc/locale.conf                         : 由 /etc/profile.d/lang.sh 呼叫存取, 決定 LANG 採用的語系
|      |- /usr/share/bash-completion/completions/* : 各種語法補齊檔, 由 /etc/profile.d/bash_completion.sh 呼叫
|
|  # 2 使用者偏好設定檔 (依照順序, 只讀取一個, 若存在的話就先採用了)
|- ${HOME}
    |-   ~/.bash_profile   # 用戶登入的時候被讀取
    |-   ~/.bashrc         # 啟用新的 Shell 被讀取 (由 ~/.bash_profile 來驅動 或 non-login shell)
    |-   ~/.bash_login
    |-   ~/.profile
    |-   ~/.bash_logout    # Shell 登入退出時執行
```

## 2. non-login shell

取得 bash 後, 僅讀取 `~/.bashrc`, 而此檔案再次呼叫 `/etc/bashrc`

而 `/etc/bashrc` 再幫忙定義 `umask`, `PS1`, 並呼叫 `/etc/profile.d/*.sh`

```sh
# 所以如果看到 bash 的提示字為
-bash-4.2$

# 表示 ~/.bashrc 可能出問題了!! (不影響 bash 使用)
# 可去複製 /etc/skel/.bashrc 回家目錄, 再來修改~
```

#### 多行註解

```sh
#!/bin/bash

:<<BLOCK
這裡面都是註解~~~
echo 'none'
這裡面都是註解~~~
這裡面都是註解~~~
BLOCK

echo 'hi'
```

# 其他

- `~/.bash_history` : 前一次登入以前所執行過的指令 ; 此次登入時執行的指令會愈存在 memory, 登出時會寫入此檔案
- `~./bash_logout` : 可在裡面定義好, 登出後, 系統幫忙做些什麼

```sh
# 列出所有 環境變數 + 與bash操作介面有關的變數 + 使用者自定義的變數
$ set
(會跑出超多超多超多~~~變數)
```


##### CLI: `tr`, CLI: `unix2dos`, CLI: `dos2unix`
```sh
# 常常 Linux 開啟 Windows 編輯後的檔案會有 `^M` 這東西

$ sudo yum install -y unix2dos dos2unix
$ cp /etc/passwd ~/.
$ file /etc/passwd ~/passwd 
/etc/passwd:       ASCII text
/home/tony/passwd: ASCII text, with CRLF line terminators  # <- 就是 ^M

### 解法1
$ cat ~/passwd | tr -d '\r' > ~/passwd.linux
$ ll /etc/passwd ~/passwd*
-rw-r--r--. 1 root root 1075 Nov  3 01:41 /etc/passwd              # 兩個變一樣了
-rw-r--r--. 1 tony tony 1097 Nov 13 23:47 /home/tony/passwd
-rw-rw-r--. 1 tony tony 1075 Nov 13 23:55 /home/tony/passwd.linux  # 兩個變一樣了

### 解法2
$ dos2unix ~/passwd
dos2unix: converting file /home/tony/passwd to Unix format...
# 上面這步驟, 會把原始檔案蓋過去...
```


##### CLI: `${RANDOM}`
```sh
# 產生 [0, 32767] 之間的亂數
$ echo ${RANDOM}
14852
```


#### CLI: `type`
```sh
# 查詢指令是否為 bash shell 的內建命令
$ type ls
ls is aliased to `ls --color=auto`

$ type -a ls
ls is aliased to `ls --color=auto`  # 顯示全部(別名, builtin bash, $PATH)
ls is /usr/bin/ls

$ type cd
cd is a shell builtin
```


## Win10 GitBash 問題

- 2020/04/16

最近不知道怎麼了, win10 開啟 GitBash, 偶爾會看到這個

![GitBashError](../../img/GitBashError.png)

```bash
### 打開 cmd
$# taskkill /F /IM ssh.exe
# 下場, 已經正常 work 中的 terminal 可能會無法動作
# 要把 (所有) GitBash 關掉!?
# 重新開啟 GitBash 即可恢復正常
```


# 最佳實務

- [Bash best practices](https://gist.github.com/leolorenzoluis/0aad69719267536d0b7a79946edbfcb7)

- ShellScript 最前面永遠使用 `set -eo pipefail`, fail fast and be aware of exit codes