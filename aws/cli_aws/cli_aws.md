
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

- 目前為 SigV4(簽章版本4) (2022/07)
- Signing AWS API requests
- 此為 AWS 專屬的 protocol
- SigV4 是指, 用自己的 credentials 來 sign request to AWS
    - 而非 you are authenticated against AWS


# Troubleshooting

```bash
aws ec2 run-instances \
    --image-id ami-0b7546e839d7ace12 \
    --instance-type t2.micro \
    --key-name ${KEY} \
    --dry-run

#An error occurred (UnauthorizedOperation) when calling the RunInstances operation: You are not authorized to perform this operation. Encoded authorization failure message: tKnNGESxqhaikWXnwV11a6NDB2d72QvQ89I6_gQlR3P8_rE-oSn7N5-psnOBPcidJ_aJyy0St-7iykDTk-R8_W-ACflXUnZQjx4qbG82n2IO7yXXB1BgFa3gG_JVEhDE4F8h0xkEY7OinR_CFp0PK1oBHKf3Tbrtni1xHJy15W1DI90-rizc9APkGBrpTy3R2USZbPWkMkxLLiFarrp0TKTQKOKMsGh7jpKMmtAWQ2BmpE9kg6wSuU-Y-lBKC1hPT3VwzTwq7q7Bz0D7IWn7oHnvCzBC2P1SUSfvEIZTIJSBCH1ZdV3qtDTCZswdWQU8MVjHf-WbTqsuLABizyQcoJndw4sChX6So0Ym1RJ59VTuX_uYfOkUpgV0cTYyGYyc3KSytuB-iN-bJatiBaiTZp2QvnIaGW5T2CV6QvyEZKzGS8G3YsmFMuM4Rq7hOYWkca5NHnKc1LPRX13gV0jSj914KA9jEqcWfoZO59L0q7hGTxZNHno0LysQna1XbQjyD_oTlyuwt2yiCROTP16TZt8XnU11gCthHSe6vEVby19eAT7FDA04AgTqQziMc4mh_AlEnDl8gZlSTN16ZSarykdW83bEJTHbTzRX1WqObDn7AEIcFmJvTQkKnSsDMgXEXgo18eeTSm5OBb2S6riF75RHbBPYK_Z704-B5A


### 解析 aws Encoded Error Message
# (EncodedErrorMessage 就是前面一個指令拋出的 Exception : Encoded authorization failure message 後面那包)
aws sts decode-authorization-message --encoded-message ${EncodedErrorMessage}
#An error occurred (AccessDenied) when calling the DecodeAuthorizationMessage operation: User: arn:aws:iam::152248006875:user/tonytest is not authorized to perform: sts:DecodeAuthorizationMessage because no identity-based policy allows the sts:DecodeAuthorizationMessage action
# 如果再看到這錯誤, 需要 allow sts DecodeAuthorizationMessage 的權限
```


# 其他

如果覺得 `aws xxx` 指令列出結果都是 less 輸出很煩, 可在 `~/.aws/config` 的 profile 配置: `cli_pager=`
