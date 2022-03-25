# Ch7 - Monitoring and Managing Linux Processes

1. Process 概念
2. Job control
3. Killing Process
4. top


## 1. Process 概念

Process vs Program 差異

- program: 就... 純文字檔的程式檔
- process: 執行中的 program

瀏覽器查詢 draw.io, 開啟 `rhce1/attach/Process.xml`


### 程序會牽涉的議題

- 資源耗用
- 權限
- 狀態 (依情境改變)

```sh
# 查看 使用者相關的所有程序
$ ps aux | head -n 8
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 193784  6872 ?        Ss    9月27   0:31 /usr/lib/systemd/systemd --switched-root --system --deserialize 22
root         2  0.0  0.0      0     0 ?        S     9月27   0:00 [kthreadd]
root         3  0.0  0.0      0     0 ?        S     9月27   0:01 [ksoftirqd/0]
root         5  0.0  0.0      0     0 ?        S<    9月27   0:00 [kworker/0:0H]
root         7  0.0  0.0      0     0 ?        S     9月27   0:54 [migration/0]
root         8  0.0  0.0      0     0 ?        S     9月27   0:00 [rcu_bh]
root         9  0.0  0.0      0     0 ?        S     9月27   0:35 [rcu_sched]
# [] 起來的程序為 kernel threads 排程
```


## 2. Job control

名詞解釋: 

- Job control : 讓使用者可以使用一個 Console 同時做很多事情. ex: 讓他們背景執行...
- foreground process : 前景程序
- background process : 背景程序
- process session : 程序會話(看得懂我頭給你)

範例:

```sh
# w指令: 顯示 目前誰登入 && 在做些什麼
$ w -h
tony     pts/0    192.168.124.101  17:59    2.00s  0.07s  0.00s w -h
tony     :0       :0               Thu11   ?xdm?   1:20m  0.52s /usr/libexec/gnome-session-binary --session gnome-classic

# 建立 && 執行 一個程序(沒名字), 讓他睡 59487 秒, &:背景執行
$ sleep 59487 &
[1] 8707
# 回傳 [1] 8707 為 [第幾個job] job number

# 建立另一個 job...
$ sleep 88888 &
[2] 10746

# 查看目前所有 jobs
$ jobs
[1]-  Running                 sleep 59487 &
[2]+  Running                 sleep 88888 &
# 「+」是指 Current job... (不是很重要)
# 代表現在有 2 個 jobs 在執行, 且都是 背景執行(&)

# 呼喚第1支背景程序, 把他叫到前景執行
$ fg %1
sleep 59487     # Terminal會卡住(依然在執行喔!!)
^Z              # 按「Ctrl+z」會把它"suspend"; tag 為 T
[1]+  Stopped                 sleep 59487

# 此時發現, 第一個 job 已經 Stopped 了(因為剛剛你把它 suspends 了)
$ jobs
[1]+  Stopped                 sleep 59487
[2]-  Running                 sleep 88888 &

# 把 第一支 job 丟到背景執行 ; 或者, 丟到前景執行則為「bg %1」(然後Terminal再被卡住XD )
$ bg %1
[1]+ sleep 59487 &

# ps j 可以看到「程序之間是怎麼鳩葛在一起的」
$ ps j
 PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
 4913  4918  4918  4918 pts/0    27945 Ss    1000   0:00 -bash
 4918  8707  8707  4918 pts/0    27945 S     1000   0:00 sleep 59487
 4918 10746 10746  4918 pts/0    27945 S     1000   0:00 sleep 88888
 4918 27945 27945  4918 pts/0    27945 R+    1000   0:00 ps j

#「Ctrl+z」時, 開始 Sleeping
# 「bg %1」時, 丟訊號給他, 讓它恢復成 Running(但事實上, 程式是叫他sleep 59487, 所以依然為 S)
```

### 練習範例

開兩個 Terminal

```sh
### T1
$ (while true; do echo -n "rock " >> ~/rocking.txt; sleep 1; done)
# 每秒鐘寫入檔案
```

```sh
### T2
$ tail -f ~/rocking.txt
# 讓 Terminal 追蹤 rocking.txt 的動態狀況
# Terminal 會 block 住...
```

```sh
### T1
$   # 「Ctrl+z」
# 發現 job 被 suspended 了! 所以 T2 也沒在動了

# 查看目前已有的 job
$ jobs
[1]+ stopped        ...(程式)...
# 可以看到 job 1 已經被 stopped 了

# 把剛剛的工作再次丟到 背景執行
$ bg
# 然後又開始 rocking 了... 看 T2
# Ctrl+z

# 再丟背景程式下去執行, 看 T2
$ (while true; do echo -n "XXXX " >> ~/rocking.txt; sleep 1; done) &
$ (while true; do echo -n "3Q3Q " >> ~/rocking.txt; sleep 1; done) &

# 可以看到目前有 3 個 jobs 在執行
$ jobs

$ fg    # 再按 Ctrl + c
# 想 暫停 的話, 其中一種方法, 就是把他們從 bg 拉到 fg, 再 Ctrl+z    暫停程式
# 想 結束 的話, 其中一種方法, 就是把他們從 bg 拉到 fg, 再 Ctrl+c    中斷程式

$ fg    # Ctrl + c
$ fg    # Ctrl + c
```

```sh
### T2
# Ctrl + c
$ rm ~/rocking.txt
```


## 3. Killing Process

可以傳遞各種 `信號signal` 給 程序

Signal Number | Signal Name | Definition
------------- | ----------- | ----------
2             | SIGINT      | Keyboard interrupt (Ctrl + c 前景停止)
9             | SIGKILL     | Kill, unblockable ; 立即終止
15 (default)  | SIGTERM     | Terminate
18            | SIGCONT     | Continue
19            | SIGSTOP     | Stop, unblockable ; suspended (暫停)


###### Signal Number 會因 Linux hardware platform 而異


### kill, killall, pkill 發送信號

```sh
# 可以看到所有的 Signal Number
$ kill -l
# 60多種信號...
```

* 送信號給 `一個 程序` : `kill -signal PID`
* 送信號給 `一或多個 命令` : `killall -signal command_pattern`
* 送信號給 `一或多個 使用者的程序` : `killall -signal -u username command_pattern`
* 發送信號的進階操作, 則使用 `pkill` (不解釋了)
    * `pkill -signal command_pattern`
    * `pkill -G GID command_pattern`
    * `pkill -P PPID command_pattern`
    * `pkill -t terminal_name -U UID command_pattern`


```sh
### 應用案例: 可以掛固定時間排程, 讓系統把閒置太久的 Login Session 砍掉
$ w
 23:24:33 up 2 days, 13:42,  3 users,  load average: 0.51, 0.66, 0.75
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
tony     pts/0    192.168.124.101  22:16    1.00s  0.19s  0.02s w
tony     :0       :0               四11   ?xdm?  10:09m  1.68s /usr/libexec/gnome-session-binary --session gnome-classic
tony     pts/1    192.168.124.101  22:31   11:53   0.10s  0.10s -bash
# 可把 IDLE 太久的 Terminal 砍掉
# 或把 太耗資源的 Terminal 砍掉... (JCPU)
```

其餘指另還有...

* 列出所有與 user 相關的程序ID `pgrep -l -u user`
* `pstree -p PID`
* `pstree -P Parent PID`


## 4.top

```ps
# 我的電腦是 4 核心
$ grep "model name" /proc/cpuinfo
model name      : Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz
model name      : Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz
model name      : Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz
model name      : Intel(R) Core(TM) i5-7200U CPU @ 2.50GHz

# 查看片段 CPU 負載的指令
$ uptime
 23:49:46 up 2 days, 14:07,  3 users,  load average: 2.76, 2.81, 2.23
#                                               最近   1     5    15  分鐘的 CPU 負載狀況

# 動態監控
$ top
# 跑出一堆東西, 懶得解釋了...
# 其中一個重點就是, 第一行最後面的 load average 的 3 個值
# 個別 除以 CPU 數量後, 如果 > 1, 通常表示系統可能要有麻煩了...(CPU太操了啦~ 操!!)
```
