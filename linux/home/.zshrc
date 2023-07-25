

# PS1 
#PS1='[\u@\h \W]\$ '
PS1='[%n@%m %1~]$ '


### 常用懶人指令 ------------
alias l='ls --color'
alias ls='ls --color'
alias la='ls -a --color'
alias ll='ls -l --color'
alias lla='ls -al --color'
alias llh='ls -lh --color'
alias llah='ls -alh --color'

### Docker 懶人指令 ------------
alias d='docker'
alias dis='docker image list --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}"'
alias dps='docker ps --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dn='docker network'
alias dv='docker volume'
alias dex='docker exec -it'
alias di='docker inspect'
alias dc='docker compose'
alias dl='docker logs -f'
alias dip4='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dienv='docker inspect --format="{{json .Config.Env}}"'

### k8s 懶人指令 ------------
alias k='kubectl'
