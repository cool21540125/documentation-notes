# ALB Pricing

ALB Pricing - 由 3 個部分組成 (以 2024/10 的 `us-west-2` 為範例):

1. 固定運行費用: `$.0225/hr`, 等同於 `$16.2/月`
2. LCU 費用: `$.008/LCU-hour`, 等同於 `$5.76/LCU-月`. 以下 4 個 LCU 取最大者, 作為 LCU 計費方式:

收費方式還會區分是否為 **Mutual TLS(稱之為 mTLS)** (底下說明皆忽略 mTLS 的計費方式)

- 每個 LCU 每秒提供 25 個 New Connections
- 每個 LCU 每分鐘提供 3000 個 Active Connections
- 每個 LCU 每小時，對於不同資源提供不同的 bandwidth
  - EC2, Container, IP - 每小時 1GB
  - Lambda - 每小時 0.4GB
- 每個 LCU 每秒鐘提供 1000 個 rule evaluations （前 10 個 processed rules 免費）
  - `Rule evaluations = 每秒請求數 *（ALB rules 數量- 10`

3. mTLS 費用: `.0063/hr` (ALB 做 Client Side 的證書認證)

# ALB Pricing - Example 1

## 假設情境:

- Server 每秒收到 1 new connection, 並且每個 connection 持續 2 分鐘 (持續 120 秒)
  - 也就是說, 理論上每秒鐘最多同時有 120 個 active connections
- 平均每個 Client 每秒發送 5 requests, Request + Response 總計為 300 KB/sec
- ALB 上頭有 60 Rules

## 計算:

- New Connection
  - 每個 LCU 每秒鐘提供 25 個 New Connection
  - 實際情況，每秒鐘有 1 個 New Connection
  - LCU 消耗數= 1/25= `0.04 LCU`
- Active Connection
  - 每個 LCU 每分鐘提供 3000 個 Connection
  - 實際情況、前 120 秒鐘、毎秒鐘會増加一個 Active Connection，至 120 秒鐘以後、Active Connection 維持在 120
  - LCU 消耗數：120/3000 = `0.04 LCU`
- Bandwidth
  - 每個 LCU 每小時提供 1GB 的 processed bytes
  - 實際情況，每秒鐘 300KB，也就是每小時 1.08 GB
  - LCU 消耗數：1.08/1000 = `1.08 LCU`
- Rule Evaluations
  - A LCU ATA 1000 rule evaluations
  - 實際情況，每秒鐘接收 5 Requests
    - `5*(60-10) = 250` 個 Rule Evaluations
    - LCU 消耗數：250/1000= `0.25 LCU`

上述 LCU 取最大者, `1.08 * .008 * 24 * 30 = 6.2208 美元`

因此, 每月 ALB 花費為: `16.2 + 6.2208 = 22.4208 美元`

# ALB Pricing - Example 2

## 假設情境:

- Server 每秒鐘 100 New Connections, 並且每個 Connection 都會持續 3 分鐘(持續 180 秒)
- 每個用戶平均每秒傳送 4 個 Request，每個連線處理 1KB/ sec
- ALB 設定了 20 個 Rules

## 計算:

- New Connection
  - 每個 LCU 每秒鐘提供 25 個 New Connection
  - 實際情況，每秒鐘有 100 個 New Connection
  - LCU 消耗數= 100/25= `4 LCU`
- Active Connection
  - 每個 LCU 每分鐘提供 3000 個 Connection
  - 實際情況，前 180 秒鐘，每秒鐘會增加一個 Active Connection， 至 180 秒鐘以後，Active Connection 維持在 18000
  - LCU 消耗數: 18000/3000 = `6 LCU`
- Bandwidth
  - 每個 LCU 每小時提供 1GB 的 processed bytes
  - 實際情況，每條連線每秒鐘 100 KB，也就是每小時 0.36 GB
  - LCU 消耗數: `0.36 LCU`
- Rule Evaluations
  - 每個 LCU 每秒鐘提供 1000 rule evaluations
  - 實際情況，每秒鐘接收 4 Requests
    - `4*(20-10)` = 250 18 Rule Evaluations
    - LCU 消耗數: 250/1000= `0.25 LCU`

上述 LCU 取最大者, `6 * .008 * 24 * 30 = 34.56 美元`

因此, 每個月 ALB 花費為: `16.2 + 34.56 = 50.76 美元`

# NLB Pricing

# GWLB Pricing
