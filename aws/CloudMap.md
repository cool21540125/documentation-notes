# AWS Cloud Map, CloudMap

![WithCloudMap](./img/WithCloudMap.png)

- AWS CloudMap 是個 `Client-Side Service Registry & Discovery` solution
- Cloud Map 已與 ECS 及 EKS 做了深度整合. 因此使用這兩種服務時, 會自動使用 CloudMap
- 用來建立 需要依賴於 後端 services/resources 的一層類似轉接器/窗口 的服務
  - 讓 Frontend 不用依賴於後端特定版本, 而是藉由訪問 **Cloud Map**, 來取得後端 服務位置(URL)
  - developer 使用 api -> Cloud Map, 來更新版本. ex: v1 -> v2
  - frontend 便會 動態的查找(Dynamic lookup) v2 location. 之後再直接連到 v2
    - 免改 frontend code
- 服務本身會做 Health check, 避免發送到後端不健康的 endpoint
- 比較
  - Server-based discovery
    - Client 連接到 `Server Endpoint`, 再由 Server 負責將請求路由到 healthy 的節點
    - ex: ALB, Nginx
  - Client-based discovery
    -Client 連接到 `Service Registry`(基本上是個 DB), client 藉由 logical naming scheme 來查詢出一個 known identifier, Server 再回應 DNS / IP
