# Replication

## Logical replication

- 邏輯快照(邏輯複製) 有點像是 在特定時刻擁有 資料快照
- 邏輯快照 會去紀錄 transaction 層級的 SQL 增刪改的動作, 並且將此 SQL operation 記錄下來 && 傳輸到 replica 執行相同的動作
- 邏輯快照 常見應用情境:
  - Data Warehousing
    - 定期將資料從 即時資料庫 更新到 分析資料庫 (不會對系統造成影響)
  - Real-time analytics
    - 提供當前的資料以供檢查 (不需要複製整個 dataset)
  - Cross-Database data sharing
    - 讓不同服務能夠存取相同的 data subsets (而不需要複製整個 database)

## Physical replication

- 物理快照 比較像是 複製整個 hard drive (而非 individual files)
- 物理快照 可以確保 系統內的 every byte 都能夠被精準的同步複製
- 物理快照 最常見的方法, 便是使用 streaming replication (不斷地將資料更新傳輸到 replica)
- 物理快照 常見應用情境:
  - Disaster Recovery
    - 發生故障的時候能夠迅速的因應 (減少停機 & 減少資料遺失)
  - HA Clusters
    - 確保 replica 可隨時替換為 master (確保資料完整性)
  - Failover configuration
    - 確保硬體問題發生的當下能夠做故障轉移
