系統監控相關 CLI

- [iostat 監控 I/O](https://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/iostat.html)
- [How Do I Find Out Linux CPU Utilization?](https://www.cyberciti.biz/tips/how-do-i-find-out-linux-cpu-utilization.html)

---

# sar

```bash
### 可查看 特定期間(default 今天) 每隔一段時間(default 10分鐘) 的 CPU 利用率, 並全部列出
$# sar
Linux 5.7.4-1.el7.elrepo.x86_64 (hostname-ops) 	05/19/2021 	_x86_64_	(8 CPU)

12:00:01 AM     CPU     %user     %nice   %system   %iowait    %steal     %idle
12:10:01 AM     all      1.87      0.00      0.38      0.00      0.00     97.74
12:20:01 AM     all      1.86      0.00      0.37      0.00      0.00     97.76
 .......... 省略中間部分 .............
04:50:01 PM     all      1.87      0.00      0.40      0.00      0.00     97.73
05:00:01 PM     all      1.93      0.00      0.40      0.00      0.00     97.66
05:10:01 PM     all      1.94      0.00      0.44      0.00      0.00     97.62
Average:        all      1.89      0.00      0.39      0.00      0.00     97.72


### 使用 sar 監控 CPU 每隔 2 秒鐘的狀況, 並監控 5 次
$# sar -u 2 5


# 使用 nohub 搭配 sar 做監控, 執行後可登出
$# nohup sar -o sar_output 2 5 >/dev/null 2>&1 &
# ↑ 產出的 sar_output 為 binary. 需使用 ↓ 來查看
$# sar -f sar_output
```

# ps

```bash
### 可查出哪個 process 正在 monopolizing or eating CPU
$# ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10
%CPU   PID USER     COMMAND
 0.1 25750 root     php /usr/local/bin/swoftcli ...(中間略)... -b bin/swoft /var/www/html
 0.1 25544 root     /usr/local/bin/redis-server 0.0.0.0:6379
 0.0     9 root     [ksoftirqd/0]
 0.0   908 root     /usr/sbin/crond -n
 0.0   907 root     /usr/sbin/atd -f
 0.0     8 root     [mm_percpu_wq]
 0.0   891 root     /usr/sbin/NetworkManager --no-daemon
 0.0   865 chrony   /usr/sbin/chronyd
 0.0   863 rpc      /sbin/rpcbind -w
```

# iostat

```bash
### 查看 自前次開機到現在, (CPU 統計資訊) && (devices & partitions 的 I/O 統計)
$# iostat
Linux 5.4.138-1.el7.elrepo.x86_64 (hostname-nginx01) 	08/06/2021 	_x86_64_	(8 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.11    0.00    0.08    0.03    0.00   99.78

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda               1.29         6.79        72.49     657190    7015744
dm-0              1.75         6.16        51.69     596536    5003108
dm-1              0.00         0.03         0.00       3236          0
dm-2              0.74         0.21        22.47      20185    2174792
# --------------------------------------------------------------------------------------------
#
# %user : CPU user mode 的時間占比.
# %nice : CPU 處在 「帶 NICE 值的 user mode」的時間占比.
# %system : CPU system mode 的時間占比.
# %iowait : CPU 再等待 I/O 的時間占比.
# %steal : (VM 中才會出現) 管理程序於虛擬機中, 等候 CPU 的時間占比.
# %idle : CPU 空閒時間占比. 若過高但回應速度慢, 可能是 cpu 等待分配內存. 若長期過低, 表示 cpu 可能成為瓶頸

# tps : 設備每秒的 傳輸次數(I/O 請求次數). 多次的邏輯請求可能被合併為 一次 I/O 請求. 而每次大小未知
# kB_read/s : 每秒從設備讀取的資料量
# kB_wrtn/s : 每秒向設備寫入的資料量
# kB_read : 讀取自設備的資料總量
# kB_wrtn : 寫入到設備的資料總量


### 每隔 3 秒鐘列出 iostat 資訊, 重複 20 次
$# iostat -xtc 3 20
# -x : 顯示額外的統計資訊
# -t : 印出時間
# -c : 列出 CPU 利用率的資訊
# -k : 使用 kb/sec 的方式呈現
# -m : 使用 mb/sec 的方式呈現
```

# vmstat

```bash
### vmstat 可查看 processes, memory, paging, block IO, traps, disks, cpu activity
$# vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0      0 3023704   5236 3368340    0    0     1     9   37   39  0  0 100  0  0
#
# --- system ---
#     in : interrupts 次數(含 clock) / sec
#     cs : context switches 次數 / sec
# --- cpu --- (加總起來為 100%)
#     us : non-kernel code 耗費的時間(包含 user time, nice time)
#     sy : kernel code 耗費的時間(也就是 system time)
#     id : Time spent idle
#     wa : 等候 I/O 的時間    (Kernel < 2.5.41, 沒有 wa 這東西, 納入在 id 裡面)
#     st : Time stolen from a virtual machine.


### 每隔 2 秒執行一次 vmstat, 並重複 600 次 (每隔 2 秒的區間, 追蹤 20 分鐘)
$# vmstat -t -S M 2 600
# -t   : 列出 time
# -S M : MiB 為單位
```
