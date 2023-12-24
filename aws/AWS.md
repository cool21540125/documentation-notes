
- [AWS Serverlessland](https://serverlessland.com)
    - 裡頭有一堆 AWS Serverless 的範例
- [Serverless Patterns Collections](https://serverlessland.com/patterns)


# AWS Billing

- 若要查看 Billing 或是配置 Billing alarms, 必須切換到 us-east-1 的 CloudWatch
- AWS Billing 裡頭呈現的是 真實成本, 而非預估成本
- 關於 AWS Billing 及 AWS Cost, 有下列的對應服務可以使用
    - 預估使用成本:
        - Pricing Calculator
    - 追蹤服務成本:
        - Billing Dashboard
        - Cost Allocation Tags
        - Cost and Usage Reports
        - Cost Explorer
    - 監控成本計畫:
        - Billing Ararms
        - Budgets
- 如何允許 IAM 用戶看帳單 (預設只有 root Account 可看)
    - (右上角) > Account > IAM User and Role Access to Billing Information > Edit > Activate IAM Access
        - ![Billing](./img/iam_billing.png)
- 如果在 Console > Billing Preferences > Receive Billing Alerts , 需要等 15 mins 才會有資料
