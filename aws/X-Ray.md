# AWS X-Ray

- 使用 X-Ray 方式:
  - SDK
    - traditional SDK
    - ADOT(AWS Distro for OpenTelemetry) SDK
  - API
  - CloudWatch Application Signals
- 視覺化 Request 近來到 APP 以後, 整個後端的資料流
  - Tracing && Visual analysis for APP
  - 對於 Distributed System 排查很有幫助
    - 可對 分散式系統的 log 彙整, 並提供 UI, 可在 **X-Ray** Console 看到 Service Performance Status
  - 它會在我們的 Request 塞 `trace` 這神奇的東西
    - Trace: segments collected together to form an end-to-end trace
      - trace 裡頭由一系列的 `segments` 所構成
        - segment 又由一系列的 `subsegments` 所構成
    - X-Ray 並不會接收來自 ELB 的資料
      - ELB 會在 Request Header 塞 `X-Amzn-Trace-Id`
  - Request 發送到 AWS Resources 上頭, Resources 可針對 trace 做一些識別, 最終得出一個 Service Map
- X-Ray Charge : 針對送到 X-Ray 的 資料量 計費
- X-Ray App 每秒批次 傳送 `Traces(Segments)` 到 X-Ray Service
- Old way for debugging in production
- 可直接在 local test, 並 log -> anywhere
- Use Cases:
  - 用來對 Performance 做 troubleshooting(bottlenecks)
  - pinpoint service issue
  - review request behavior

# X-Ray 概念

- X-Ray 會以 `segments` 的單位從 Service 接收到資料, X-Ray 再將它們組合成 `traces`, 最終再將這些 traces 組合成 `service graph`
-

# X-Ray Usage

- EC2 Type - 需要 `install && run X-Ray Daemon`
- Farget Type - 需要 `enable X-Ray AWS Integration`
  - Task 裏頭需要掛一個 `X-Ray Sidecar`
  - `UDP port 2000` 通訊
- IAM Role : `AWSX-RayWriteOnlyAccess`

# X-Ray 各種關鍵字

- sampling
  - 因為 X-Ray 收了一大堆數據, 用這個可以僅收集你感興趣的欄位
  - X-Ray Sampling Rules(採樣規則) - 協助節省傳送到 X-Ray 的流量
  - 預設 X-Ray SDK 會紀錄:
    - 每秒鐘第一筆 Request
    - 該秒內其餘 5% 的 Request
  - Custom Sampling Rules
    - 可自行配置 (in Web Console, 改後無需重啟服務, 無需動 Code)
      - reservoir(池, 水庫) : ex: 10, 則表示每秒鐘蒐集前十筆
      - rate : ex: 50%, 表示蒐集該秒內 幫我蒐集一半的請求
        - 會花很多錢... 不過對於排查很有幫助
      - (還有其他...)
- annotations
  - Key Value pairs used to index traces and use with filters
  - 方便搜尋及篩選效率
- interceptors
- filters
  - X-Ray Filter expression
  - Use filter expressions to view a service map or traces for a specific request, service, connection between two services (an edge), or requests that satisfy a condition.
  - 此與節省流量啥的無關... 地位好像是跟 PromQL 一樣, 用來篩選而已?
- handlers
- middleware
- subsegments
  - 如果想要 segments 裡頭有更多細節的話參考這個
