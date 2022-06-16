


# EC2

- 讓 EC2 找到自身的 meta-data, 但只能在 *Web Console* && *CLI*, 這動作本身不需要權限
    - `curl http://169.254.169.254/latest/meta-data`
    - https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html
- 