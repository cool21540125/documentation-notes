# ELB - Access logs

- 啟用了 ALB Access logs 以後, 會將 logs 每隔 5 mins 發送到 S3, 並且做保存
- ALB Access logs 會去紀錄所有打到 ALB 的請求(包含 bac request), 但不會紀錄 health check
- ALB Acess Log filename 為: `bucket[/prefix]/AWSLogs/aws-account-id/elasticloadbalancing/region/yyyy/mm/dd/aws-account-id_elasticloadbalancing_region_app.load-balancer-id_end-time_ip-address_random-string.log.gz`
- 至於該如何分析非常大量的 ALB Access logs, 則需要依賴其他工具:
  - Athena
  - Loggly
  - Splunk
  - Sumo logic
- ALB 要將 log files 寫入到 S3 Bucket 的話, 需要判斷這個 ALB 是哪時候建立的, 以及是否為 GovCloud (US) Region 或 Outposts Zones 來設定 Bucket Policy
  - 早期建立的 ALB, Bucket Policy 需要再依照他所屬的地區, 來授予不同的 `arn:aws:iam::elb-account-id:root` 訪問 (並非自己的 Account ID)

# ELB - Connection logs

# ELB - Request tracing
