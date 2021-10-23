# [Manage application Data](https://docs.docker.com/storage/)
- 2018/06/26

# 重要概念釐清 && 摘要

> 把 `映像檔(ISO)` 掛載到 `H槽`、 `隨身碟` 出現(掛載)在 `E槽` 等, `掛載` 是一個動作, 英文為 `mount`. 而 本文底下提到的 **Docker管理資料保存的方式** , 有3種方法 : `volumes`, `bind mounts`, `tmpfs mount`, 別把 "動作的mount" 及 "管理方式的mount" 搞混了!!

`Storage drivers` 允許使用者在 `Container writable layer` 建立資料, 但 `讀寫效率` 很低, 且這些資料隨 Container 消失, 所以有了一些 管理 保存資料的方式...


## 資料保存方式 : 
type of mount | volumes | bind mounts | tmpfs mount
------------- | ------- | ----------- | -----------
Linux         | v       | v           | v
Windows       | v       | v           | -
Mac           | v       | v           | -
儲存位置      | /var/lib/docker/volumes/ | anywhere        | only in Memory
管理          | Docker                   | Host FileSystem | -
修改權限      | only Docker process      | any user        | -

由下圖的 `資料在Docker host的位置` , 可以看出 `資料的保存方式` <br>
![Docker Container - types of mount](https://docs.docker.com/storage/images/types-of-mounts.png)


# 1. Volumes
- 可在 container or service 階段建立 Volume
- 可在多個 Container內, **同時使用相同的 Volume**
- Volumes可以有 `named(有名稱的 Volume)` 或 `anonymous(匿名 Volume)` 
- 易於管理, 並且可以跨 Linux 與 Windows
- 可由 Docker CLI 或 Docker API來管理 Volumes
- 易於在不同 Container中共享, 也易於儲存到 remote 或 cloud中
- 相較於把資料保存在 Docker's writable layer, 使用 Volumes不會改變 Container的大小


```sh
# 建立 Volume
$ docker volume create <volume name>

# 移除 Volume
$ docker volume rm <volume name>

# 移除所有未使用的 Volumes
$ docker volume prune
```

```
不懂此句 
Volumes use rprivate bind propagation, and bind propagation is not configurable for volumes.
Volumes 使用 rprivate綁定傳播，並且綁定傳播對 volumes不可配置。 ... 沙小
```


# 2. Bind mounts
- Docker很早期就已經存在的儲存機制, 但功能相較 Volumes非常有限
- 使用 FULL PATH 來綁定到 Container中
- **無法**使用 CLI來管理 bind mounts
- 安全性來講, docker內, 可以修改 host端的檔案系統, 包含**非Docker process**也能修改
- `共享組態文件`, 使用 bind mounts是個不錯的選擇

# 3. tmpfs volume
- 用來儲存 暫時 or 敏感 資訊
- 不會存到檔案系統中
- Docker Swarm Service使用 tmpfs 來將敏感資訊映射到 Container中



# --volume / --mount (此文, 一律使用 「-v」)
[Choose the -v or -mount flag](https://docs.docker.com/v17.09/engine/admin/volumes/volumes/#choose-the--v-or-mount-flag)

flag         | Description
------------ | ----------------------------
-v, --volume | 把後面的 options 喇在一起
--mount      | 有把後面的 options 作區隔

- -v, 由3個部分所組成(有先後順序, 但用意不明顯), 用「:」分隔
    -
    - 第 1個欄位, 對於 *named volume*, 是它的名稱; 對於 *anonymous volume*, 此欄位省略 ((同 `source`))
    - 第 2個欄位, Container 作 mount對應的位置 ((同 `target`))
    - 第 3個欄位, (optional), CSV格式

- --mount, \<key>=\<value>表示, 
    -
    - `type` , 為後面 3者其中一種 [bind, volume, tmpfs]
    - `source` 或 `src` , 對於 *named volume*為 Volume Name ; 對於 *anonymous volume*, 此欄位省略
    - `destination` 或 `dst` 或 `target`, 被 mount到 Container內的 檔案 or 資料夾
    - `readonly`, 此欄位為 無值特性(僅需要加上 readonly)
    - `volume-opt`, key-value pair(可使用多次)

<hr>

manage data   | 17.06版以前 | 17.06版以後
------------- | ---------- | -----------
volume        | -v         | --mount
mount         | -v         | --mount
tmpfs         | --tmpfs    | --mount
volume driver | --mount    | ?

<hr>

Container  | 17.06版以前 | 17.06版以後
---------- | ----------- | ---
standalone | -v          | --mount
swarm      | --mount     | --mount

```sh
# 建立 Volume
$ docker volume create my-vol

# 列出 Volume
$ docker volume ls
local               my-vol

# 查看 特定Volume
$ docker volume inspect my-vol
[
    {
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-vol/_data",
        "Name": "my-vol",
        "Options": {},
        "Scope": "local"
    }
]

# 建立 Container, 並指定 volume位置 (下面 2者相同)
$ docker run -itd --name devtest --mount source=myvol2,target=/app nginx:latest
$ docker run -itd --name devtest -v myvol2:/app nginx:latest

# ((同上, 但為 readonly))
$ docker run -itd --name devtest --mount source=myvol2,target=/app,readonly nginx:latest    # 使用 readonly
$ docker run -itd --name devtest -v myvol2:/app:ro nginx:latest # 使用 ro

$ docker inspect devtest
"Mounts": [
    {
        "Type": "volume",       # mount為 Volume
        "Name": "myvol2",
        "Source": "/var/lib/docker/volumes/myvol2/_data",
        "Destination": "/app",
        "Driver": "local",
        "Mode": "",
        "RW": true,             # mount為可讀寫
        # "RW": false,          # mount為唯獨
        "Propagation": ""
    }
    #... 超大一包....(略)
],
```

### Start a service with volumes
```sh
# 起始 swarm
$ docker swarm init

# 起始服務
$ docker service create -d \
    --replicas=4 \                      # 4個副本
    --name devtest-service \            # Container name
    --mount source=myvol2,target=/app \ # 使用本地 myvol2的 Volume, mount的本地位址
    nginx:latest
```

- 2018/3/12 讀到
[Initial set-up](https://docs.docker.com/v17.09/engine/admin/volumes/volumes/#initial-set-up)

