

# Install Basic Tooks

```sh
apk update
apk add curl
apk add vim
apk add wget
apk add git

### telnet: not found
apk add busybox-extras


### dig: command not found
apk add bind-tools
```


# Install Docker

```sh
### Install
$# sudo apk add docker

### 讓它開機後直接運行
$# sudo rc-update add docker boot
 * service docker added to runlevel boot

$# sudo addgroup ${USER} docker
$# sudo reboot
```


# Install CRI-O & CRI-Tools

```sh
$# apk update

### ↓ 測試版本, URL 部分自行選擇版本
$# sudo apk add cri-o cri-tools --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

### 啟動
$# sudo rc-update add crio default
 * service crio added to runlevel default

$# sudo reboot

### crictl 版本
$# crictl -v
crictl version 3.15.0_alpha20210804-2028-g3664443d34

### CRI-O 版本
$# crio -version | grep version
INFO[0000] RDT is not enabled: failed to detect resctrl mount point: resctrl not found in /proc/mounts
crio version 1.22.0
```


# Install NFS

```sh
### Client & Server 端都要安裝
$# sudo apk update; sudo apk add nfs-utils

### 設定 NFS Server
$# sudo rc-update add nfs

### enable & start
$# sudo rc-service rpcbind start
$# sudo rc-service nfs start

### Example Server
$# sudo mkdir /opt/nfs; sudo chown -R nobody:nogroup /opt/nfs
$# echo "/opt/nfs  192.168.152.0/24(rw,sync,no_subtree_check,no_root_squash)" | sudo tee /etc/exports
$# sudo exportfs -var
exporting 192.168.152.0/24:/opt/nfs

### Example Client
$# sudo mount -t nfs 192.168.152.4:/opt/nfs /mnt
```


# Install sshd

- 2022/09/06

```sh
$# apk add openssh
$# rc-update add sshd

$# rc-update delete sshd
```

# Install openrc

- 2022/09/06
- 解決 `sh: rc-update: not found` 的情況

```sh
$# apk add openrc
```


# Install dropbear

- 2022/09/06
- lightweight sshd service
- https://wiki.alpinelinux.org/wiki/Setting_up_a_SSH_server

```sh
$# apk add dropbear
$# rc-service dropbear start  # start
$# rc-update add dropbear     # enable
```
