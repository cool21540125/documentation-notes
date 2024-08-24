# Secret Manager

- 使用方式類似 **SSM Parameter Store**
  - 儲存機敏資訊
  - 使用 Lambda 來實踐, 加密則使用 KMS
  - 可制定每隔 X days 來對 secret 做 rotation (force rotation)
  - ex: 可由此服務, 來同步 RDS 的 secrets
- 與 RDS, Aurora 有相當高度的整合
- Secret Manager - Pricing, 分為 2 個部分:
  - 每個 Secret 每個月 $0.4
  - 每 10000 個 API 請求 $0.05
- Rotation strategy 有 2 種:
  - Single user
  - Alternating users
