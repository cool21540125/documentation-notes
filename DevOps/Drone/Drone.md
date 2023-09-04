DroneCI

- [pipeline的環境變數](https://exec-runner.docs.drone.io/configuration/variables/)
- [使用Drone进行CI支持(分類還蠻詳細的)](https://xenojoshua.com/2019/12/drone-ci/#1-%E5%89%8D%E8%A8%80)
- [DockerHub-drone/drone](https://hub.docker.com/r/drone/drone)
- [Drone.io-environments](https://docs.drone.io/server/reference/)
- [Drone.io-plugins](http://plugins.drone.io/drone-plugins/drone-docker/)
- [DockerHub-DockerRunner](https://hub.docker.com/r/drone/drone-runner-docker)
- [Docker Pipeline](https://docs.drone.io/yaml/docker/)
- [Drone 大神們的 Plugins](http://plugins.drone.io/jetrails/drone-cloudflare-dns/)
- [Drone 整合 Telegram](https://stanislas.blog/2018/08/setup-telegram-bot-for-drone-ci-cd-builds/)


## 重要

runner 執行 pipeline 的時候, `~` 指的是 workspace root, 而非 user home


## 架構

- Drone Server        : 負責蒐集 Git Repo 內所有專案的事件(定義在各個專案底下的 `.drone.yml`)
- Drone Runner(Agent) : 負責執行 DroneServer 分派下來的 pipeline流程. 有很多種, 但我只記錄 3 種(其他的用到再說):
  - Docker Runner
  - Exec Runner : 在 Runner 所在的主機執行(非 Drone Server 上運行)(2020/06, 目前為實驗性質)
  - SSH Runner : 通常透過 ssh 執行遠端命令來做建置
- 一個 Drone Server, 會設定追蹤一個 Git Server (不知道可否多個)
- 可針對每個專案設定是否 啟用(Activate Repository), 讓 Drone Server 針對特定事件去做些什麼
- 一旦專案被啟用後, 須在裡頭設定一個 `.drone.yml` (每個專案會有一個對應的 .drone.yml )
- 一個 `.drone.yml` 裡頭, 可以有 1~N 個 pipeline (community 版本, 只能讓單一 Drone Runner 來跑 pipeline)
