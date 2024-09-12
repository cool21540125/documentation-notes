# UPDATED - 2024/07/25 以後建立的 AWS Account, 將不再能使用 CodeCommit

既有用戶仍可繼續使用, AWS 仍會做安全性更新, 但不會再有新功能

https://aws.amazon.com/blogs/devops/how-to-migrate-your-aws-codecommit-repository-to-another-git-provider/

# CodeCommit

- CodeCommit 訪問方式, 支援下列 3 種協定:
  - HTTPS
  - SSH
  - HTTPS(GRC) (這好像是 AWS 自己搞出來的東西)
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

## CodeCommit by SSH

> AWS Console > IAM > Users > USER > Security credentials > SSH Keys for AWS CodeCommit
>
> 把 `~/.ssh/aws_key.pub` 丟進來

- root account 看不到這個
- 將上述新增的 SSH Key ID, 大概長這樣: `APKASG4VQHDN23IKAAN4`, 配置到 `~/.ssh/config`, 如下:

```
Host git-codecommit.*.amazonaws.com
    User          APKASG4VQHDN23IKAAN4
    IdentityFile  ~/.ssh/aws_key
```

## CodeCommit by HTTPS Git credentials for AWS CodeCommit

> AWS Console > IAM > Users > USER > Security credentials > HTTPS Git credentials for AWS CodeCommit > Generate
>
> 可以得到一組專用的 Username & Password (此為 Git Credentials)

# CLI

```bash
### 使用 CLI 快速建立一個 AWS CodeCommit Repository, 名為 git-test101
repo_url=$(aws codecommit create-repository --repository-name git-test101 --query repositoryMetadata.cloneUrlHttp --output text)
echo $repo_url


### List repos
aws codecommit list-repositories


### Delete repo
aws codecommit delete-repository --repository-name git-test101
# @@ 2023/04/02 不知為何此指令執行後, 沒有任何輸出結果 && 沒錯誤 && 但也沒刪除


###
```
