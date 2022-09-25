
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
  distribution:
    distribution: fedora
    version: "34"
  eventLogger: journald
  hostname: localhost
  idMappings:
    gidmap:
    - container_id: 0
      host_id: 1000
      size: 1
    - container_id: 1
      host_id: 100000
      size: 65536
    uidmap:
    - container_id: 0
      host_id: 1000
      size: 1
    - container_id: 1
      host_id: 100000
      size: 65536
  kernel: 5.14.9-200.fc34.x86_64
  linkmode: dynamic
  logDriver: ""
  memFree: 1264209920
  memTotal: 2061860864
  ociRuntime:
    name: crun
    package: crun-1.0-1.fc34.x86_64
    path: /usr/bin/crun
    version: |-
      crun version 1.0
      commit: 139dc6971e2f1d931af520188763e984d6cdfbf8
      spec: 1.0.0
      +SYSTEMD +SELINUX +APPARMOR +CAP +SECCOMP +EBPF +CRIU +YAJL
  os: linux
  remoteSocket:
    exists: true
    path: /run/user/1000/podman/podman.sock
  security:
    apparmorEnabled: false
    capabilities: CAP_CHOWN,CAP_DAC_OVERRIDE,CAP_FOWNER,CAP_FSETID,CAP_KILL,CAP_NET_BIND_SERVICE,CAP_SETFCAP,CAP_SETGID,CAP_SETPCAP,CAP_SETUID,CAP_SYS_CHROOT
    rootless: true
    seccompEnabled: true
    seccompProfilePath: /usr/share/containers/seccomp.json
    selinuxEnabled: true
  serviceIsRemote: true
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
  graphDriverName: overlay
  graphOptions: {}
  graphRoot: /var/home/core/.local/share/containers/storage
  graphStatus:
    Backing Filesystem: xfs
    Native Overlay Diff: "true"
    Supports d_type: "true"
    Using metacopy: "false"
  imageStore:
    number: 0
  runRoot: /run/user/1000/containers
  volumePath: /var/home/core/.local/share/containers/storage/volumes
version:
  APIVersion: 3.3.1
  Built: 1630356396
  BuiltTime: Mon Aug 30 20:46:36 2021
  GitCommit: ""
  GoVersion: go1.16.6
  OsArch: linux/amd64
  Version: 3.3.1
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