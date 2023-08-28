
# Note

- `brew install xxx` 的東西, 似乎都會建立軟連結在 `/usr/local/bin/` 裏頭
- 環境變數檔, 放在 `/etc/paths` 及 `/etc/paths.d/*`
- 幾個還沒有分得很清楚的路徑
  - /usr/local/bin
  - /usr/local/Cellar
  - /Library/Frameworks/


# brew

- [List of all packages installed using Homebrew](https://apple.stackexchange.com/questions/101090/list-of-all-packages-installed-using-homebrew)
- [Homebrew 的相關專業術語/專業用語(termonology)](https://github.com/Homebrew/brew/blob/master/docs/Formula-Cookbook.md#homebrew-terminology)

```zsh
### 列出 brew 已安裝套件
$# brew list


### 升級套件
$# brew upgrade xxx
# ex: 升級 python3.10
# brew upgrade python3.10
# 但不確定能否正常就是了!!


### 安裝 xxx
$# brew install xxx


### 查看所有的 current taps
$# brew tap
aws/tap
hashicorp/tap
homebrew/cask
homebrew/core
homebrew/services
# https://stackoverflow.com/questions/34408147/what-does-brew-tap-mean


### 增加 && 刪除 brew tap
$# brew tap ${TAP_NAME}
$# brew untap ${TAP_NAME}


### 
$# 
```


# Install Homebrew

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```


# Install xcode command

```zsh
xcode-select --install
```


# Install Postgresql 11

- 2020/01/27
- https://installvirtual.com/install-postgresql-11-on-mac-os-x-via-brew/

```zsh
### Install
$# brew search postgresql
$# brew install postgresql@11
# ...PASS...
==> Caveats
To migrate existing data from a previous major version of PostgreSQL run:
  brew postgresql-upgrade-database

postgresql@11 is keg-only, which means it was not symlinked into /usr/local,
because this is an alternate version of another formula.

If you need to have postgresql@11 first in your PATH run:
  echo 'export PATH="/usr/local/opt/postgresql@11/bin:$PATH"' >> ~/.bash_profile

For compilers to find postgresql@11 you may need to set:
  export LDFLAGS="-L/usr/local/opt/postgresql@11/lib"
  export CPPFLAGS="-I/usr/local/opt/postgresql@11/include"


To have launchd start postgresql@11 now and restart at login:
  brew services start postgresql@11  # Daemon
Or, if you don\'t want/need a background service you can just run:
  pg_ctl -D /usr/local/var/postgresql@11 start  # 前景執行
== Summary
🍺  /usr/local/Cellar/postgresql@11/11.6: 3,191 files, 36MB

```


# psycopg2 on macbook

- 2020/10/15

#### 法1

我已經先做好了 `brew install brew install postgresql@11`

改用 `pip install psycopg2-binary`


#### 法2

- 2020/11/05
- [Can't install psycopg2 with pip in virtualenv on Mac OS X 10.7](https://stackoverflow.com/questions/9678408/cant-install-psycopg2-with-pip-in-virtualenv-on-mac-os-x-10-7)
- [OSX ld: library not found for -lssl](https://stackoverflow.com/questions/49025594/osx-ld-library-not-found-for-lssl?noredirect=1&lq=1)

用底下這樣可成功, 似乎是需要 postgresql 的某個 C Library 的東西

```zsh
brew install postgresql

env LDFLAGS='-L/usr/local/lib -L/usr/local/opt/openssl/lib
-L/usr/local/opt/readline/lib' pip install psycopg2
```



# Install podman

- https://podman.io/getting-started/installation

```zsh
$ brew install podman
# 會花有點久, 裝一堆東西

$ podman machine init
Downloading VM image: fedora-coreos-34.20211004.2.0-qemu.x86_64.qcow2.xz: done  
Extracting compressed file
# 抓這個也會花點時間...

$ podman machine start
INFO[0000] waiting for clients...                       
INFO[0000] listening tcp://0.0.0.0:7777                 
INFO[0000] new connection from  to /var/folders/pd/w7t815h1065flxx1px72xxy40000gn/T/podman/qemu_podman-machine-default.sock 
Waiting for VM ...
Machine "podman-machine-default" started successfully

$ podman info
host:
  arch: amd64
  buildahVersion: 1.22.3
  cgroupControllers: []
  cgroupManager: systemd
  cgroupVersion: v2
  conmon:
    package: conmon-2.0.29-2.fc34.x86_64
    path: /usr/bin/conmon
    version: 'conmon version 2.0.29, commit: '
  cpus: 1
  ociRuntime:
    name: crun
    package: crun-1.0-1.fc34.x86_64
    path: /usr/bin/crun
  os: linux
  remoteSocket:
    exists: true
    path: /run/user/1000/podman/podman.sock
  slirp4netns:
    executable: /usr/bin/slirp4netns
    package: slirp4netns-1.1.12-2.fc34.x86_64
    version: |-
      slirp4netns version 1.1.12
      commit: 7a104a101aa3278a2152351a082a6df71f57c9a3
      libslirp: 4.4.0
      SLIRP_CONFIG_VERSION_MAX: 3
      libseccomp: 2.5.0
  swapFree: 0
  swapTotal: 0
  uptime: 48.41s
plugins:
  log: null
  network: null
  volume: null
registries:
  search:
  - docker.io
store:
  configFile: /var/home/core/.config/containers/storage.conf
  containerStore:
    number: 0
    paused: 0
    running: 0
    stopped: 0
version:
  APIVersion: 3.3.1
# 僅隨意節錄部分資訊
```


# Install golang (using gvm)

- 2023/06/22
- [Github/moovweb/gvm](https://github.com/moovweb/gvm)

```zsh
xcode-select --install
brew update
brew install mercurial


### zsh install gvm
zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source $HOME/.gvm/scripts/gvm


### gvm version
gvm version
# Go Version Manager v1.0.22 installed at /Users/tony/.gvm


### 列出可安裝
gvm listall

### 列出已安裝
gvm list


### Install
gvm install go1.20.5
```


# Install aws

- [Installing or updating the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

```zsh
### Install or update the AWS CLI
#   Command line - Current user

### Step1. 製作 choices.xml && 編輯安裝的使用者家目錄: /Users/tony

### Step2.
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
# 東西會安裝到 /Users/tony/aws-cli

ln -s /Users/$USER/aws-cli/aws ~/bin/aws
ln -s /Users/$USER/aws-cli/aws_completer ~/bin/aws_completer

aws --version
# aws-cli/2.7.9 Python/3.9.11 Darwin/21.5.0 exe/x86_64 prompt/off
```


# Install SAM CLI (aws-sam)

- 2023/04/04
- [Install SAM CLI](https://aws.amazon.com/tw/serverless/sam/)

```zsh
brew tap aws/tap
brew install aws-sam-cli
brew upgrade aws-sam-cli

sam --version
#SAM CLI, version 1.78.0
```


# Install Copilot

- 2023/04/03

```zsh
### AWS Copilot
brew install aws/tap/copilot-cli
# 或
sudo curl -Lo /usr/local/bin/copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-darwin \
   && sudo chmod +x /usr/local/bin/copilot \
   && copilot --help

### Version
copilot --version
#copilot version: v1.27.0
```


# Install terraform

- 2022/12/30
- [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli)

```zsh
### 法1. (放棄使用 brew 吧!!) (需要依賴噁爛到爆的 xcode) -----------------
# install the HashiCorp tap, a repository of all our Homebrew packages.
$# brew tap hashicorp/tap

# install Terraform with hashicorp/tap/terraform
$# brew install hashicorp/tap/terraform
# 此方法安裝後, 會自動更新


### 法2. 尊重生命, 選離 xcode, 所以我選擇直接抓 binary -----------------
$# terraform version
Terraform v1.3.6
on darwin_amd64

```


# Install helm

- 2023/05/04
- [直接來抓 binary](https://github.com/helm/helm/releases)


# Install kubectx

- 2022/09/21

```zsh
### k8s 的額外 CLI
$# brew install kubectx
# 對他還很不熟, 不過他其中一個功能可以修改 default namespace

$# 
```


# Install ekscli

- 2022/09/24

```zsh
$# aws --version
aws-cli/2.7.9 Python/3.9.11 Darwin/21.6.0 exe/x86_64 prompt/off

$# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

$# sudo mv /tmp/eksctl ~/bin/

$# eksctl version
0.112.0
```


# Install Jenkins-lts

```zsh
### install
brew install jenkins-lts


### War & Cli
cd /usr/local/opt/jenkins-lts/


### 設定檔
cd /usr/local/opt/jenkins-lts/
vim /usr/local/opt/jenkins-lts/homebrew.jenkins-lts.service
vim /usr/local/opt/jenkins-lts/homebrew.mxcl.jenkins-lts.plist

# 如果要自訂 JENKINS_HOME, 可修改 homebrew.jenkins-lts.service
# <string>-DJENKINS_HOME=/Users/cicd/.jenkins-lts/</string>


### start
brew services start jenkins-lts


### init 密碼位置
cat ~/.jenkins/secrets/initialAdminPassword
# 初始化完成後, 會自動移除

### log
cd /usr/local/var/log


### 用途不明(僅紀錄留存)
ls -l --color /Library/LaunchDaemons
ls -l --color ~/Library/LaunchAgents

```


# Install nginx

```zsh
### install
brew install nginx


### config
cd /usr/local/etc/nginx
vim nginx.conf


### start
brew services start nginx


### 修改 Dir owner
# ex: 要反代 Jenkins 等請求, nginx process 會對此 Dir 裡頭做 filesystem 操作, 因而需要 rwx 權限(預設為 700 nobody admin)
cd /usr/local/var/run/nginx/
chown -R ${USER} *


### log
tail -f /usr/local/var/log/nginx/access.log
tail -f /usr/local/var/log/nginx/error.log
```



# Install md5sha1sum

```zsh
brew install md5sha1sum
```


# Install socat

安裝 `acme.sh` 之前的依賴套件

```zsh
$# brew install socat
```


# Install openldap

```zsh
$# brew install openldap
```


# Install java (install OpenJDK)

- 2022/11/11
- 要安裝 Oracle Java 的話請另尋其他文件...

```zsh
VERSION=8
VERSION=11
VERSION=17


### Install 
brew install openjdk@$VERSION  # (似乎是 macOS 12  以前的安裝方式)
brew install java$VERSION      # (似乎是 macOS 13+ 以後的安裝方式)


### env PATH
VERSION=
export CPPFLAGS="-I/usr/local/opt/openjdk@${VERSION}/include"
export JAVA_HOME="/usr/local/opt/openjdk@${VERSION}"
export PATH="${JAVA_HOME}/bin:$PATH"


### 
java -version
javac -version
```


# Install gcloud

- 2022/11/20
- 底下列出 2 種安裝方式


## 1. by docker

```zsh
### download
$# docker pull gcr.io/google.com/cloudsdktool/google-cloud-cli:latest


### verify version
$# docker run --rm gcr.io/google.com/cloudsdktool/google-cloud-cli:latest gcloud version | head -n 1
Google Cloud SDK 410.0.0
# (裡頭有 20 多個東西的版本...)


### 建立紀錄 GCP 帳戶認證資訊的 Volume Container
$# VOLUME_CONTAINER=tonychoucc2022-gcp-config
$# docker run -ti \
  --name ${VOLUME_CONTAINER} \
  gcr.io/google.com/cloudsdktool/google-cloud-cli \
  gcloud auth login
Go to the following link in your browser:

    Browser 訪問這個 URL

Enter authorization code: (貼上 verification code)
# 上面這動作會建立一個名為 ${VOLUME_CONTAINER} 的 Volume Container (裡頭存放認證資訊)

### Access to gcloud sh
$# VOLUME_CONTAINER=tonychoucc2022-gcp-config
$# docker run -it --rm \
  --volumes-from ${VOLUME_CONTAINER} \
  gcr.io/google.com/cloudsdktool/google-cloud-cli \
  sh

$# PROJECT_ID=demo1119
$# gcloud config set project ${PROJECT_ID}
Updated property [core/project].
# 然後就可以開始使用 gcloud 了
```


## 2. by handy

- [Install the gcloud CLI](https://cloud.google.com/sdk/docs/install)

```zsh

```


# Install pstree

```sh
brew install pstree
```


# Install python3

```zsh
brew install python@3.9
which python3.9
#/usr/local/bin/python3.9

ls -l /usr/local/bin/python3.9
#lrwxr-xr-x  1 USER  GROUP  41 11 17 17:28 /usr/local/bin/python3.9 -> ../Cellar/python@3.9/3.9.15/bin/python3.9
```


# Install golang

```zsh
brew install go@1.19
go version
#go version go1.19.4 darwin/amd64

which go
#/usr/local/bin/go

ll /usr/local/bin/go*
#lrwxr-xr-x  1 USER  GROUP  26 12  7 16:24 /usr/local/bin/go -> ../Cellar/go/1.19.4/bin/go
#lrwxr-xr-x  1 USER  GROUP  39 11 10 14:34 /usr/local/bin/gobject-query -> ../Cellar/glib/2.74.0/bin/gobject-query
#lrwxr-xr-x  1 USER  GROUP  29 12  7 16:24 /usr/local/bin/gofmt -> ../Cellar/go/1.19.4/bin/gofmt
```


# Install RabbitMQ

```zsh
$# brew install rabbitmq

### 背景啟動
$# brew services start rabbitmq

### 前景啟動
$# CONF_ENV_FILE="/usr/local/etc/rabbitmq/rabbitmq-env.conf" /usr/local/opt/rabbitmq/sbin/rabbitmq-server


### 關閉 RabbitMQ Server
$# brew services stop rabbitmq
$# rabbitmqctl shutdown


### rabbitmq CLI 安裝路徑在
$# ls -l /usr/local/Cellar/rabbitmq/${Version}/     # Intel Macs
$# ls -l /opt/homebrew/Cellar/rabbitmq/${Version}/  # Apple Silicon Mac
$# ls -l /usr/local/opt/rabbitmq/sbin               # 不過其實東西都放在這邊就是了


### Config Path (Intel)
$# cd /usr/local/etc/rabbitmq
$# vim /usr/local/etc/rabbitmq/


### Log Path
$# cd /usr/local/var/log/rabbitmq


# localhost:15672
# 預設帳密 guest/guest
```


# Install protoc

- 2023/04/13
- [到這邊找要安裝的版本](https://github.com/protocolbuffers/protobuf/releases)

```zsh
### 法1. 使用 brew
brew install protobuf


### 法2. 安裝 binary
PB_VERSION="21.12"
PB_REL="https://github.com/protocolbuffers/protobuf/releases"


curl -LO ${PB_REL}/download/v${PB_VERSION}/protoc-${PB_VERSION}-osx-x86_64.zip
unzip protoc-${PB_VERSION}-osx-x86_64.zip -d ${HOME}/bin
mv ${HOME}/bin/bin/protoc ${HOME}/bin && rmdir ${HOME}/bin/bin && mv ${HOME}/bin/include ${HOME}/

### 2023Q1
protoc --version
#libprotoc 3.21.12
```


# Install MySQL

- 2023/04/11

```zsh
brew install mysql@8.0

```


# Install nodejs

- 2023/04/11

```zsh
brew install node@14
brew install node@16
# ---------- Output ----------
#node@16 is keg-only, which means it was not symlinked into /usr/local,
#because this is an alternate version of another formula.
#
#If you need to have node@16 first in your PATH, run:
#  echo 'export PATH="/usr/local/opt/node@16/bin:$PATH"' >> ~/.zshrc
#
#For compilers to find node@16 you may need to set:
#  export LDFLAGS="-L/usr/local/opt/node@16/lib"
#  export CPPFLAGS="-I/usr/local/opt/node@16/include"
#==> Summary
#🍺  /usr/local/Cellar/node@16/16.20.0: 1,890 files, 49.4MB
#==> Running `brew cleanup node@16`...
#Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
#Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
# ---------- Output ----------

brew install node@18
```


# Install dotnet core

- 2023/04/17
- https://dotnet.microsoft.com/en-us/download/dotnet
- 到上面 URL 抓吧


# Install nvm

- 2023/04/28
- 團隊建議使用 nvm 管理 node 版本

```zsh
### install
brew install nvm
nvm version
# v13.14.0  # 2023/04 版本

### env
mkdir ~/.nvm

### 配置 ~/.profile 或 ~/.zshrc 或 ~/.bashrc
# export NVM_DIR="$HOME/.nvm"
# [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
### 記得把原本的 nodejs 的 env 註解/移除


### install node version
nvm install 13
nvm install 14
nvm install 16
nvm install 18


### Switch Version
nvm use 16
```


# Install jsonnet

- 2023/05/17

```zsh
brew install jsonnet

jsonnet --version
#Jsonnet commandline interpreter v0.20.0
```


# Install rar

直接到 App Store 抓 Unarchiver

```zsh
### 別用這個~~
#brew install rar 
```


# Install swagger-codegen

```zsh
brew install swagger-codegen

swagger-codegen version
# 3.0.46
```


# Install ruby

- 2023/08 第一次接觸 ruby 這東西=..=
- mac 一開始已經內建 ruby 2.6

```zsh
brew install ruby@3.1

export GEM_HOME=$HOME/.gem
export PATH="/usr/local/opt/ruby@3.1/bin:$GEM_HOME/bin:$PATH"

ruby -v
#ruby 3.1.4p223

gem -v
#3.4.10

### 會安裝到 $GEM_HOME
gem install ${PKGS}
```


# Install fastlane

- build & release mobile apps

# 法1. by homebrew

```zsh

```


# 法2. by gem

```zsh
### (option) 切換成 local gem
export GEM_HOME=$HOME/.gem
export PATH="/usr/local/opt/ruby@3.1/bin:$GEM_HOME/bin:$PATH"
gem install fastlane


### Usage
$HOME/.gem/bin/fastlane -v
```
