### 可以讓 Terminal 變漂亮(有顏色)
#echo 'export PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]# "' >> ~/.bashrc

cat <<EOF >> ~/.bashrc
export PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[35;40m\]\W\[\e[0m\]]# "
EOF
. ~/.bashrc

### Docker 懶人包快速指令
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
alias dip4='docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dienv='docker inspect --format="{{json .Config.Env}}"'
EOF
. ~/.bashrc
### Docker 懶人包快速指令

