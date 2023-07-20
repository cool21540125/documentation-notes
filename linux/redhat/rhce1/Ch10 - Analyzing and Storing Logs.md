# Ch10 - Analyzing and Storing Logs

1. Log 機制
2. rsyslog
3. systemd-journald
4. 時間


## 1. Log 機制

CentOS7 使用 **雙軌並行** 來記錄 Log

1. 舊制: `rsyslog` : text-plain
2. 新制: `systemd-journald` : binary

```sh
##### 新舊兩種 Logging 機制, 預設同時在運行
### 舊制
systemctl status rsyslog.service                # 看服務
vim /var/log/messages                           # 看 Log
ll /var/log                                     # Log 位置(定期清除)

### 新制
systemctl status systemd-journald.service       # 看服務
journalctl                                      # 看 Log
ll /run/log                                     # Log 位置(關機後清除)
# 或 /var/log/journal
```

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

###### 採用 `3位元(Code)` 來記錄 Log 等級


## 2. rsyslog

- facility : 適用度 (type of messages)
- severity : 嚴重度
- priority : 優先度 (priority of messages)


### 2.1 主要設定檔 : `/etc/rsyslog.conf`, 檔案分成 3 個區塊

1. MODULES
2. GLOBAL DIRECTIVES
3. RULES
    * 格式: `facility.priority    LoggingPath`
    * 細節: 「.info」  info 以上 ; 「.=info」 info 才算

設定副檔預設路徑 : `/etc/rsyslog.d/*.conf`


### 2.2 Rotation - 日誌循環

為了避免磁碟爆掉, 系統會每天去檢查 `rsyslog` 所寫入的 `/var/log/*`, 看是否需要 **刪除Log** 或 **合併Log**. 

* 預設 7 天循環一次.
    - /var/log/messages
    - /var/log/messages-20181004
* 經過 N 次循環之後(通常為4週), 舊檔案會被移除


### 2.3 syslog 範例

```sh
vim /var/log/messages
Oct  7 02:55:07 vm75 systemd: Started Fingerprint Authentication Daemon.
Oct  7 02:55:07 vm75 journal: D-Bus service launched with name: net.reactivated.Fprint
Oct  7 02:55:07 vm75 fprintd: Launching FprintObject
Oct  7 02:55:07 vm75 journal: entering main loop
# 分成 4 個部分
# 1. 送出訊息的 Time stamp
# 2. 送出訊息的 Host
# 3. 送出訊息的 Program or process
# 4. Actual message
```


### 2.4 使用 `logger` 製造假 Log (測試用)

```sh
logger -p user.notice "FQ~"
cat /var/log/messages
```


## 3. systemd-journald

### 3-1 查看 journal log

**journalctl**
- notice or warning : 粗體字
- error 以上 : 紅字

```sh
# 列出所有 journal
journalctl

# 列出最新5筆
journalctl -n 5

# 追蹤最新一筆
journalctl -f -n 1

# 追蹤特定 Priority 以上的 Log
journalctl -p err

# 追蹤特定時間
journalctl --since today
journalctl --since "2018-09-01 18:00:00" --until "2018-10-01 00:00:00"

# 看更詳細的 Log
journalctl -o verbose

# 利用其他欄位來追蹤 Log
journalctl _SYSTEMD_UNIT=sshd.service
```

### 3-2 保存 journal log

如上一節所說, `/run/log/` 會因為關機後, 東西就GG了, 如果你已經在電腦上新增了 `/var/log/journal`(root:systemd-journal) 的資料夾, 則以後的 journal log 會改存到這邊~

因為 Linux 很少出問題, 可能電腦一開, 穩穩地就運行了好幾年, 為了防止 journal log 爆掉, 它也有它的 routing 機制:
- 檔案不會超過此分割區檔案系統的 10%
- 檔案系統若已經滿到 85%, 此 journal log 就不會再增長, 而會改以 刪舊增新的方式來繼續記錄 log


```sh
# journal log
# 這麼做之後, 以後重開機, 之前的歷史紀錄會被保留
mkdir /var/log/journal
chown root /var/log/journal
chgrp systemd-journal /var/log/journal
chmod 2775 /var/log/journal
```

```sh
# 此次開機到現在的 Log
journalctl -b

# 前次開機的 Log
journalctl -b -1
```


## 4. 時間

### 4-1 timedatectl

```sh
export TZ=Asia/Taipei
export TZ=UTC


$# timedatectl
      Local time: Sun 2018-10-07 04:47:09 CST
  Universal time: Sat 2018-10-06 20:47:09 UTC
        RTC time: Thu 2018-10-11 07:59:43
       Time zone: Asia/Taipei (CST, +0800)
     NTP enabled: no
NTP synchronized: no
 RTC in local TZ: no
      DST active: n/a

$# timedatectl (按兩下 tab)
list-timezones  set-local-rtc   set-ntp         set-time        set-timezone    status

$# timedatectl list-timezones | grep -i new
America/New_York
America/North_Dakota/New_Salem

$# timedatectl set-timezone America/New_York

$# timedatectl
      Local time: Thu 2018-10-11 04:45:19 EDT
  Universal time: Thu 2018-10-11 08:45:19 UTC
        RTC time: Thu 2018-10-11 08:45:19
       Time zone: America/New_York (EDT, -0400)     # 變了~
     NTP enabled: no
NTP synchronized: yes
 RTC in local TZ: no
      DST active: yes
 Last DST change: DST began at
                  Sun 2018-03-11 01:59:59 EST
                  Sun 2018-03-11 03:00:00 EDT
 Next DST change: DST ends (the clock jumps one hour backwards) at
                  Sun 2018-11-04 01:59:59 EDT
                  Sun 2018-11-04 01:00:00 EST
```


### 4-2 chronyd

- Network Time Protocol (NTP)
- 看圖 `/rhce1/attach/NTP Server.png`

```sh
$ systemctl status chronyd.service
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:chronyd(8)
           man:chrony.conf(5)

# 修改設定檔
$# vim /etc/chrony.conf

$# systemctl start chronyd.service

# 與 NTP Server 作時間校正的明細
$ chronyc sources -v
210 Number of sources = 2

  .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
 / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
| /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
||                                                 .- xxxx [ yyyy ] +/- zzzz
||      Reachability register (octal) -.           |  xxxx = adjusted offset,
||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
||                                \     |          |  zzzz = estimated error.
||                                 |    |           \
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* 103-18-128-60.ip.mwsrv.c>     2   6    17     9  +1762us[ +486us] +/-   59ms
^? t2.time.sg3.yahoo.com         0   6     0     -     +0ns[   +0ns] +/-    0ns

# 上面的 「*」為目前時間校正的 target server

# 把系統時間寫入RTC (寫入到 BIOS 慎用!!)
$# hwclock -w
# ↑ 慎用! 電腦灌雙系統的話(Win + Linux)
# Linux 以 UTC Time 為出發點
# Win 以 Local Time 為出發點


### 可以用來查看 硬體時間(RTC) 如何取得時間
$# hwclock --debug
hwclock from util-linux 2.23.2
Using /dev interface to clock.
Last drift adjustment done at 0 seconds after 1969
Last calibration done at 0 seconds after 1969
Hardware clock is on local time
Assuming hardware clock is kept in local time.
Waiting for clock tick...
...got clock tick
Time read from Hardware Clock: 2021/05/03 10:14:09
Hw clock time : 2021/05/03 10:14:09 = 1620008049 seconds since 1969
Mon 03 May 2021 10:14:09 AM CST  -0.797693 seconds
```
