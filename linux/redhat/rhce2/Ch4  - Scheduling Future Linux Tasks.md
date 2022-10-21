# Ch4  - Scheduling Future Linux Tasks

1. Future Task
2. 一次性工作 at
3. 例行性工作 cron
4. 備註

## 1. Future Task

* **`atd`** `daemon` 一次性
* **`crond`** `daemon` 定期


## 2. 一次性工作 at

* atd 提供了 a~z 緊急程度(26種等級):
    - a: Nice Value 最低, (對系統非常不友善), 緊急程度最大, 搶資源搶最兇
    - z: Nice Value 最高, (對系統最友善), 優先程度最低

### 2-1 指令

- `at [TIMESPEC]` : 可進入 REPL 介面, 開始建立一次性排程工作(建立完後使用 `Ctrl+d` 離開)
- `atq` 或 `at -l` : 查詢目前的 at Queue 積了哪些工作
- `at -c <JOBNUMBER>` : 查詢 JobNumber 要執行什麼東西
- `atrm <JOBNUMBER>` : 移除 JobNumber 的工作


### 2-2 範例

```sh
### user

# 10分鐘後, 把目前的日期, 丟到家目錄的 111 檔案
$ echo "date > ~/111" | at now +10min
job 17 at Sun Oct 21 14:45:00 2018

# 「at -q g」建立 優先等級=g 的一次性排程工作
# at 20分鐘後
$ at -q g now +20min
at> touch $HOME/222
at> <EOT>                           # 排程設定完後, Ctrl + D 存檔離開
job 18 at Sun Oct 21 14:55:00 2018

# at 明天 17:00
$ at -q b 17:00 tomorrow
at> touch $HOME/333         # 排程設定完後, Ctrl + D 存檔離開
at> <EOT>                           # 排程設定完後, Ctrl + D 存檔離開

# 觀看 at 排程
$ atq
17      Sun Oct 21 14:45:00 2018 a tony
18      Sun Oct 21 14:55:00 2018 g tony
19      Mon Oct 22 17:00:00 2018 b tony
#A          B                    C  D
# A: Job Number
# B: TIMESPEC(何時執行)
# C: 等級
# D: 執行者

# 查看一次性排程細節
$ at -c 18          # 剛剛顯示的 JobNumber
# 會出現一大堆...

# 刪除剛剛還沒被執行的一次性排程
$ atrm 17 18 19
```


### 2-3 TIMESPEC

- now + 30min
- teatime tomorrow (teatime為 16:00)
- noon +2 days
- 5pm april 28 2018
- 詳: `/usr/share/doc/at-3.1.13/timespec`


## 3. 例行性工作 cron

### 3-1. 排程服務

「警察每小時都需要到巡邏箱簽名」這件事情, 假如 09:00, 10:00 都有簽名了, 但是 11:00 卻因為路上塞車, 來到巡邏箱的時候已經 11:45 了, 那麼是否應該 先於 11:45 簽名, 然後 12:00 再來簽名? (這不是廢話嗎!)

------------------------------------------------------------------------------

`定期排程` 分為 下列 2 種:

##### 3-1-1. 使用者排程(所有user都可以用)

- 使用 `crontab` 指令工具, 該指令工具位於 `/usr/bin/crontab`
- 寫完後東西會放在 `/var/spool/cron/tony`
- 有支名為 `crond` 的服務會每分鐘去 scan 排程定義檔, 並在適當的時機執行

```sh
### tony (包含 root 也可以使用此指令)
$ crontab -e        # 直接進入排程定義檔進行撰寫

$ crontab -l        # 列出目前使用者的排程工作

$ crontab -r        # (※慎用!) 移除目前使用者「所有排程工作」
```


##### 3-1-2. 系統排程(只有root能用)

- 直接編輯 `系統排程定義檔`
- 有支名為 `crond` 的服務會每分鐘去 scan 排程定義檔, 並在適當的時機執行

`系統排程定義檔` 撰寫方式, 又可分為下面幾種:

1. 把排程工作寫在 `/etc/crontab`
2. 把排程工作寫在 `/etc/cron.d/xxx`
3. 把排程工作腳本寫在 `/etc/cron.hourly/xxx`
4. 把排程工作腳本寫在 `/etc/cron.daily/xxx`
5. 把排程工作腳本寫在 `/etc/cron.weekly/xxx`
6. 把排程工作腳本寫在 `/etc/cron.monthly/xxx`


### 3-2 排程怎麼寫

```sh
# 使用者排程的欄位 (crontab -e)
minute      hour    day_of_month    month   day_of_week                 command

# 系統排程的欄位 (vim/etc/crontab 或 vim /etc/cron.d/xxx)
minute      hour    day_of_month    month   day_of_week     user-name   command
```


### 3-3. 範例

```sh
crontab -l
22      1       2       *       *       /opt/monthly_backup     # 每月2號, 01:22
*/13    9-18    *       Sep     3       /opt/daily_exec         # 9月每週三, 9-18點, 每隔13分鐘
22      23      *       *       6-7     /opt/weekly_scan        # 每週六日, 23:22
0       9       *       *       1-5     /opt/inform             # 每週一~五, 09:00
0       *       *       *       *       /opt/hourly_job         # 每小時執行
*/1     *       *       *       *       /opt/always_run_me      # 每分鐘
0       8       *       *       *       /opt/everyday_0800      # 每天 08:00

# */13 並非真正的每13分鐘, 而是 9:13, 9:26, 9:39, 9:52, 10:00, 10:13, ...
```


### 3-4. anacrontab

```sh
$# cat /etc/anacrontab
# /etc/anacrontab: configuration file for anacron

# See anacron(8) and anacrontab(5) for details.

SHELL=/bin/sh
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
# the maximal random delay added to the base delay of the jobs
RANDOM_DELAY=45
# the jobs will be started during the following hours only
START_HOURS_RANGE=3-22

#period in days   delay in minutes   job-identifier   command
1       5       cron.daily              nice run-parts /etc/cron.daily
7       25      cron.weekly             nice run-parts /etc/cron.weekly
@monthly 45     cron.monthly            nice run-parts /etc/cron.monthly
```


## 4. 備註

查看 `/rhce2/attach/SchedulingTasks.xml`
