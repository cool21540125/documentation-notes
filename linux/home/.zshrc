
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


### 移除暫時的 python 檔案
alias pyclean='find . \( -type f -name "*.py[co]" -o -type d -name "__pycache__" \) -delete && echo "Removed pycs and __pycache__"'



### golang PATH
export PATH="$(go env GOPATH)/bin:${PATH}"


### nvm PATH
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


### Java PATH
# !!! export JAVA_HOME="$(dirname $(dirname $(realpath $(which javac))))" !!!
#export JAVA_HOME="/usr/local/opt/openjdk@11"
export JAVA_HOME="/usr/local/opt/openjdk@17"
export PATH="$JAVA_HOME/bin:$PATH"
# for C++
export CPPFLAGS="-I${JAVA_HOME}/include"


### Android PATH
export ANDROID_SDK_ROOT="$HOME/bin/cmdline-tools"
export ANDROID_SDK_HOME="$HOME/.android"


### maven PATH
export MAVEN_HOME="$HOME/pkgs/apache-maven-3.9.3"
export PATH="$MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH"


### ruby PATH
export GEM_HOME=$HOME/.gem
export PATH="/usr/local/opt/ruby@3.1/bin:$PATH"
export PATH="$GEM_HOME/bin:$PATH"


### bin PATH
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
