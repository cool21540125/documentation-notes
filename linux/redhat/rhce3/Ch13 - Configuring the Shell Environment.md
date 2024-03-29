# Ch13 - Configuring the Shell Environment

## login shell

會依序讀取下列兩個檔案

### 1-1. `所有使用者` 整體環境設定主檔 - `/etc/profile`

會在載入底下 3 個設定檔 :

1. `/etc/profile.d/*.sh`
    - 裏頭的 *.sh 及 sh.local 有設定所有使用者共用的 `bash介面顏色`、`語系`、`ll別名`、`vi別名`、及各種命令與別名..., 可自行寫好後, 放在這裡
2. `/etc/locale.conf`
    - 由 `/etc/profile.d/lang.sh` 載入此檔案, 設定 bash 語系 LANG 與 LC_ALL
3. `/usr/share/bash-completion/completions/*`
    - 強大的 tab-completion !! 
    - 由 `/etc/profile.d/bash_completion.sh` 載入此檔案

### 1-2. `個別使用者` 環境設定偏好檔

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


