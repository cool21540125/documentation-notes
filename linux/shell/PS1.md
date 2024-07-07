

# bash

![PS1-time+path](./../img/PS1-time-path.png)

```bash
CYAN="\[\e[01;36m\]"
WHITE="\[\e[01;37m\]"
BLUE="\[\e[01;34m\]"
ORANGE="\[\e[01;33m\]"
RED="\[\e[01;31m\]"
TEXT_RESET="\[\e[00m\]"
TIME="\t"
CURRENT_HOST="\u@\h"
CURRENT_PATH="\W"
ROOT_OR_NOT="\$"

export PS1="${CYAN}[${BLUE}\W${CYAN}]\$${TEXT_RESET} "
export PS1="${CYAN}[${RED}${TIME}${WHITE} ${CURRENT_PATH}${CYAN}]${ROOT_OR_NOT}${TEXT_RESET} "
export PS1="${CYAN}[${BLUE}${TIME}${WHITE} ${CURRENT_HOST} ${ORANGE}${CURRENT_PATH}${CYAN}]${ROOT_OR_NOT}${TEXT_RESET} "



### Ubuntu
export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

```


# zsh

![PS1-time+path](./../img/PS1-zsh-full.png)
- 更多 zsh 的教學可參考這邊: https://wiki.gentoo.org/wiki/Zsh/Guide 或者直接參考 /etc/zshrc 裡面的寫法

```zsh
### ======================== PS1 ========================
# 目前目錄
export PS1=$'[\033[32;1m%1d\033[m\]$ '

# 目前目錄 + 時分秒
export PS1=$'[\033[32;1m%1d\033[m %D{%L:%M:%S}\]$ '


### ======================== PATH ========================

```

- `\e[0;31m` turn on foreground to red
- `\e[0m` turn off character attributes
- `[01;36m` make bold


# 
