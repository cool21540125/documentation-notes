# Docker Machine

- 此篇 for CentOS7 及 Mac
- 2018/01/02


## For CentOS7

### Prerequest:

- 安裝好 Docker
- 安裝好 VirtualBox

```sh
# 下載並安裝 Docker-Machine
$ curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && chmod +x /tmp/docker-machine && sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

$ docker-machine version
docker-machine version 0.13.0, build 9ba6da9
```



# Docker-Machine

透過 Docker-Machine 來建立 `Docker Host`

Prerequest: 安裝好 VirtualBox

```sh
# 使用預設 Driver(virtualbox), 建立 demo 這台 vm (會出現在 VirtualBox唷)
$ docker-machine create demo
Running pre-create checks...
Creating machine...
(demo) Copying /home/tony/.docker/machine/cache/boot2docker.iso to /home/tony/.docker/machine/machines/demo/boot2docker.iso...
(demo) Creating VirtualBox VM...
(demo) Creating SSH key...
(demo) Starting the VM...
(demo) Check network to re-create if needed...
(demo) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with boot2docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Checking connection to Docker...
Docker is up and running!
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env demo

$ docker-machine ls
NAME   ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER        ERRORS
demo   -        virtualbox   Running   tcp://192.168.99.100:2376           v18.06.0-ce
# 打開 VirtualBox 的圖形化介面, 就能看到多一台了@@
# 如此, 便可透過 Host端(Docker Client), 連入 DockerMachine(Docker Server/Host), 也就是 demo 這台)

# 再者, 得在本地端的 Terminal 操作 DockerMachine(demo), 所以要先來取得它的環境變數
$ docker-machine env demo
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.101:2376"
export DOCKER_CERT_PATH="/home/tony/.docker/machine/machines/demo"
export DOCKER_MACHINE_NAME="demo"
# Run this command to configure your shell:
# eval $(docker-machine env demo)
#------------------------------------------
# 上面這些就是 Docker-Machine 吐出來的環境變數了~

# 執行它~
$ eval $(docker-machine env demo)

$ docker version
Client:
 Version:       18.03.0-ce      # Host的版本
 API version:   1.37
 Go version:    go1.9.4
 Git commit:    0520e24
 Built: Wed Mar 21 23:09:15 2018
 OS/Arch:       linux/amd64
 Experimental:  false
 Orchestrator:  swarm

Server:
 Engine:
  Version:      18.06.0-ce      # Docker-Machine內, 新的唷~~~
  API version:  1.38 (minimum version 1.12)
  Go version:   go1.10.3
  Git commit:   0ffa825
  Built:        Wed Jul 18 19:13:39 2018
  OS/Arch:      linux/amd64
  Experimental: false
# 已經取得 Docker-Machine 的環境變數了
```


## For Mac

### 安裝 virtual box會發生的問題額外備註

```sh
## Install VirtualBox on Mac
# First, install Homebrew
$ ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

# Install Virtualbox
$ brew update
$ brew tap phinze/homebrew-cask
$ brew install brew-cask
$ brew cask install virtualbox
```


##### On Mac, the Virtualbox instlall is not properly integrated -- so it asks for a permission after it fails. Simply re-run the installation for a second time after having granted the OS driver the install permission. No need for uninstalls.

![Allow-Oracle](https://user-images.githubusercontent.com/1438457/31966122-81e98806-b8be-11e7-947e-388d5cf13095.png)
> 簡單說就是第一次安裝會失敗是因為Mac系統安全隱私等問題阻擋，所以`Open System Preferences > Security & Privacy and click the allow "Oracle" button`，再重新安裝一次即可。
```sh
# Reinstall VirtualBox
$ brew cask reinstall --force virtualbox.

# Checkout virtualbox version
$ virtualbox version
```