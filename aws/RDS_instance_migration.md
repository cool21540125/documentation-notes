- 2025/03/18 文件閱讀紀錄

  [Key considerations in moving to Graviton2 for Amazon RDS and Amazon Aurora databases](https://aws.amazon.com/blogs/database/key-considerations-in-moving-to-graviton2-for-amazon-rds-and-amazon-aurora-databases/)

- 因為我們使用的是 Aurora, 製作 manual snapshot 不會影響到效能
  - `As a general best practice, you can take a manual snapshot before the modification to ensure easy rollback. For Amazon RDS in a Single-AZ setup, this results in suspending the I/O during the snapshot time, from a few seconds to a few minutes, depending on the size. On a Multi-AZ configuration, there’s no I/O suspension during snapshot. For Aurora, no performance impact or interruption of database service occurs.`
- 升遷完後, 由於 buffer cache 皆已清空, 因此運行後, 初期會有一段時間比較緩慢
  - `A change of instance type means a relocation of the instance to another hardware host, which means that the buffer cache isn’t maintained. Therefore, when the database on the modified instance restarts, the buffer cache is cold and initial queries might take longer.`
- 對於 Aurora 的 instance 升級, 為了 min downtime, 建議優先升級 replica, 確認驗證無誤後, 再 fail over 到 replica

  - `For Aurora with one or more Aurora replicas, when you modify the writer instance, an Aurora replica is promoted to the primary instance while the modification continues on the new Aurora replica (former writer). There is a brief interruption that typically is less than 120 seconds. For minimal downtime and risk, you can modify the instance on the Aurora replica first, validate it works as per your expectations, and then fail over to the now Graviton2 reader. Within your Aurora cluster, you can modify your instances to Graviton2 in any order that is suitable for your use case.`

- 使用 Aurora 的話, manual snapshot 不會影響到效能
- 剛升遷完畢後的 Instance, 會因為 Buffer cache 是空的, 因此運行初期一段時間會比較緩慢

## 對於 Aurora instance 升級, 為了要 Minimum downtime...

假設情境有 1 master & 2 replica

需確認達到 Aurora 必要的版本需求. 若還沒達到, 則進行 DB 版本升級後再來進行

確認已經啟用了 multi-az

建議啟用 Performance Insight

- (公告維護)
- 對於 Read replica 進行升級, 升級完畢後, 可看到不同 nodes 之間的 Size 不同
- 也可以做要到此就停止, 然後觀察一陣子監控變化再來決定是否繼續!!!
- 對另一個 replica 進行操作
  - Modify -> Failover priority, 把它順位調到比較後面 (tier 加大)
- 對 master 進行操作, Actions -> Failover
