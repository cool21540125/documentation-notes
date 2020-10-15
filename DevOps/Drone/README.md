# DevOps

- 2020/01/23
- [DockerHub-DockerRunner](https://hub.docker.com/r/drone/drone-runner-docker)
- [DockerRunner配置](https://docker-runner.docs.drone.io/installation/reference/)

## GitLab

> User Setting > Applications > Redirect URI 填入 `https://DRONE_HOST/login`
  DRONE_HOST 可使用 ngrok 來做本地測試, 我使用 `ngrok http -host-header mydrone.com 17777`

Scopes 選擇 `api` && `read_user`, 取得底下:

- Application ID:
- Secret:

填入 `.docker-compose.yml` 對應的 GitLab 環境變數對應的 CLIENT && SECRET

## Drone

- [使用Drone进行CI支持(分類還蠻詳細的)](https://xenojoshua.com/2019/12/drone-ci/#1-%E5%89%8D%E8%A8%80)
### Install drone CLI

- https://docs.drone.io/cli/install/

```bash
### Macbook
curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_darwin_amd64.tar.gz | tar zx
sudo cp drone /usr/local/bin

### Linux
curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx
install -t /usr/local/bin drone
# Note: 記得加環境變數
```

在存有 `.drone.yml` 的地方使用 `drone exec`, 就算沒有 drone server, 依舊可以執行測試

![drone exec](../../img/drone_exec.jpg)

### Install drone by compose (Server && Agent)


Drone 基於 Container 的 CI/CD 系統(所有流程都在 Docker Container). Git push 後, 驅動 Drone 開始執行 (都在 Docker 內)

- Git Clone
- Test
- Package
- Deploy
- Send Message

使用 `.drone.yml` 做組態控制

---

drone 0.8 版以後, 拆成: `drone-server` && `drone-agent`


# 使用 Drone CLI

```bash
### https://gist.github.com/danielepolencic/2b43329495d018dc6bfe790a79b559d4
export DRONE_SERVER=https://8d903309.ngrok.io  # Ngrok 的 public domain
export DRONE_TOKEN=XXXXX  # Drone Server 的 Personal Token

### 若成功的話, 表示正確連到 Drone Server 了
$# drone info
User: cool21540125
Email: cool21540125@gmail.com
```

## Drone Exec Runner

```bash
### 非 root 的 exec runner 配置檔
# https://docs.drone.io/runner/exec/configuration/reference/
# https://exec-runner.docs.drone.io/installation/reference/
$# vim ~/.drone-runner-exec/config
### ------- 如下 -------
# 呼叫遠端 Drone Server 的協定
DRONE_RPC_PROTO=https

# (必備)Drone Server (Drone Agent 要 follow 的 Drone Server)
DRONE_RPC_HOST=drone.company.com

# (必備)Drone Server 用來驗證 http request 的 共享密鑰(Shared Secret)
DRONE_RPC_SECRET=super-duper-secret

# 能找到 drone 指令工具的位置
DRONE_RUNNER_PATH=/usr/local/bin:/usr/bin:/usr/sbin:/sbin

# log file path (資料夾需要先建好)
DRONE_LOG_FILE=/Users/<user>/.drone-runner-exec/log.txt
### ------- 如上 -------

```

exec runner 會在 host 端寫 log,



## pipeline

- pipeline 裡面可能會含有 build, deploy, 由多種行為(step)共同組成一個 pipeline
- pipeline 裡面的每個操作稱作 step, 一到多個 step 組成一個 pipeline(任務)
- trigger 決定目前的 pipeline 是否要被觸發. 可根據 branch, event, repository, runner, status, ...
- condition 決定目前的 step 是否要被觸發. 可根據 branch, event, repository, runner, status, ...
- runner 只是 pipeline 的執行者, 不管是怎樣的 pipeline 都可在任何的 runner 上面運作
  - ex: 一個 docker pipeline, 如果在 exec runner 上面就會在 host 上啟動 docker 來執行

不同種類的 Runner Environment Variables
- [DockerRunner](https://docker-runner.docs.drone.io/configuration/environment/variables/)
- [ExecRunner](https://exec-runner.docs.drone.io/configuration/variables/)
- [SshRunner](https://ssh-runner.docs.drone.io/configuration/variables/)

drone 提供了底下幾種 runner
- docker runner: 全部在 Container 內, 保證跨平台
- exec runner: 在 runner 所在的主機上執行, 一般用在某些不方便在 container 內執行的工作
- ssh runner: 通常透過 ssh 執行遠端命令來做建置
- kubernetes runner: (不鳥他)
- digital ocean runner: (不鳥他)

```yml
### v1.x 寫法
---
kind: pipeline  # 會去找 agent
name: default

steps:
  - name: backend
    image: python:3
    commands:
    - pytest
  - name: frontend
    image: node
    commands:
    - xxx
    - yyy
  - name: build
    image: plugins/slack
    settings:
      channel: general
    depends_on:
    - backend
    - frontend

# 底下是另一個任務
---
kind: pipeline
name: zzz
```