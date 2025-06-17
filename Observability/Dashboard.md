# Observability Dashboard

這邊紀錄有關於 Dashboard 的 Common Sense

- Dashboard Metrics 的 Statistic:
  - `p99` : 99th 的值
  - `tm99` : 移除最高 1%, 做 average
  - `tc99` : 移除最高 1%, 做 count
  - `ts99` : 移除最高 1%, 做 sum
  - `wm(10%:90%)` : 將最低 10% 的值全替換為 10th 的值; 最高 10% 的值全替換為 90th 的值, 做 average (Winsorized Mean)
  - `tm(25%:75%)` 等同於 `IQM` : 移除 25th 以下 & 移除 75th 以上, 取 average
- Dashboard 的 Unit - Data
  - `bytes(IEC)` : 1 kibibyte = 1024 bytes
  - `bytes(SI)` : 1 kilobyte = 1000 bytes
