# [About Storage Driver](https://docs.docker.com/storage/storagedriver/)
- 2018/04/15
```sh
$ docker --version 
Docker version 18.03.0-ce, build 0520e24
```

------------------------------
## Image and layers
> `Docker Image` 由一系列的 `Docker Layers`所構成. 

建立一份 Dockerfile
```docker
FROM ubuntu:15.04
COPY . /app
RUN make /app
CMD python /app/app.py
```

下圖, 每個藍色方框, 都是一個 `Container Layer`(Read Only). 最上層為 `Container Writable Layer`(Readable and Writable)
![Container Layers](https://docs.docker.com/storage/storagedriver/images/container-layers.jpg)


## Container and Layers
> Docker Container 及 Docker Image 主要差異為 `最頂層的 Writable Layer`(所有新增/修改後的資料都存在這裡). 而這個 `Writable Layer`也會隨著 Container被砍掉而消失.

下圖, 多個 Container可能來自相同的 Image, 而將資料各自儲存在自己的 `Writable Layer`. 
![Container R/W Layer](https://docs.docker.com/storage/storagedriver/images/sharing-layers.jpg)
> Note: 如果想要多個 `Docker Images`來使用相同的 data, 那這些 data 就得存在於 `Docker Volume`, 然後在使用 **mount** 到 `Docker Container`.


## Container size on disk
> 要開始來看看 `Docker Images` 及 `Docker Containers`到底佔了多少空間~

為了方便檢視, 砍掉所有 Images, Containers
```sh
# 停止所有 Container
$ docker stop $(docker ps -q)

# 刪除所有 container
$ docker rm $(docker ps -aq)

# 刪除所有 images
$ docker rmi $(docker images -q)
```

開始~
```sh
$ docker pull ubuntu:15.04
15.04: Pulling from library/ubuntu
9502adfba7f1: Pull complete 
4332ffb06e4b: Pull complete 
2f937cc07b5f: Pull complete 
a3ed95caeb02: Pull complete 
Digest: sha256:2fb27e433b3ecccea2a14e794875b086711f5d49953ef173d8a03e8707f1510f
Status: Downloaded newer image for ubuntu:15.04

# 開始背景運行~
$ docker run -itd ubuntu:15.04
5f0f98d3daf676f498cd342760f052661edbd992f87b41b852322ad97b8e5f69

$ docker images
REPOSITORY  TAG     IMAGE ID        CREATED       SIZE
ubuntu      15.04   d1b55fd07600    2 years ago   131MB     # <- 這個 Image佔了 131MB

$ docker ps -s      # -s 可以看 Container的 SIZE
CONTAINER ID    IMAGE         COMMAND      CREATED   STATUS   PORTS   NAMES              SIZE
5f0f98d3daf6    ubuntu:15.04  "/bin/bash"  ...       ...              wizardly_hypatia   0B (virtual 131MB) # <- 這啥~?
```
上頭最後的 SIZE, 有分為 `size` 及 `virtual size`

- size: 每個 `Container Writable Layer` 的磁碟使用大小.
- virtual size: `Docker Container 所使用的 (Read-Only) Image Size` + `Container Writable Layer`(也就是 size啦)

底下 `size` 及 `virtual size` 的原文...
- size: the amount of data (on disk) that is used for the writable layer of each container
- virtual size: the amount of data used for the read-only image data used by the container plus the container’s writable layer size. Multiple containers may share some or all read-only image data. Two containers started from the same image share 100% of the read-only data, while two containers with different images which have layers in common share those common layers. Therefore, you can’t just total the virtual sizes. This over-estimates the total disk usage by a potentially non-trivial amount.

- Docker 使用 `AUFS` 文件系統(焚層疊加儲存) 進行文件管理
  - Image 是只存在於 *Readable Layer* 的文件
  - Container 則是 Image 的 running Instance(實例文件 儲存在 *Writable Layer*)


## 範例~

> 為了方便觀察, 先把其他所有 `Docker image` 及 `Docker Container` 都砍掉

以下可直接 Copy-Paste
```sh
mkdir cow-test
cd cow-test
touch hello.sh
echo '#!/bin/sh' >> hello.sh
echo 'echo "Hello world"' >> hello.sh
chmod +x hello.sh

# 建立第 1份 Docker Image
touch Dockerfile.base
echo 'FROM ubuntu:16.10' >> Dockerfile.base
echo 'COPY . /app' >> Dockerfile.base
docker build -t acme/my-base-image:1.0 -f Dockerfile.base .

# 建立第 2份 Docker Image (Base on ubuntu:16.01)
touch Dockerfile
echo 'FROM acme/my-base-image:1.0' >> Dockerfile
echo 'CMD /app/hello.sh' >> Dockerfile
docker build -t acme/my-final-image:1.0 -f Dockerfile .
```

底下的看一看 交叉搜尋比對 Image ID 應該就秒懂了...
```sh
$ docker images
REPOSITORY            TAG      IMAGE ID       CREATED           SIZE
ubuntu                16.10    7d3f705d307c   8 months ago      107MB
acme/my-base-image    1.0      c6cb5b02d45b   30 seconds ago    107MB
acme/my-final-image   1.0      7a7af4f8ed28   9 seconds ago     107MB
# 上面 3個 Image我順序有排過, 後面的 Image Base on 前者

$ docker history 7d3f705d307c   # ubuntu:16.10的 Image ID
IMAGE          CREATED    CREATED BY                                      SIZE       COMMENT
7d3f705d307c   ...        /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>      ...        /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B                  
<missing>      ...        /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$…   2.78kB              
<missing>      ...        /bin/sh -c rm -rf /var/lib/apt/lists/*          0B                  
<missing>      ...        /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   745B                
<missing>      ...        /bin/sh -c #(nop) ADD file:6cd9e0a52cd152000…   107MB 
# 'ubuntu'的這個 Docker Image佔了 107MB
# <missing>那堆, 可以不用裡它!! (因為他們在其他系統中建立, 同時他們也不是重點!)

$ docker history c6cb5b02d45b   # acme/my-base-image:1.0的 Image ID
IMAGE          CREATED    CREATED BY                                      SIZE       COMMENT
c6cb5b02d45b   ...        /bin/sh -c #(nop) COPY dir:8df9421a379322440…   105B                
7d3f705d307c   ...        /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>      ...        /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B                  
<missing>      ...        /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$…   2.78kB              
<missing>      ...        /bin/sh -c rm -rf /var/lib/apt/lists/*          0B                  
<missing>      ...        /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   745B                
<missing>      ...        /bin/sh -c #(nop) ADD file:6cd9e0a52cd152000…   107MB
# my-first-image這個 Docker Image不佔空間, 因為東西都是從 ubuntu:16.01來的

$ docker history 7a7af4f8ed28   # acme/my-final-image:1.0的 Image ID
IMAGE         CREATED     CREATED BY                                      SIZE       COMMENT
7a7af4f8ed28   ...        /bin/sh -c #(nop)  CMD ["/bin/sh" "-c" "/app…   0B                  
c6cb5b02d45b   ...        /bin/sh -c #(nop) COPY dir:8df9421a379322440…   105B                
7d3f705d307c   ...        /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>      ...        /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B                  
<missing>      ...        /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$…   2.78kB              
<missing>      ...        /bin/sh -c rm -rf /var/lib/apt/lists/*          0B                  
<missing>      ...        /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   745B                
<missing>      ...        /bin/sh -c #(nop) ADD file:6cd9e0a52cd152000…   107MB 
# (同前者說明)
```

## CoW(copy-on-write) 測試
> 底下開始, 只能在 `Docker On Linux` 作用!  (官方原意: Docker for Mac && Docker for Win10 去吃屎!)

> 底下要開始驗證 `CoW` 所占的硬碟空間, 根據 `acme/my-final-image:1.0` 運行 5個 Containers. 

```sh
$ docker images
REPOSITORY            TAG      IMAGE ID       CREATED           SIZE
acme/my-final-image   1.0      7a7af4f8ed28   9 seconds ago     107MB
acme/my-base-image    1.0      c6cb5b02d45b   30 seconds ago    107MB
ubuntu                16.10    7d3f705d307c   8 months ago      107MB

# 給我用相同的 'acme/my-final-image:1.0' 這個 Image, 起 5個 Containers!!
$ docker run -dit --name my_container_1 acme/my-final-image:1.0 bash \
  && docker run -dit --name my_container_2 acme/my-final-image:1.0 bash \
  && docker run -dit --name my_container_3 acme/my-final-image:1.0 bash \
  && docker run -dit --name my_container_4 acme/my-final-image:1.0 bash \
  && docker run -dit --name my_container_5 acme/my-final-image:1.0 bash

$ docker ps -s
CONTAINER ID   IMAGE                     COMMAND     CREATED   STATUS   PORTS   NAMES            SIZE
26321bc98a17   acme/my-final-image:1.0   "bash"      ...       ...              my_container_5   0B (virtual 107MB)
6642cb9f483f   acme/my-final-image:1.0   "bash"      ...       ...              my_container_4   0B (virtual 107MB)
42ad9e19a71e   acme/my-final-image:1.0   "bash"      ...       ...              my_container_3   0B (virtual 107MB)
39f734ecae8f   acme/my-final-image:1.0   "bash"      ...       ...              my_container_2   0B (virtual 107MB)
04b2c7e41572   acme/my-final-image:1.0   "bash"      ...       ...              my_container_1   0B (virtual 107MB)

# 底下看到的 Containers, 跟上面的指令看到的是相同的 Containers, 只是是全名(應該吧)
$ sudo ls /var/lib/docker/containers
26321bc98a178f62ae97f6c7ab00a01d1f6b001e6a1566af32cafc6771b3afae
6642cb9f483f9e8b41ed1b3ca52e14fb52f1cb02f01a4715bdf24bf53fa267c0
42ad9e19a71edb93bcaf34b62baf4b43896449ed140a21e37ef9d4e43d424e47
39f734ecae8f3bd8a90cdaf8e57cf727ce4d299e69266889206eb30c6a19e29b
04b2c7e415721f64cee17a393e27ed92b923e178e4e051ee5c27666d19c18421

# 底下這行, 要先進到 su (無法使用 sudo)
$ sudo du -sh /var/lib/docker/containers/*
24K	/var/lib/docker/containers/04b2c7e415721f64cee17a393e27ed92b923e178e4e051ee5c27666d19c18421
24K	/var/lib/docker/containers/26321bc98a178f62ae97f6c7ab00a01d1f6b001e6a1566af32cafc6771b3afae
24K	/var/lib/docker/containers/39f734ecae8f3bd8a90cdaf8e57cf727ce4d299e69266889206eb30c6a19e29b
24K	/var/lib/docker/containers/42ad9e19a71edb93bcaf34b62baf4b43896449ed140a21e37ef9d4e43d424e47
24K	/var/lib/docker/containers/6642cb9f483f9e8b41ed1b3ca52e14fb52f1cb02f01a4715bdf24bf53fa267c0
# 每個 Container都只佔檔案系統 24KB而已
```

# 結論... (感覺有點空虛)

#### copy-on-write 策略
1. 節省 Docker Container佔用的磁碟空間
2. 縮短了 Docker Container啟動時間. 

> 每當啟動一個 Docker Container（or來自相同 Image的多個 Containers）時, Docker只需要創建 `薄薄一層可寫容器層(thin writable container layer)`.

> 如果 Docker在每次啟動一個 Container時都必須製作`底層映像堆棧的整個副本 (an entire copy of the underlying image stack)`, 則 Container啟動時間和使用的磁碟空間將顯著增加. 這與 VM的工作方式類似, 每個 VM具有一個或多個`虛擬磁碟 (virtual disk)`。