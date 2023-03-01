
# CodeCommit

- private git repo, 支援 3 種協定
    - HTTPS
    - SSH (root account 看不到這個)
        - 權限配置步驟:
            - AWS Console > IAM > Users > USER > Security Credentials > SSH Keys for AWS CodeCommit
                - 把 aws_key.pub 丟進來
            - 將上述新增的 SSH Key ID, 大概長這樣: `APKASG4VQHDN23IKAAN4`
                - 配置到 `~/.ssh/config`
                ```
                Host git-codecommit.*.amazonaws.com
                    User          APKASG4VQHDN23IKAAN4
                    IdentityFile  ~/.ssh/aws_key
                ```
    - HTTPS(GRC) - 似乎是 AWS 自行實作的協定
        - AWS Console > IAM > Users > USER > HTTPS Git credentials for AWS CodeCommit
            - 要從這邊申請一組 credentials (git repo 使用的帳號密碼)
- 使用 CodeCommit 的 認證方式
    - git credentials
    - IAM user (AWS 建議)
    - IAM role
- 可針對 repo 設定各種 events notification(比較像是一些 description 的變更之類的), 發送到:
    - SNS
    - AWS Chatbot (Slack)
- 針對 git event, 可設定對應的 trigger, 目前支援:
    - Lambda
    - SNS
- Charge:
    - 5 active users free/month

