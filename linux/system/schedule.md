# schedule 排程

- 2018/09/01

區分成 3 個部分

1. 一次性工作 `at`
2. user 週期性工作 `cron`
3. syste, 系統排程 `cron`



# at 一次性工作 - atd 服務

使用 `at` 把 一次性工作, 丟到 **atd** deamon, 此 daemon 提供 26 個 queues, 越前面越優先 (*nice level* 比較小)

```sh
# 一次性排程服務 atd
$ systemctl status atd.service
```

相關指令:

- `at`
- `atq` 或 `at -l`
- `atrm`


```sh
### 查看 at queue
$ atq

##### 法一: 互動式排排程 : 1分鐘之後, 把「hi」丟到檔案, 排程優先等級: g
$ at -p g now +1min
at> echo 'hi' > q.txt
at> <EOT>                           # Ctrl+D 結束
job 7 at Sat Sep  1 19:02:00 2018   # 工作執行時間

##### 法二: 排排程
$ echo "date > a.txt" | at now +2min
job 13 at Sat Sep  1 19:16:00 2018

### 查看 at 排程的 Queue
$ atq
7       Sat Sep  1 19:02:00 2018 g tony
13      Sat Sep  1 19:16:00 2018 a tony
# Job Number : 7
# DateTime Scheduled : Sat Sep  1 19:02:00 2018
# Job Priority : g
# Job Owner : tony

### 查看工作
$ at -c 13
# PASS...((37行, 前面 30 行不用理他))...
${SHELL:-/bin/sh} << 'marcinDELIMITER2b8a1e54'
date > a.txt

marcinDELIMITER2b8a1e54

### 移除 Job Number = 7 的 一次性排程工作
$ atrm 7
```



# user cron - 使用 `crontab`

相關指令:
- `contab -l` : 列出目前 user 的 jobs
- `contab -r` : 刪除目前 user 的 jobs
- `contab -e` : 編輯目前 user 的 jobs
- `contab <filename>` : 我... 不太想鳥它(好啦 我不會)

分為 6 欄: `Minutes` `Hours` `Day-of-Month` `Month` `Day-of-Week` `Command`

```sh
分      時      日      月     星期幾(週日為 0 or 7 都可)
30      9       15      8       *       # 每年 8/15 09:30
0       17      10      *       *       # 每月10日, 17:00
15      9-16    *       *       3       # 每周三 09:15, 10:15, ..., 16:15
0       */1     *       *       *       # 每小時
*       *       13      *       5       # 每週五 or 每月13日 都執行 (無法直接由此設定 每月13日週五)
*       *       */21    *       *       # 每月 1, 22 日都執行
*/7     *       *       *       *       # 每7分鐘, 但是會在 7, 14, ..., 49, 56, 0 分執行(跨時不計算)
```


### 範例: 快照每兩分鐘的記憶體狀況(記憶體用量, 記憶體使用狀況)

```bash
### Step1 - 腳本
$# vim $HOME/memory_script
# --------------------------------
#!/bin/bash
aa=$(date +%H:%M:%S)
bb=$(free -m | head -2 | tail -1 | awk '{print $2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}')
echo -e "$aa\t$bb" >> $HOME/memory_record
# --------------------------------

### Step2 - chmod
$# chmod a+x $HOME/memory_script
$# touch $HOME/memory_record

### Step3 - 掛排程
$# crontab -e
# --------------------------------
*/1 * * * * $HOME/memory_script
# --------------------------------

### Step4 - 追蹤 (要等一分鐘=.=")
$# tail -f $HOME/memory_record
```



# System cron 系統排程

```sh
# 週期性排程服務 crond
$# systemctl status crond.service
```

系統排程服務 `crond`, **每分鐘** 會檢查 `/etc/crontab`, 並在適當時機執行檔案內指令的排程工作

```sh
$# ls -l /etc/crontab
-rw-r--r--. 1 root root 450  8月 29 21:15 /etc/crontab

$# vim /etc/crontab

# 每周日 00:00 執行 資料庫備份
* * * * 0 root mysqldump -u'root' -p'root_password' tt > /root/test_crontab/bck_`date +\%m\%d\%H\%M`.sql
```

分為 7 欄: Minutes Hours Day-of-Month Month Day-of-Week `User-Name` Command

**cron** jobs 拆分到 2 個地方: `/etc/crontab` 及 `/etc/cron.d/*`

```sh
# 管理 定期排程 的放置位置
/etc/crontab                        # [cron]
/etc/cron.d/*                       # [cron]

# 每小時排程
/etc/cron.d/0hourly                 # [script]
# ↓ 每小時
/etc/cron.hourly                    # [cron]

# 定期排程
/etc/anacrontab                     # [script]
# ↓ 每天, 每週, 每月
/etc/cron.{daily,weekly,monthly}    # [cron]
# ↓ 把當時的 yyyymmdd 作 UPDATE
/var/spool/anacron/cron.{daily,weekly,monthly}

# 驅動 每天, 每週, 每月 執行的重要腳本
/etc/anacontab
    + RHEL6 : 由 anacron 管理
    + RHEL7 : 由 crond 管理
```
