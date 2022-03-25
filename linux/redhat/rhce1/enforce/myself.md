```sh
### 設定密碼變更政策
$# chage -E xx -M yy -d zz tony
# tony 帳戶
# xx 天後密碼到期
# 往後每隔 yy 天要改密碼
# 離最近一次密碼失效只剩 zz 天
$# tail -1 /etc/shadow
# 17835 (今天))))))))


### 選擇時區/首都
$# tzselect

### 使用者密碼政策設定檔
$# vim /etc/login.defs

### 日誌
$# journalctl --since xxx --until yyy

### 時間校正
$# vim /etc/chrony.conf
$# systemctl restart chrony
$# chronyc sources -v

### logger
$# logger -p authpriv.alert '@@'

### 
$# yum repolist

### 尋找 / 內所有 *data* 檔名 所有軟連結
$# find / -type l -name "*data*"

### 同步
$# rsync -av sourceDir backupDir
```

