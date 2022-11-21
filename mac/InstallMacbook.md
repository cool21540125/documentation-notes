
# Note

- `brew install xxx` 的東西, 似乎都會建立軟連結在 `/usr/local/bin/` 裏頭
- 環境變數檔, 放在 `/etc/paths` 及 `/etc/paths.d/*`
- 幾個還沒有分得很清楚的路徑
  - /usr/local/bin
  - /usr/local/Cellar
  - /Library/Frameworks/


# brew

- [List of all packages installed using Homebrew](https://apple.stackexchange.com/questions/101090/list-of-all-packages-installed-using-homebrew)

```zsh
### 列出 brew 已安裝套件
brew list

### 升級套件
brew upgrade xxx
# ex: 升級 python3.10
# brew upgrade python3.10
# 但不確定能否正常就是了!!

### 
```


# Install Homebrew

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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


# Uninstall golang

- 2022/05/05
- [How to uninstall Go?](https://stackoverflow.com/questions/42186003/how-to-uninstall-go)

```zsh
which go

sudo rm -rf /usr/local/go
sudo rm /etc/paths.d/go
```


# Install aws

- [Installing or updating the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

```bash
### Install or update the AWS CLI
#   Command line - Current user

### Step1. 製作 choices.xml && 編輯安裝的使用者家目錄: /Users/tony

### Step2.
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
# 東西會安裝到 /Users/tony/aws-cli

ln -s /Users/tony/aws-cli/aws ~/bin/aws
ln -s /Users/tony/aws-cli/aws_completer ~/bin/aws_completer

aws --version
# aws-cli/2.7.9 Python/3.9.11 Darwin/21.5.0 exe/x86_64 prompt/off
```


# Install SAM CLI (aws-sam)

- 2022/07/08
- [Install SAM CLI](https://aws.amazon.com/tw/serverless/sam/)

```bash
$# brew tap aws/tap
$# brew install aws-sam-cli

$# sam --version
SAM CLI, version 1.53.0
```


# Install terraform (尚未)

```bash
### install the HashiCorp tap, a repository of all our Homebrew packages.
$# brew tap hashicorp/tap

### install Terraform with hashicorp/tap/terraform
$# brew install hashicorp/tap/terraform
==> Downloading https://releases.hashicorp.com/terraform/1.2.8/terraform_1.2.8_darwin_amd64.zip
Already downloaded: /Users/tony/Library/Caches/Homebrew/downloads/6cf027cb532d2f4e3d638253209a68827d4ee05d5b51785cff70fad958c880a6--terraform_1.2.8_darwin_amd64.zip
==> Installing terraform from hashicorp/tap
Error: Your Command Line Tools are too outdated.
Update them from Software Update in System Preferences or run:
  softwareupdate --all --install --force

If that doesn''t show you any updates, run:
  sudo rm -rf /Library/Developer/CommandLineTools
  sudo xcode-select --install

Alternatively, manually download them from:
  https://developer.apple.com/download/all/.
You should download the Command Line Tools for Xcode 13.4.
# 得知, macbook 又要我去安裝 XCode 這噁心的爛東西了...
# 放棄使用 brew 來安裝....
```


# Install kubectx

- 2022/09/21

```bash
### k8s 的額外 CLI
$# brew install kubectx
# 對他還很不熟, 不過他其中一個功能可以修改 default namespace

$# 
```


# Install ekscli

- 2022/09/24

```bash
$# aws --version
aws-cli/2.7.9 Python/3.9.11 Darwin/21.6.0 exe/x86_64 prompt/off

$# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

$# sudo mv /tmp/eksctl ~/bin/

$# eksctl version
0.112.0
```


# Install Jenkins-lts

```bash
### install
$# brew install jenkins-lts


### 設定檔
$# cd /usr/local/opt/jenkins-lts/
$# vim homebrew.jenkins-lts.service
$# vim homebrew.mxcl.jenkins-lts.plist


### start
$# brew services start jenkins-lts


### init 密碼位置
$# cat ~/.jenkins/secrets/initialAdminPassword
# 初始化完成後, 會自動移除

### log
$# cd /usr/local/var/log
```


# Install nginx

```bash
### install
$# brew install nginx


### config
$# cd /usr/local/etc/nginx
$# vim nginx.conf


### start
$# brew services start nginx


### 修改 Dir owner
# ex: 要反代 Jenkins 等請求, nginx process 會對此 Dir 裡頭做 filesystem 操作, 因而需要 rwx 權限(預設為 700 nobody admin)
$# cd /usr/local/var/run/nginx/
$# chown -R ${USER} *


### log
$# tail -f /usr/local/var/log/nginx/access.log
$# tail -f /usr/local/var/log/nginx/error.log
```



# Install md5sha1sum

```bash
$# brew install md5sha1sum
```


# Install socat

安裝 `acme.sh` 之前的依賴套件

```bash
$# brew install socat
```


# Install openldap

```bash
$# brew install openldap
```

# Install java (install OpenJDK)

- 2022/11/11
- 要安裝 Oracle Java 的話請另尋其他文件...

```zsh
### Install 
$# brew install openjdk@8
$# brew install java11
$# brew install java17
$# brew install java19
# 2022/11 的現在, java8 與 java8+ 安裝方式有一些些不同, 推估 java11 將來也會像 java8 這樣安裝

### env PATH
$# export JAVA_HOME="/usr/local/opt/openjdk@${VERSION}/libexec/openjdk.jdk/Contents/Home"
$# export CPPFLAGS="-I/usr/local/opt/openjdk@${VERSION}/include"
$# export PATH="$JAVA_HOME/bin:$PATH"

### 
$# java -version
$# javac -version
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

```zsh

```


# 