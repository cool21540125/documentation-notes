# 密碼政策

```sh
chage -E xxx -M yyy -d zzz
# -E : 到期日
# -M : 每...天要修改一次密碼
# -d : 幾天後立即生效

##### Question:
# 新增使用者 tony87, 預設密碼為 iam87, 參加附屬群組 super87
# 以後所有使用者, 每隔 30 天都需要更換一次密碼
# 而 tony87 比較特殊, 他的密碼 7 天后到期, 往後每隔 14 天要修改一次密碼, 首次登入後, 立即實施密碼政策

##### Answer:
$# vim /etc/login.defs
PASS_MAX_DAYS   30      # 最大密碼天數
# 改後存檔離開

$# chage -E "+7 days" -M 10 -d 0 tony87
```
