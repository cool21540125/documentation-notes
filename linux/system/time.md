# Linux 系統時間

- 2021/04/20


查看 時區、時間、日期 的各種方式

```bash
### CentOS Linux release 7.9.2009 (Core), 以下資訊大多數來自同一台

### date
$# date  # 依照主機的時區, 顯示時間
Tue Apr 20 11:58:04 CST 2021
$# date +%F
2021-04-20
$# date +%R
11:58
$# date +'%:z %Z'  # 可看時區
+08:00 CST

###
$# timedatectl
      Local time: Tue 2021-04-20 11:58:04 CST
  Universal time: Tue 2021-04-20 03:58:04 UTC
        RTC time: Tue 2021-04-20 03:58:05
       Time zone: Asia/Shanghai (CST, +0800)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: n/a

### 若沒有 timedatectl 指令, 可藉由此方式查詢時區
$# ll /etc/localtime
lrwxrwxrwx. 1 root root 35 Feb  4 11:28 /etc/localtime -> ../usr/share/zoneinfo/Asia/Shanghai
# 改變時區方式:
#  sudo ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# Debian base 才有這東西 (CentOS 沒有!)
$# cat /etc/timezone
/UTC

$# echo $TZ
# 沒東西

### 外部 API 也可查 (依照 IP 判斷)
$# curl https://ipapi.co/timezone
Asia/Taipei


### 後面不接任和參數, 回傳硬體時間
$# hwclock
Tue 20 Apr 2021 12:18:22 PM CST  -0.705587 seconds

### 使用 ntpdate 校時
$# ntpdate
20 Apr 12:19:01 ntpdate[31601]: no servers can be used, exiting
```





## 時間校正

系統開機時, 會去抓取 RTC(local hardware clock), 但硬體時間不一定準

所以通常會啟動 `chronyd` 來與 **NTP Server** 作時間校正, 但如果在封閉網路內的話(連不出去@@), 則需要到設定檔 `/etc/chrony.conf` 更改時間校正的 Server IP

```sh
$# timedatectl
      Local time: Wed 2018-08-15 18:54:33 CST   # 目前時區 時間
  Universal time: Wed 2018-08-15 10:54:33 UTC   # UTC 時間
        RTC time: Wed 2018-08-15 10:54:33       # 硬體時間
       Time zone: Asia/Taipei (CST, +0800)      # 洲別(大洋別)/首都
     NTP enabled: yes       # NTP 時間校正服務
NTP synchronized: no
 RTC in local TZ: no        # local hardware clock(RTC)
      DST active: n/a       # 日光節約時間
# Linux 關機時, 會把 UTC Time 寫入硬體時間
# Microsoft 開機時, 抓取的時間都是抓 BIOS 的 Local Time

# 更改 timezone -> America/New_York
$# timedatectl set-timezone America/New_York

$# timedatectl
      Local time: Wed 2018-08-15 07:00:00 EDT
  Universal time: Wed 2018-08-15 11:00:00 UTC
        RTC time: Wed 2018-08-15 11:00:00
       Time zone: America/New_York (EDT, -0400)
     NTP enabled: yes
NTP synchronized: yes
 RTC in local TZ: no
      DST active: yes
 Last DST change: DST began at
                  Sun 2018-03-11 01:59:59 EST
                  Sun 2018-03-11 03:00:00 EDT
 Next DST change: DST ends (the clock jumps one hour backwards) at
                  Sun 2018-11-04 01:59:59 EDT
                  Sun 2018-11-04 01:00:00 EST

$# timedatectl list-timezones  # 看所有時區
Africa/Abidjan
Africa/Accra
Africa/Addis_Ababa
Africa/Algiers
#...400多個時區

# 更改時間
$# timedatectl set-time 09:00:00

# 可互動式來設定時區
$# tzselect
```


# chronyd

早期使用 `nptd` 及 `nptq` 作時間校正, OS7 改用 `chronyd`

```sh
# 校時服務
$# systemctl status chronyd

# (不會看...)
$# chronyc sources -v
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
^* 103-18-128-60.ip.mwsrv.c>     2   9   377   254   +109us[ +120us] +/-   34ms
^? t1.time.sg3.yahoo.com         0   6     0     -     +0ns[   +0ns] +/-    0ns
# 上面倒數第二行的「*」是目前時間校時鎖定的 Server

# 把系統時間寫入到 BIOS
$# sudo hwclock -w
# 如果是雙系統或是虛擬機, 需要慎用!!
```