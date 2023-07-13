
# 路徑與指令順序

1. 相對/絕對路徑下的指令
2. alias
3. bash builtin script
4. 利用 $PATH 查找


# User 登入取得的 Shell

1. login shell
2. non-login shell


## 1. login shell

會依序讀取下列兩個檔案

### 1. 所有使用者整體環境設定主檔 - `/etc/profile`

會在載入底下 3 個設定檔 :

1. `/etc/profile.d/*.sh`
    - 裏頭的 *.sh 及 sh.local 有設定所有使用者共用的 `bash介面顏色`、`語系`、`ll別名`、`vi別名`、及各種命令與別名..., 可自行寫好後, 放在這裡
2. `/etc/locale.conf`
    - 由 `/etc/profile.d/lang.sh` 載入此檔案, 設定 bash 語系 LANG 與 LC_ALL
3. `/usr/share/bash-completion/completions/*`
    - 強大的 tab-completion !! 
    - 由 `/etc/profile.d/bash_completion.sh` 載入此檔案

### 2. 個別使用者環境設定偏好檔

依序讀取下列其中之一個設定檔 (但只會載入1個), 依序為 : 

(因為各種 shell 的時空背景轉換的因素才有這麼多)

1. `~/.bash_profile`
    - 找到 `~/.bashrc` 並讀取
        - 裏頭會再去讀取 `/etc/bashrc`
            - 依照 UID 設定 umask
            - 依照 UID 設定 PS1
            - 呼叫 `/etc/profile.d/*.sh` (所以有些命令提示字元才會有 `-bash-4.2$` 啦!!)
        - 裏頭的 `. ~/.bashrc` 其實就是 `source ~/.bashrc`
    - set && export PATH (其實 `/etc/profile` 已經設定過了, 這邊再執行累加)
2. `~/.bash_login`
3. `~/.profile`



## 2. non-login shell

(不會讀取 `/etc/profile`)


# trap

此 command 為 Shell 內建命令, 用來在腳本裏頭指定「信號如何處理」

```bash
#!/bin/bash

trap "" INT
# ↑ 若腳本執行中, 會忽略 SIGNAL INT (也就是使用者使用 Ctrl+C 也無法中斷)

trap "echo YO" EXIT
# ↑ 若腳本執行完後, 會執行的動作
```
