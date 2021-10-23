
# 關於 Docker Networking

- 2018/06/20

由於早期是從 `v17.06` 開始接觸 Docker (只是當時不知道)

然後又歷經#*&^#@...  也碰了 `v17.09` (努力自學一陣子)

然後又一陣子沒碰, 就來到了 `v18.03`

然後*#&^%$R#@...

最後這邊有  `v17.09` 及 `v18.03` 的筆記





## Docker Network 語法彙整

```sh
# 建立 Network
$ docker network create <Network Name> # 使用預設的 bridge driver
# 或
$ docker network create -d <Network Driver> <Network Name>  # 指定 driver種類

# 移除 Network
$ docker network rm <Network Name>

# 附加 Network to running Container
$ docker network connect <Network Name> <Container Name>

# 拔掉 Network
$ docker network disconnect <Network Name> <Container ID>

# 列出所有 Network
$ docker network ls

# 查看 Network
$ docker network inspect <Network Name>
# 或
$ docker inspect <Network Name>

```

- 2019/07/09
- [Networking for Docker Containers (a Primer) Part I](https://mesosphere.com/blog/networking-docker-containers/)
- 有附圖解說網路架構... 改天讀
