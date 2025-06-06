
# Architecture

- 區分成 Datadog Backend 及 Host
- Host 一端安裝了 Datadog Agent
    - Datadog Agent 又可區分為:
        - Collector
            - 走 http, TCP, 將蒐集到的資訊, 交給 Forwarder
            - collect metrics, events, logs, ...
        - DogStatsD
            - 走 http, TCP, 將蒐集到的資訊, 交給 Forwarder
            - 可藉由 python, java, ... lib, 走 UDP, 將資料交給 DogStatsD (做統計摘要)
        - Forwarder
            - 將 Host 上頭蒐集到的資訊, 走 HTTPS, 交給 Datadog Backend
            - 由 Memory Buffer 拋出去
    - 此外, Datadog Agent 又可選擇性的 spawn 底下的 Agents (在 config file 裡頭啟用):
        - APM Agent     : collect traces
        - Process Agent : collect live process information
        - UI Agent      : Mac/Windows 預設啟用在 5002 port


# Monitors

- time window
    - ![time window](../img/time%20window.png)
- DDog 有 2 種 notifications: `alert` 及 `warning`


# Config

```zsh
### ddog Mac 配置位置
cd /opt/datadog-agent/etc/
```


# 

