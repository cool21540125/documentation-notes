

# bash

![PS1-time+path](./../img/PS1-time-path.png)

```bash
### 「[time pwd]$ 」
CYAN="\[\e[01;36m\]"
WHITE="\[\e[01;37m\]"
BLUE="\[\e[01;34m\]"
TEXT_RESET="\[\e[00m\]"
TIME="\t"
CURRENT_PATH="\W"
ROOT_OR_NOT="\$"
export PS1="${CYAN}[${BLUE}${TIME}${WHITE} ${CURRENT_PATH}${CYAN}]${ROOT_OR_NOT}${TEXT_RESET} "


### 「[pwd]$ 」
CYAN="\[\e[01;36m\]"
BLUE="\[\e[01;34m\]"
TEXT_RESET="\[\e[00m\]"
export PS1="${CYAN}[${BLUE}\W${CYAN}]\$${TEXT_RESET} "

```


# zsh

![PS1-time+path](./../img/PS1-zsh-full.png)
- 更多 zsh 的教學可參考這邊: https://wiki.gentoo.org/wiki/Zsh/Guide 或者直接參考 /etc/zshrc 裡面的寫法

```zsh
### ======================== PS1 ========================
export PS1=$'[\033[32;1m%1d\033[m\]$ '


### ======================== 懶人指令 ========================
alias d='docker'
alias dis='docker images'
alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"'
alias dpsa='docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Names}}"'
alias dn='docker network'
alias dv='docker volume'
alias dex='docker exec -it'
alias di='docker inspect'
alias dc='docker-compose'
alias dl='docker logs -f'
alias dip4='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dienv='docker inspect --format="{{json .Config.Env}}"'
alias k='kubectl'
alias ls='ls -G'
alias la='ls -aG'
alias ll='ls -lG'
alias lla='ls -alG'


### ======================== PATH ========================

```

- `\e[0;31m` turn on foreground to red
- `\e[0m` turn off character attributes
- `[01;36m` make bold


# 