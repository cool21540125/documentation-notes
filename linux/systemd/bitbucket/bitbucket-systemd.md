
# bitbucket-shell-runner

- 2023/05/18
- bitbucket runner 做成 systemd service on CentOS7
- [Set up runners for Linux Shell](https://support.atlassian.com/bitbucket-cloud/docs/set-up-runners-for-linux-shell/)


```bash
vim /usr/lib/systemd/system/runner.service

systemctl daemon-reload && systemctl stop runner && systemctl start runner

### status && logs
systemctl status runner
journalctl -u runner -f
```
