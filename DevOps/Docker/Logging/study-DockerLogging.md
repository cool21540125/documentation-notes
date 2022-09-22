# [Docker Logging: A Complete Guide](https://sematext.com/guides/docker-logs/)

- 2021/03/10
- [Log Analysis: The Complete Guide](https://sematext.com/blog/log-analysis/)
- [Logagent](https://sematext.com/logagent/)

若容器將 log 導向 `STDOUT` 及 `STDERR`, 則在 Docker Host, 可在 `docker-data-root/containers/<container id>/<container id>-json.log` 找到

Docker Logging 策略大致上分成下列幾種方式:

## 1. Logging via Application

- 容器內部的 App 藉由 Logging Framework 自行 handle logging
    - ex: Java APP 可能使用 Log4j2 來訂定 format && 將 logs 發送到宿主幾以外的集中管理區
- 為了保存 logs, 必須 `configure persistent storage` 或 `forward logs to a remote dest`
    - 基礎的 [log aggregator](https://sematext.com/blog/log-aggregation/)
    - [log management tools](https://sematext.com/blog/best-log-management-tools/)
- Pros: 給予了 Developers 最大的控制方式)
- Cons: 額外的 Loading, 且可能還會受限於 Logging Framework, 而無法將 logs 保存下來也說不定


## 2. Logging Using Data Volumes

- 如字面上, 使用 [data volume](https://sematext.com/blog/top-10-docker-logging-gotchas/)
- Pros: 跨多容器, 使用 `share volume`
- Cons: 難以在不丟失資料的情況下, 遷移到其他 Docker Host


## 3. Logging Using the Docker Logging Driver

- Logging Driver 直接讀取自 容器內的 STDOUT & STDERR
    - 預設採用 `json-file` 紀錄, 改變 Logging Driver 將可把 logs event -> syslog, gelf, journald, 或者 其他端點
- Cons: `docker logs` 只能搭配 `json-file` driver, 且僅能傳送而無法解析, 此外容器關閉時也無法追查


## 4. Logging Using a Dedicated Logging Container

- 使用日誌容器, 此方式比較能符合 microservice architecture
- Pros: 
    - 不依賴於 DockerHost, 可在 Docker environment 管理 log files
    - 至其他容器自動 *aggregate logs*, 利於 monitor & analyze & store 或 forward
    - 易於遷移容器至其他 host, 且易於 scale logging infra (增加 logging container)
    - 可透過各種 streams of log events(Docker API data, stats) 來搜集 logs

本文推薦將 logs 送到 Logagent


## 5. Logging Using the Sidecar Approach

- 對於更加大型的 microservice architecture, 建議用此方式
- 與 Dedicated Logging Container 類似, 但這種方式 App Container 有自己的 Logging Container, 彈性更大
- Pros: 遇到再說
- Cons: 較難


# Get Started with Docker Container Logs

Docker Container Logs 分成 2 類: `daemon logs` 及 `container logs`


## What Are Docker Container Logs?

- Container 內部發送到 `STDOUT` & `STDERR` 的訊息都會被 logging driver 捕獲
    - 追蹤 log: `docker logs -f Container_Name` 
    - 觀察 CPU & Memory: `docker stats --no-stream` 
    - 觀察 running processes: `docker top Container_Name`
    - 觀察 Docker events: `docker events`
    - 觀察 Storage Usage: `docker system df`
- 開發階段, 將容器內的 Log 輸出到 `STDOUT` & `STDERR` 很方便除錯, 但若生產環境, 建議集中蒐集 Logs

### What Is a Logging Driver?

Container 預設啟用 `json-file` log driver

使用 CLI 的話, 指令如下:

```bash
docker run -d \
    --log-driver syslog
    --log-opt syslog-address=udp://syslog-server:514 \
    alpine \
    COMMANDS
```


### How to Configure the Docker Logging Driver?




### Where Are Docker Logs Stored By Default?
### Where Are Delivery Modes?
### Direct/Blocking
### Non-blocking
### Logging Driver Options
### Use the json-file Log Driver With a Log Shipper Container
### How to Work With Docker Container Logs Using the docker logs Command?
### How to Work with Docker Container Logs Using a Log Shipper?


# 2. What About Docker Daemon Logs?

