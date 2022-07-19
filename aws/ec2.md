# EC2

```bash
### 讓 EC2 找到自身的 meta-data, 但只能在 *Web Console* && *CLI*, 這動作本身不需要權限
$# curl http://169.254.169.254/latest/meta-data
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html

### CLI 找機器的 meta-data
$# aws ec2 describe-instances
```


# 額外補充

- AWS 似乎有支援 `ceph`(檔案系統), 可支援 `Object Storage` && `Block Storage`
