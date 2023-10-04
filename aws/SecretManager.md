
# Secret Manager

- 使用方式類似 **SSM Parameter Store**
    - 儲存機敏資訊
    - 使用 Lambda 來實踐, 加密則使用 KMS
    - 可制定每隔 X days 來對 secret 做 rotation (force rotation)
    - ex: 可由此服務, 來同步 RDS 的 secrets
- 與 RDS, Aurora 有相當高度的整合
- Charge: 依照 secret 數量 && API call 數量 來計費


# cli

```bash
### List Secrets
aws secretsmanager list-secrets



```
