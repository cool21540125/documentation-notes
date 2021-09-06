# Drone

### drone CLI

- [Drone CLI](https://docs.drone.io/cli/install/)
- [drone CLI notes](https://gist.github.com/cool21540125/dc536c651d5a97ec3823bd826dece7c5)

```bash
### Macbook
$# curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_darwin_amd64.tar.gz | tar zx
$# cp drone /usr/local/bin

### Linux
$# curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx
$# install -t /usr/local/bin drone
# Note: 記得加環境變數  


$ export DRONE_SERVER=https://example.tonychoucc.com
$ export DRONE_TOKEN=XXXXX  # Drone Server 的 Personal Token

### 若成功的話, 表示正確連到 Drone Server 了
$ drone info
User: cool21540125
Email: cool21540125@gmail.com
```


## pipeline

- drone 0.8 版以後, 拆成: `drone-server` && `drone-agent`
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