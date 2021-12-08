# Systemd Journal

- 2018/08/15

CentOS7 使用 **雙軌並行** 來記錄 Log, `舊制 rsyslog` + `新制 journalctl`

rsyslog : `systemctl status rsyslog`

底下很容易搞混的名詞...

- priority : 優先度
- severity : 嚴重度
- facility : 適用度


## syslog protocol (工業標準協定)

採用 `3位元(Code)` 來記錄 Log 等級, 額外得紀錄2個欄位: `facility / type` 及 `priority / severity`

Code | Priority | Severity
---- | -------- | -------------------------
000  | emerg    | 系統異常
001  | alert    | 必須要被立即處理的錯誤
010  | crit     | 危急情況
011  | err      | 非危急的錯誤
100  | warning  | 警告
101  | notice   | 正常情況的重大事件
110  | info     | 事件資訊
111  | debug    | Debug 資訊



# 1. rsyslog (CentOS7 以前)

目前這個機制在 CentOS7(含)以前, 一直存在

設定檔放在 `/etc/rsyslog.conf`, 使用者自訂的設定檔可放在 `/etc/rsyslog.d/*.conf`

Log 統一存到 `/var/log/`

```sh
# logger -p facility.severity "<Log Message>"
$ logger -p local7.notice "TEST by Tony, Logging messages..."
# 此指另下下去之後, 系統會遵照
# /etc/rsyslog.conf 
# 第 54 行定義的 log 方式, 把訊息寫入
# /var/log/messages
```



# 2. journalctl (CentOS7 新)

OS7 導入的 Logging 機制, 會把 message 以 `binary` 的形式, 加入 `index` 寫到預設目錄 `/run/log/journal/`(reboot 就都沒惹QAQ), 但系統可能開機開了幾十年沒當機阿... 那磁碟不就爆惹~ 系統會每個月驅動 *rotation mechanism* 機制來清Log, 此外, `Log不會超過 10% 的系統容量 && 系統剩餘空間 < 15% 時, 舊 Log 會被清除` ;  設定檔放在 `/etc/systemd/journald.conf`

```sh
# @@ 如果希望 reboot 後, 依然看得到 journalctl 的 舊 Log (可以用 journalctl -b 來查看), 設定方式如下:
$# mkdir /var/log/journal
$# chown root:systemd-journal /var/log/journal
$# chmod 2755 /var/log/journal
# 如此一來, journalctl 就會把 log path 從 「/run/log/journal」→「/var/log/journal」
```

`journalctl` 會把 `notice OR warning` 以上標註為 **粗體** ; `error` 以上標註為 <font style="background-color:red;">紅底</font>

```sh
# 印出 最近一次開機到現在的 Log
$ journalctl

# 顯示最新 87 筆
$ journalctl -n 87

# 顯示 error 以上的 Log
$ journalctl -p err

# 追蹤 最新 Log (類似tail -f)
$ journalctl -f
# 也可使用 「--since」, 「--until」 來限定時間區間

# 給日期區間
$ journalctl --since today
$ journalctl --since "2015-02-10 18:00:00" --until yesterday
$ journalctl --since "09:00:00"

# 可以查看 特定 pid 的 Log
$ journalctl _PID=1182

# 特定 uid 的 Log
$ journalctl _UID=81

# 特定 service 的 Log
$ journalctl _SYSTEMD_UNIT="sshd.service"

# 列出詳細資訊
$ journalctl -o verbose

# 看前次開機到現在的 log (需要先設定稍早 @@ 說明的地方)
$ journalctl -b -1
```
