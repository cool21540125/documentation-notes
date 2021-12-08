# 系統優化相關

## 關閉印表機服務

- 2018/07/31
- 我的筆電根本就沒有要用印表機阿XD... 白白浪費近2年的效能
- 但是把東西轉成 pdf 到底是不是透過這服務... 就不知道了

```sh
# 觀察列印服務
$ systemctl status cups

# 關了吧關了吧~~
$# systemctl stop cups
Warning: Stopping cups.service, but it can still be activated by:
  cups.socket
  cups.path

# 關了吧關了吧~~
$# systemctl disable cups
```

