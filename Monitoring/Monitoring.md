# Monitoring System abstract

- Nagios
  - 老牌監控工具, 原名為 NetSaint
  - written by C
  - 主力在於 主機監控 && 網路監控
  - 資料儲存在 `Round Robin Database, RDD` (環狀資料庫)
    - RDD, 為時序資料庫
- Open-Falcon
  - 小米開放原始碼的監控工具
  - written by go
- Zabbix
  - written by go + PHP

# Monitoring

- 監控範疇
  - Application Level - `Application Performance Management, APM`
    - Call Chain
    - Http Delay
    - Performance
    - Status
  - Middleware Level
    - Cache
    - Message
    - Service
    - DB
  - Infra Level
    - CPU
    - Memory
    - Network
      - 通常基於 `Simple Network Management Protocol, SNMP`
      - 網路效能監控: `Network Performance Monitor, NPM`
    - Storage
    - Disk I/O
    - Java Machine
      - `Java Management Extensions, JMX`
    - Server
      - 針對實體硬體的監控: `Intelligent Platform Management Interface, IPMI`
      - 由 Google 開放原始碼的 cAdvisor 可以取得 host 上所有 Container 的效能指標
        - 其他 Open Source 監控專案另有:
          - Zabbix
          - Open-Falcon
          - Prometheus
- 監控架構
  - 實現方式:
    - 資料取得
      - pull
      - push
      - pull + push
    - 資料傳輸
      - Socket
      - Http
    - 資料儲存
      - RDB
      - No-SQL
        - MongoDB
        - OpenTSDB
        - InfluxDB
  - 核心子系統
    - 資料擷取子系統 : extract, filter, process, store
    - 資料處理子系統 : analyze, display, warning, alert, notify, action

# Monitoring CLI Tools

![linux_perf_tools_full](./img/linux_perf_tools_full.png)
