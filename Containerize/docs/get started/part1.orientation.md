# [Part1 - Orientation](https://docs.docker.com/v17.09/get-started/)
- 2017/12/15

### 1. [Orientation ](./part1.orientation.md)
##### 2. [Containers](./part2.containers.md)
##### 3. [Services](./part3.services.md)
##### 4. [Swarms](./part4.swarm.md)
##### 5. [Stacks](./part5.stacks.md)
##### 6. [Deploy your app](./part6.deploy.md)

---


==== 安裝步驟 ====

參考此專案底下的 `linux/install/installCentOS7 裏頭的 Docker CE部分`

==== 安裝步驟 ====

安裝完後, 先測試一下, 如果有看到 Hello from Docker!的字樣, 表示沒問題了...
```sh
$ docker run hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.
...(略)...
# 如果正常執行~ 此篇不用再往下看了~~~
```

如果上面出現問題, 應該有87%是權限問題了! 繼續往下看~
```sh
# 1. 找找看有沒有名為 docker的 group
$ cat /etc/group | grep docker
docker:x:983:
# docker這個使用者群組的 Group ID為 983

# 2. 如果上步驟沒有出現的話, 執行此行
$ sudo groupadd docker

# 3. 把目前使用者, 加入 docker的群組~
$ sudo usermod -aG docker ${USER}

# 4. 再次看看~
$ cat /etc/group | grep docker
docker:x:983:tonynb
# 我的電腦就是 tonynb, 已經加入 docker的群組了
```