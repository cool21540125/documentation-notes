# Install awscli

- https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# CLI/SDK - credentials chain (權限順序)

1. CLI 明確聲明為最優先. ex: `aws ec2 ... --region XXX`
2. 環境變數. ex: `AWS_PROFILE`
3. `~/.aws/credentials`
4. `~/.aws/config`
5. ECS task credentials
6. EC2 Instance Profiles

- 需要留意安全性的範例:
  - 已配置 Instance Profile (具備最小必要權限)
  - 但有使用環境變數, 取得另一個權限身份 (具備完整權限)
  - 因此依照順位, 使用 CLI/SDK 是具備完整權限

# [Signing AWS API requests](https://docs.aws.amazon.com/general/latest/gr/signing_aws_api_requests.html)

> When you send API requests to AWS, you sign the requests so that AWS can identify who sent them. You sign requests with your AWS access key, which consists of an access key ID and secret access key.

- 目前為 SigV4(簽章版本 4) (2022/07)
- Signing AWS API requests
- 此為 AWS 專屬的 protocol
- SigV4 是指, 用自己的 credentials 來 sign request to AWS
  - 而非 you are authenticated against AWS

# pagination

- https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-pagination.html
