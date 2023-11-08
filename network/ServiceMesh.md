
## Service Mesh

- 定義
    - 處理請求分發
    - infra 層級
    - 部署為 Sidecar 的形式
    - 對於 App 保持透明


## 演進

- 程式邏輯耦合
- public library
    - 脫離得不夠乾淨
- proxy
    - 功能簡陋
- Sidecar
    - 
- ServiceMesh
    - ServiceMesh 是 Sidecar 的 網路拓墣模式
    - 用來處理 service-to-service 的基本通訊 (infra 層級)
    - 處理 cloud-native 複雜的服務通訊問題
    - 扮演著與 App 部署在一起的 lighweight network proxies
- ServiceMesh v2
    - 針對 V1 加上了 Control Plane (控制平面), Service Mesh v2 因此可區分為
        - 資料平面
        - 控制平面