# 程序管理

任何程式(放在 disk 上), 只要一被執行, 就會變成 程序(process) (放在 RAM 裡面)

而任何的程序, 都會有它專屬的 Process ID (PID)

而所有的 PID, 都是由它的 `父程序 PPID` 來作觸發

ex: 使用者登入後, 取得的就是個 bash 這個工作環境, 這也是個程序, 下任何指令的話, 這些指令的 PPID 都是 使用者當前存在的這個 bash

↑ 這些都是在 Terminal 的前景處理

- 任何程序, 都可在指令的最後面, 加上 `&`, 讓它在背景執行 (Running)
- 前景程序, 可用 `Ctrl + z` 把它 `丟到背景 && 暫停作業` (Running → Stopped)
- 已被暫停的背景程序, 可用 `bg %{JOB NUMBER}` 來讓它在 背景執行 (Stopped → Running)
- 背景程序, 可用 `fg {JOB NUMBER}` 把它取回前景來處理
- 可用 `jobs` 來列出 **背景工作的狀態**
        - jobs -l : 除了列出 job number, 也會列出 PID
        - jobs -r : 只列出 Running
        - jobs -s : 只列出 Stopped
- 可使用 `kill` 來移除 **背景工作**

上面所說的 **bash 的背景**(會隨著 Terminal 關掉而結束(因為是他們的 PPID 阿)), 如果要把工作丟到 **系統背景**, 可使用 `nohup`

系統背景, 就像是 `crontab` 與 `at`

除了 `nohup` 以外, 也可參考 `screen` 的使用方式


## ps option format

1. UNIX(POSIX) options : 「-」開頭
2. BSD options         : 不可為「-」開頭
3. GUN long options    : 「--」開頭

```sh
$ ps aux        # u : 看到 user name
$ ps alx        # l : 列出更詳細的 PID 資訊
$ ps afx

$ pstree -p
# -p: 顯示 PIDs

$ ps au --sort=...      # 指定排序欄位

# 只能查閱自己的 bash程序 -----------------------------------------
$# ps -l
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
4 S     0 26778 26743  0  80   0 - 60341 poll_s pts/1    00:00:00 sudo
4 S     0 26780 26778  0  80   0 - 28984 do_wai pts/1    00:00:00 bash
0 R     0 27948 26780  0  80   0 - 38331 -      pts/1    00:00:00 ps
# F: pass
# S:
#    R: Running
#    S: Sleep, idle 狀態, 可被喚醒
#    D: 不可被喚醒的 idle 狀態, ex: 等候列印
#    T: Stop. ex: 背景暫停, debug traced 狀態
#    Z: Zombie, Process 已經掛了, 但依舊卡在 Memory
# UID: Process 的擁有者
# PID: Process ID
# PPID: Process Parent ID
# C: CPU 使用率(%)
# PRI: Priority
# NI: Nice
# ADDR: 如果是 Running, 一般都是 「-」(Memory related)
# SZ: 此 Process 用掉多少 memory (Memory related)
# WCHAN: 若為運作中, 一般都是 「-」(Memory related)
# TTY: 終端介面
# TIME: 此 Process 用掉 system 多少時間
# CMD: 

$#
# --------------------------------------------------------------

# 查閱所有系統運作的程序
$# ps aux
# a: 所有 user
# u: user name 欄位
# l: UID 欄位
# x: 背景程序(會有超多)
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.5 193524  5512 ?        Ss    1月13   0:06 /usr/lib/systemd/syst
......
# USER: Process owner
# %MEM: Process 所佔用的實體記憶體%
# VSZ: Process 使用掉的 虛擬記憶體
# RSS: Process 佔用的 固定記憶體
# TTY: Proce3ss 所在 Terminal. 若為 pts/0 等等, 則為網路連線來的
# STAT: 程序的狀態, 有 R/S/T/Z

$#
```

Zombie

```sh
$# ps aux
xxx xxx  xxxxxx  ..... xxx <defunct>
# 如果 ps 後看到了上面的 defunct, 表示此為 Zombie Process 
```


## - 行程狀態 相關指令
```sh
# 僅列出與自己相關的bash相關程序
$ ps
  PID TTY          TIME CMD
 9342 pts/2    00:00:00 bash
11937 pts/2    00:00:00 ps

# 詳細資訊
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
tony     24634 24626  0 13:58 pts/0    00:00:00 bash
tony     32620 24634  0 20:58 pts/0    00:00:00 ps -f

# 更多詳細資訊
$ ps -l
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
0 S  1000  9342  7534  0  80   0 - 29176 wait   pts/2    00:00:00 bash
0 R  1000 11944  9342  0  80   0 - 37232 -      pts/2    00:00:00 ps
# PPID: Parent Process ID

# 列出系統運作的程序
$ ps aux | grep mysqld
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
tony       919  0.0  0.0 112668   964 pts/0    S+   21:36   0:00 grep --color=auto mysqld
mysql     2941  0.1  4.9 1248528 186788 ?      Sl    3月01   1:52 /usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid

# 樹狀結構列出 System Procss
$ pstree
systemd─┬─ModemManager───2*[{ModemManager}]
        ├─NetworkManager───2*[{NetworkManager}]
        ├─2*[abrt-watch-log]
        ├─abrtd
        ├─accounts-daemon───2*[{accounts-daemon}]
        ├─alsactl
        ...(略)

# 背景睡覺 60秒
$ sleep 60 &        # sleep 60 seconds
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
tony      1559 24634  0 21:59 pts/0    00:00:00 sleep 60
tony      1563 24634  0 21:59 pts/0    00:00:00 ps -f
tony     24634 24626  0 13:58 pts/0    00:00:00 bash

# 前景作業改背景作業, 使用 Ctrl+z中斷, 再用 bg指令, 將上一個被停止的行程放入背景中執行.
$ sleep 60
^Z
[1]+  Stopped                 sleep 60
$ bg
[1]+ sleep 60 &
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
tony      1713  1705  0 22:01 pts/2    00:00:00 bash
tony      1763  1713  0 22:01 pts/2    00:00:00 sleep 60
tony      1770  1713  0 22:02 pts/2    00:00:00 ps -f

# 將背景取回前景 fg
$ jobs
$ sleep 50 &
[1] 2138
$ sleep 40 &
[2] 2142
$ sleep 30 &
[3] 2146
$ jobs
[1]   Running                 sleep 50 &
[2]-  Running                 sleep 40 &
[3]+  Running                 sleep 30 &
$ fg 2          # 取出第二個背景行程
sleep 40
^C              # 中斷

# nice value NI value, 行程優先權(priority)
$ ps l
F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
0  1000  1959  1951  20   0 116568  3232 wait   Ss   pts/0      0:00 bash
0  1000  2198  1959  20   0 148936  1452 -      R+   pts/0      0:00 ps l
0  1000 24277 24261  20   0 116560  3224 n_tty_ Ss+  pts/1      0:00 /bin/bash
# NI為 [-20, 19], 越小越優先, 預設為 0
# R+ 為 正在執行佇列
# T  為 Stopped
```


## - top(類似Windows的工作管理員)
[使用 top](http://linux.vbird.org/linux_basic/0440processcontrol/0440processcontrol-fc4.php#top)

內容大致如下（上半部：Resource資訊,下半部：Process資訊)

<img src="../../img/top.jpg" style="width:480px; height:320px;" />

```sh
# 第一行
top - 14:53:56                                  目前時間
up 3:47                                         累積開機時間
load average: 0.84, 0.82, 0.70                  系統每 1, 5, 15分鐘平均執行的行程數
```

top後操作指令 | 說明
------------ | ------------------------
h            | Help
P            | 依據CPU使用時間排序
M            | 依據記憶體使用量排序
T            | 依據執行時間排序
N            | 依據PID大小排序
u            | 只列出該帳號的程序
k            | 刪除
d            | 更新秒數
q            | 離開


## jobs 工作管理 && fg
> jobs參數, `l: 顯示 PID`, `r: running process`, `s: stopped process`
> 預設, Ctrl+z後, 都會暫停此 process
```sh
$ vi ~/.bashrc        # Ctrl + z
[1]+  Stopped                 vi .bashrc

$ mysql -uroot -p     # Ctrl + z
[2]+  Stopped                 mysql -uroot -p

$ jobs -lrs
[1]- 19499 Stopped                 mysql -uroot -p  (wd: /home/tony)
[2]+ 19504 Stopped                 vi .bashrc

$ fg              # 可以回到上面有「+」的那個 process

$ fg %1           # 可以回到第1個 process
---
## 虛擬檔案
> `/proc`內的檔案, 都是虛擬檔案, 是系統讓使用者查看系統內部狀況的窗口

```sh
# 查看記憶體使用情形
$ cat /proc/meminfo

# 查看檔案分割資訊
$ cat /proc/partitions

# 查看 CPU資訊
$ cat /proc/cpuinfo
```



# Process Example

Terminal A
```sh
# 建立 TCP Socket 的 MongoDB process
$# systemctl stop mongod
$# mongod --dbpath /tmp/qq
```


Terminal B
```sh
$ ps au | grep mongod
USER   PID  %CPU  %MEM    VSZ    RSS  TTY     STAT START  TIME COMMAND
root  3547   0.4   1.7 1012544  67576  pts/1  SLl+ 20:16  0:04 mongod --dbpath /tmp/qq
# a : 所有User
# u : 增加顯示 Process Owner, Memory, CPU 等欄位資訊
```


## fuser

- 2019/07/19

`程序` 在啟動過程中 `開啟了多少檔案`.

如果卸載時, 看到 「device is busy」, 表示某個 PID 正在使用這個檔案系統, 可用 fuser 來追查

```bash
###
$# fuser [-umv] [-k [i] [-signal]] file/dir
# -u: 列出 PID owner
# -v: 列出 file 與 PID 及 指令的相關性
# -i: 刪除 PID 前, 會先詢問是否刪除 (需搭配 -k)
# -k: 列出使用這個 file/dir 的 PID, 並試圖以 SIGKILL 訊號給這個 PID (kill -9 啦)
# -signal: 例如「-2」, 「-15」. 預設是「-9」

# 因為鳥哥舉的範例, 看了沒啥感覺... 就不列範例了orz
```

## lsof

- 2019/07/19

`某個程序開啟 or 使用中` 的 `檔案`

```bash
###
$# lsof [-aUu] [+d]
# -a: 多項資料需要同時成立才列出
# -U: 僅列出 Unix-like socket
# -u <user>: 列出該使用者相關程序所開啟的檔案
# +d <dir name>: 該目錄下, 已經被開啟的檔案
```