Dockerfile 那些該死的小細節


Dockerfile 內部的像是 `RUN`, `CMD`, `ENV`, `FROM`, ..., 都稱之為 instruction



#### [RUN](https://docs.docker.com/engine/reference/builder/#run)

RUN 用在 Image 的 Build time (用來 Commit Intermediate Layer), 於 Container runtime 並不會執行

RUN 有兩種格式: 

- *exec form*: `RUN ["executable", "param1", "param2"]`
    - 並沒有 shell 的環境, 所以不能直接讀取環境變數(只能手動實作)
        - 存取環境變數, 是由 shell 所處理
        - ex: `RUN ["/bin/sh", "-c", "echo $HOME"]`
    - 此會被轉譯成 JSON array, 因此必須使用 "", 而非 ''
        - 若轉譯失敗, 會被視為 *shell form*
        - 尤其是在 win, 關於路徑, 要留意路徑轉譯的問題
- *shell form*: `RUN <command>`
    - 此命令會在一個 shell 中執行
        - 預設的 shell 為 `/bin/sh -c`(Linux) 或 `cmd /S /C`(Win)
        - 存取環境變數, 是由 docker 所處理

------

關於 `RUN xxx --no-cache`

依照 Docker Image, 每一個指令都會創建一個 Intermediate Layer(或稱之為 cache)

每個 Layers 之間都是獨立的, 但是 RUN 例外

在此若要讓此 RUN 獨立出去(不要他影響後續 Layer), 則加上 `--no-cache`

此外, 可透過 `ADD` 及 `COPY`, 來讓 `RUN` 產生出來的 cache 無效


#### [CMD](https://docs.docker.com/engine/reference/builder/#cmd)

CMD 用於 Container runtime 的預設動作, 於 Image Build time 並不會執行

- 一個 Dockerfile 裡面只能有一個有效的 `CMD`
    - 若有多個, 最後一個才有效
- **`CMD` 的主要目的是, 為 執行容器, 提供預設動作**
    - `CMD` 的動作, 可以使用一個 executable
    - 也可省略, 並使用 `ENTRYPOINT` 來代替

有 2 種玩法:

- *exec form*: `CMD ["xxx", "xxx"]`
    - 建議用此格式, 可與 `ENTRYPOINT`(也須為 *exec form*) 搭配使用
    - 不會以 `/bin/sh -c` ˋ執行. 因此無法直接讀取 環境變數. 只能自行實作:
        - ex: `CMD ["/bin/sh", "-c", "echo $HOME"]`
    - 又可分為 2 種用法:
        - `CMD ["executable","param1","param2"]`
        - `CMD ["param1","param2"]`
            - 把 CMD 提供的 params, 作為 `ENTRYPOINT` 的預設參數
            - 前提條件是, ENTRYPOINT 也是使用 *exec form*
- *shell form*: `CMD command param1 param2`
    - 預設以 `/bin/sh -c` 執行. docker 直接處理 shell, 因此可 直接取得環境變數 當作參數傳入
    - 此形式將無法搭配 `ENTRYPOINT`

#### [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)

- [Dockerfile中的ENTRYPOINT](https://medium.com/@xyz030206/dockerfile-%E4%B8%AD%E7%9A%84-entrypoint-9653c3b2d2f8)
- [Running Custom Scripts In Docker With Arguments – ENTRYPOINT Vs CMD](https://devopscube.com/run-scripts-docker-arguments/)

用來定義 Container 運行起來的時候, 用來 run 的 executable

- 可使用 `docker run --entrypoint` 來覆寫 `ENTRYPOINT`
- 若有多個 `ENTRYPOINT`, 僅最後一個有效

有兩種玩法:
- *exec form*: `ENTRYPOINT ["executable", "param1", "param2"]`
    - 建議用此格式, 可與 `CMD`(也須為 *exec form*) 搭配使用
    - 不會以 `/bin/sh -c` ˋ執行. 因此無法直接讀取 環境變數. 只能自行實作:
        - ex: `ENTRYPOINT ["/bin/sh", "-c", "echo $HOME"]`
    - `docker run <image> -d`, 來將後續做為參數, 此將採用 *exec form*, 用來覆寫 `CMD`
- *shell form*: `ENTRYPOINT command param1 param2`  ((底下讀的不是很懂, 因此可能有錯))
    - 預設以 `/bin/sh -c` 執行. docker 直接處理 shell, 因此可 直接取得環境變數 當作參數傳入
    - 此形式將無法搭配 `CMD`, 且也無法藉由 `docker run` 的方式來傳遞參數.
    - 缺點: `ENTRYPOINT` 將會作為 `/bin/sh -c` 的子命令來啟動, 且不會傳遞 Signals.
        - 也就是說, 這個 executable 將不會是 Container 裡面的 **PID 1**, 且無法收到 Unix Signals.
        - 因此, 無法藉由 `docker stop <container>` 來接收到 SIGTERM 的訊號

```dockerfile
FROM centos:7
ENTRYPOINT ["curl"]
CMD ["-I", "https://google.com"]
```

來試試看吧

```sh
docker build -t demo .

docker run --rm demo
# 預設向 google.com 發送請球, 擷取 header

docker run --rm demo -v https://tw.yahoo.com/
# 改變預設, 向 tw.yahoo.com 發送請求, 取得詳細資料
```


#### [VOLUME](https://docs.docker.com/engine/reference/builder/#volume)

用來提供 Container 運行起來以後, Container 內部的掛載點

- 底下的範例, 藉由 `docker run` 來建立 Container 內部 mountpoint
    - 為了保持 Image 的可遷移性, 此 VOLUME 創建的 mountpoint, 僅限於 Container 運行以後才會產生.
    - 因此, 無法在 dockerfile 內, 直接定義像是 對應到 Docker Host 的哪個目錄路徑

```dockerfile
FROM ubuntu
RUN mkdir /myvol
RUN echo "hello world" > /myvol/greeting
VOLUME /myvol
```


#### [ADD](https://docs.docker.com/engine/reference/builder/#add)

有兩種格式:
- `ADD [--chown=<user>:<group>] <src>... <dest>`
- `ADD [--chown=<user>:<group>] ["<src>", ..., "<dest>"]`
    - path 如果包含 " ", 則需要使用這種方式

- src 可使用 pattern, pattern 須符合 Golang rule
    - 因此, 像是遇到 "[" 這類的名稱, 需要 escape
- dest 的相對路徑是相對於 `WORKDIR`
- 關於 `--chown` 只適用於 Linux Container
- 更多關於 `--chown`, 遇到再說
- 更多關於 src file permission, 遇到再說
- 若使用 STDIN 來建 Image:
    - `docker build - < dockerfile` , 則不存在 context!
        - 這種情況下, `ADD` 只能使用 URL, 無法使用本地檔案
    - `docker build - < dockerfile.tar.gz`, 遇到再說
- 可使用 URL 作為 src參考下面用法:

```dockerfile
FROM scratch
ADD https://github.com/CentOS/sig-cloud-instance-images/raw/b2d195220e1c5b181427c3172829c23ab9cd27eb/docker/centos-7-x86_64-docker.tar.xz /
CMD ["/bin/bash"]
```


#### [COPY](https://docs.docker.com/engine/reference/builder/#copy)

- 基本上許多地方與 `ADD` 差不多, 但無法使用 URL 作為 src
- src 只能是相對於 context 底下的路徑
- src 如果是個 dir, 則會連同底下的東西全部 copy 到 Container (包含 filesystem metadata)
    - dir 不會被 copy, 只有內容會
- 若 src 為 file, dest 結尾多了個 /, 則會被視為放到 `dest/file`
- 若 src 為 file, dest 沒有 / 結尾, 則會被視為寫入到 `dest` (file)
- 若 src 指定了多個檔案, 則 dest 必須為 / 結尾
- 若 dest 路徑不存在, 則整個結構會被建立
- 關於 COPY, 也有 cache 的問題, 遇到再說


#### [FROM](https://docs.docker.com/engine/reference/builder/#from)

- ARG 這個階段, 是唯一能夠放在 FROM 以前
- 一個 Dockerfile 裡面可以有多個 FROM 階段
    - 此可用來建構多個 Images
    - 此也可用來作為 Image 之間的依賴
- 可為 FROM 配上 `AS name`, 此 name 可用來作為後續 `FROM <name>` 以及 `COPY --from=<name>` 使用

------

`ARG` 與 `FROM` 之間的互動.... 有點無聊啊...

```dockerfile
# ARG 定義的變數, 可以給 FROM 階段使用
ARG  CODE_VERSION=latest
FROM base:${CODE_VERSION}
CMD  /code/run-app

FROM extras:${CODE_VERSION}
CMD  /code/run-extras
```

```dockerfile
# 但像是在 FROM 外部(上面) 的 ARG 聲明, 如果要在 FROM 階段使用的話, 需要在此內部在聲明一次 ARG
ARG VERSION=latest
FROM busybox:$VERSION
ARG VERSION
# ^ 像這樣, 不要給值
RUN echo $VERSION > image_version
# ^ 就可以使用了
```

#### [ENV](https://docs.docker.com/engine/reference/builder/#env)

- 定義 `ENV` 以後, 此變數存活於 **Image Building Time** &&  **Container Runtime**
- 相對的, 定義 `ARG` 以後, 此變數只存活於 **Image Building Time**

ENV 的寫法:
- `ENV NAME=tony`
    - 可使用 單行 多變數 指定
- `ENV NAME tony`
    - 不建議再使用!
    - 只是為了歷史性地向後兼容
    - 可能造成混淆, ex: `ENV result world=` (這可能會嚇到人家)

ENV 的壞處就是, 一但設定了以後, 有一點點可能會影響到 dockerfile 運行 build 的階段, 剛好你這訂的變數, 影響了 building time 的某個指令

也可使用像是:

```dockerfile
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ...
# 此處的 DEBIAN_FRONTEND 則只存活於 building time
# 但與其這樣, 覺得用 ARG 還比較不會讓人混淆
```


#### [STOPSIGNAL](https://docs.docker.com/engine/reference/builder/#stopsignal)

```dockerfile
STOPSIGNAL signal
```

用來設定 Container 離開時的 system call signal

範圍可以是 valid unsigned number. 但需要對照 kernel 的 syscall table. (就像 kill 發送的訊號那樣), ex:

- 9: SIGKILL


#### [Healthcheck](https://docs.docker.com/engine/reference/builder/#healthcheck)

用來檢測 Container 是否還 working. 啟用後, 會多了個 status 為 `starting`. 後續看狀況會變成 `healthy` or `unhealthy`

一份 dockerfile 若出現多個 HEALTHCHECK, 只有最後一個有效

有 2 種格式:
- `HEALTHCHECK NONE`: 禁用任何從 base image 繼承而來的檢查
- `HEALTHCHECK [OPTIONS] CMD command`: 藉由在 Container 內執行 check container health 的指令
    - OPTIONS 可以是:
        - `--interval=DURATION`, 預設 30s : 每隔多久做一次檢測
        - `timeout=DURATION`, 預設 30s : 若單一次檢測超過此時間, 則被視為 failed
        - `--retries=N`, 預設 3 : 若經檢測後 timeout, 會嘗試 N 次, 依舊失敗則判定為 `unhealthy`
        - `--start-period=DURATION`, 預設 0s
    - `CMD` 後面的 command 可以是:
        - *shell command*, ex: `HEALTHCHECK CMD /bin/check-running`
        - *exec array*(其他的 dockerfile commands), ex: `ENTRYPOINT`
            - 乾... 這邊看不懂, 遇到再說
    - command 的 exit status 表示 Container 的健康狀態:
        - 0: success
        - 1: unhealthy
        - 2: reserved: 並沒有使用 exit code (蝦小啦)

```dockerfile
# 5m 檢測1次, 3s timeout
HEALTHCHECK 
    --interval=5m \
    --timeout=3s \
    CMD curl -f http://localhost/ || exit 1
```


#### [ARG](https://docs.docker.com/engine/reference/builder/#arg)

- 基本用法: `ARG <name>[=<default value>]`
- Docker Image 建置階段可用來設置變數的方式, 若用 CLI, 可用 `--build-arg NAME=VALUE` 來代替
- WARNING: 不要把私密變數在 build time 的時候設置(任何人都可看到 via `docker history`)
- `ARG` 參數的生效, 從 Dockerfile 裡面宣告後的下一行便存在, 而非在使用 CLI 的時候才存在
- 
- 可透過下列方式來動態變換:

```dockerfile
FROM busybox
USER ${user:-some_user}
ARG user
USER $user
```
```bash
docker build --build-arg user=tony -t demo_arg .
docker run --rm demo_arg whoami
```

- `RUN` 可以執行 `ARG` 或 `ENV` instruction 聲明過的變數
- 若 `ARG` 及 `ENV` 同時宣告一樣的變數, 則 `ENV` 會覆寫 `ARG`, 看底下範例:
    - ![Env_overwrite_ARG](./img/env_overwrite_arg.png)


#### [Shell](https://docs.docker.com/engine/reference/builder/#shell)

似乎是用來給 win 用的, 遇到再說


#### [Environment replacement](https://docs.docker.com/engine/reference/builder/#environment-replacement)

ENV 與 ARG 複合變化:

------

`${variable:-word}`, if variable, 
    - then: $variable
    - else: word

------

`${variable:+word}`, if variable, 
    - then: word
    - else: ""

------

```dockerfile
ENV abc=hello
ENV abc=bye def=$abc
ENV ghi=$abc
```

最終結果, abc = bye , def = hello , ghi = bye

上述的這些 ENV, 只有在 image build 階段有用, runtime 期間則無用

------


#### [EXPOSE](https://docs.docker.com/engine/reference/builder/#expose)

這東西, 可視為 建構 Image 與 運行 Container 兩者之間的文件

可透過 `docker run -p` 來複寫 dockerfile 內部定義的 `EXPOSE`


#### [LABEL](https://docs.docker.com/engine/reference/builder/#label)

我覺得這很無聊... 遇到要用再來看了


#### [MAINTAINER](https://docs.docker.com/engine/reference/builder/#maintainer-deprecated)

這個更無聊, 已經被 deprecated. 使用 `LABEL` 來代替

