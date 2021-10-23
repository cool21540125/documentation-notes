# [Part2 - Containers](https://docs.docker.com/v17.09/get-started/part2/)
- 2017/12/15

---
##### 1. [Orientation ](./part1.orientation.md)
### 2. [Containers](./part2.containers.md)
##### 3. [Services](./part3.services.md)
##### 4. [Swarms](./part4.swarm.md)
##### 5. [Stacks](./part5.stacks.md) 
##### 6. [Deploy your app](./part6.deploy.md)

---

#  本章節目的, 有2個<br />
> Part A. 建立 Docker image, 並執行 Container (後端網頁) <br />
  事前準備: 寫 `dockerfile` , `requirements.txt` , `app.py`<br />
> Part B. 將第1部份建立的 image上傳到 docker hub <br />
  事前準備: 到 [Docker hub](https://hub.docker.com/) 註冊帳號密碼

## Part A

`dockerfile` 內容如下

`dockerfile`也可命名為 `DOCKERFILE` or `Dockerfile`

```dockerfile
# 使用Python官方的 image
FROM python:2.7-slim

# 把目前目錄的東西, copy到 image內

# 設定工作目錄為 /app
WORKDIR /app

# 把 ./app內的東西 copy到 container內
ADD . /app

# 執行 container後, 開始執行 pip install
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# 開放 container內的 80 port給外部使用
EXPOSE 80

# 設定 container內的環境變數, NAME=World
ENV NAME World

# 一進入 container後, 就執行 python app.py
CMD ["python", "app.py"]
```


```sh
# 如果被 代理伺服器(Proxy Server) 擋住, 則在 dockerfile內加入 :
ENV http_proxy host:port
# or
ENV https_proxy host:port

# (↑看不懂這邊要講什麼)
```

`requirements.txt` 內容如下:
```
Flask
Redis
```

`app.py` 內容如下:
```py
from flask import Flask
from redis import Redis, RedisError
import os
import socket

# Connect to Redis
redis = Redis(host="redis", db=0, socket_connect_timeout=2, socket_timeout=2)

app = Flask(__name__)

@app.route("/")
def hello():
    try:
        visits = redis.incr("counter")
    except RedisError:
        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<h3>Hello {name}!</h3>" \
           "<b>Hostname:</b> {hostname}<br/>" \
           "<b>Visits:</b> {visits}"
    return html.format(name=os.getenv("NAME", "world"), hostname=socket.gethostname(), visits=visits)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
```

東西準備好後, 開始建立 docker image
```sh
$ ls
app.py  dockerfile  requirements.txt

# 此指令會依照目前目錄底下已有的 dockerfile(不分大小寫)來建立 image, 並命名為 friendlyhello
$ docker build -t friendlyhello .
# -t 用來幫即將要建立的 Docker Image命名

# 查看 docker建立了多少個 image
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
friendlyhello       latest              84bbca9ecd7f        4 seconds ago       148MB
python              2.7-slim            4fd30fc83117        3 days ago          138MB
```

使用 Docker image 建立 + 執行 Docker container
> 語法: `docker run`  **`-p xxxx:80`**(...其他語法...) `<image名稱>` <br />
  利用 <image名稱> 來建立 + 執行 Container

```sh
$ docker run -p 4000:80 friendlyhello
* Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
# -p 4000:80 表示 外界需要使用 4000 port, 才可存取 container內的 80 port
# 上面看到的 *Running ... 的訊息, 是來自 Container發出來的

# 上面的指令也可用底下來代替~
$ docker run -d -p 4000:80 friendlyhello
f6c02f60120b0cd4963d76a931214c7a10676841abadf92f51a1c23f3c47100d
# -d 表示背景執行

# 底下的指令多執行幾次, 看個感覺就好, 等到作過 part3的 load balance後, 再回來比較看看差在哪
$ curl http://localhost:4000
<h3>Hello World!</h3><b>Hostname:</b> f6c02f60120b<br/><b>Visits:</b> <i>cannot connect to Redis, counter disabled</i>
```

---

## Part B

到 [Docker hub](https://hub.docker.com/) 註冊帳號密碼後...
```sh
$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: cool21540125
Password: 
Login success
```

將 docker image作標籤 (重命名)
> 語法: `docker tag <image名稱> <使用者名稱>/<repository名字>:<版本標記>` <br />
  如果此 image打算註冊到遠端儲藏庫, 則必須使用合乎規定的命名方式<br />
  `<使用者名稱>`必輸使用 `login的 username`

```sh
$ docker images
REPOSITORY               TAG           IMAGE ID        CREATED           SIZE
friendlyhello            latest        84bbca9ecd7f    4 seconds ago     148MB
python                   2.7-slim      4fd30fc83117    3 days ago        138MB

$ docker tag friendlyhello cool21540125/firstrepo:1.0
# 把 friendlyhello這個 docker image, 額外建立一個名稱, 並標記為 1.0版

$ docker images
REPOSITORY               TAG           IMAGE ID        CREATED           SIZE
cool21540125/firstrepo   1.0           84bbca9ecd7f    27 minutes ago    148MB
friendlyhello            latest        84bbca9ecd7f    27 minutes ago    148MB
python                   2.7-slim      4fd30fc83117    3 days ago        138MB
# 多出一個東西囉!! 注意兩者的 Image ID都是來自相同的地方~
```

註冊到遠端 Registry
> 語法: `docker push` <帳號>/<repository名稱>:<版本標記>
```sh
$ docker push cool21540125/firstrepo:1.0       # 開始進入漫長的上傳...
The push refers to a repository [docker.io/cool21540125/firstrepo]
3106da9bc359: Pushed
a693368df109: Pushed
b22d82b10852: Pushed
94b0b6f67798: Mounted from library/python
e0c374004259: Mounted from library/python
56ee7573ea0f: Mounted from library/python
cfce7a8ae632: Mounted from library/python
1.0: digest: sha256:dd2a6996573b3b712a7a74023a1a81d2162695b1a63a73fdde5ff6fca198e500 size: 1788
# 結束之後, 到自己的 docker hub看看~
```

日後要下載先前的 docker image
```sh
$ docker pull cool21540125/firstrepo:1.0
# 依照自己遠端 Repository頁面內的指令貼上就可以了~
# 開始下載遠端 Docker image

$ docker run -p 4000:80 cool21540125/firstrepo:1.0
# 此指令, 就如同前面描述的那樣, 但其實他會作2件事情
# 1. 檢查本地有沒有 "cool21540125/firstrepo:1.0" 這東西, 如果沒有則到遠端抓~
# 2. 建立 + 執行 Container
```

最後, 如果不小心標了一大堆tag... 怎麼刪除?
```sh
$ docker images
REPOSITORY               TAG           IMAGE ID          CREATED             SIZE
cool21540125/firstrepo   1.0           84bbca9ecd7f      About an hour ago   148MB
friendlyhello            latest        84bbca9ecd7f      About an hour ago   148MB
python                   2.7-slim      4fd30fc83117      3 days ago          138MB

# docker rmi用來刪除 image, 但其實也可以用來刪除 別名
$ docker rmi cool21540125/firstrepo:1.0
Untagged: cool21540125/firstrepo:1.0
Untagged: cool21540125/firstrepo@sha256:dd2a699...(很長... 略)

$ docker images
REPOSITORY               TAG           IMAGE ID          CREATED             SIZE
friendlyhello            latest        84bbca9ecd7f      About an hour ago   148MB
python                   2.7-slim      4fd30fc83117      3 days ago          138MB
```

---

### 指令備註
```sh
$ docker images
$ docker image ls                                   # 顯示所有 Images

$ docker ps
$ docker container ls                               # 顯示所有 "執行中的" Container

$ docker ps -a
$ docker container ls -a                            # 顯示所有的 Container

$ docker stop <container ID>
$ docker container stop <container ID>              # 停止執行 Container

$ docker rm <Container ID>                          # 刪除"已經停止執行的" Container

$ docker rmi <Image ID>                             # 刪除 Image

$ docker container rm $(docker container ls -a -q)  # 刪除所有 container (慎用!!)
$ docker image rm $(docker image ls -a -q)          # 刪除所有 images (慎用!!)
```