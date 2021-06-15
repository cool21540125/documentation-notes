#!/bin/bash
# 監控 CPU 利用狀況
# https://www.cyberciti.biz/tips/how-do-i-find-out-linux-cpu-utilization.html
# 2021/05/19

# -------------------------------------

### top
top



### htop
htop



### ↓ Ubuntu 需要安裝 sysstat
### mpstat
mpstat
#Linux 5.7.4-1.el7.elrepo.x86_64 (IE-L-EGI-ops) 	05/19/2021 	_x86_64_	(8 CPU)
#
#05:12:33 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
#05:12:33 PM  all    1.95    0.00    0.43    0.00    0.00    0.04    0.00    0.00    0.00   97.57

### 可看每個 CPU 的利用狀況
mpstat -P ALL
#Linux 5.7.4-1.el7.elrepo.x86_64 (IE-L-EGI-ops) 	05/19/2021 	_x86_64_	(8 CPU)
#
#05:08:30 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
#05:08:30 PM  all    1.95    0.00    0.43    0.00    0.00    0.04    0.00    0.00    0.00   97.57
#05:08:30 PM    0    1.84    0.00    0.47    0.00    0.00    0.17    0.00    0.00    0.00   97.52
#05:08:30 PM    1    1.98    0.00    0.39    0.00    0.00    0.07    0.00    0.00    0.00   97.56
#05:08:30 PM    2    1.85    0.00    0.47    0.00    0.00    0.03    0.00    0.00    0.00   97.65
#05:08:30 PM    3    2.08    0.00    0.42    0.00    0.00    0.02    0.00    0.00    0.00   97.48
#05:08:30 PM    4    2.01    0.00    0.42    0.00    0.00    0.02    0.00    0.00    0.00   97.55
#05:08:30 PM    5    1.88    0.00    0.46    0.00    0.00    0.02    0.00    0.00    0.00   97.64
#05:08:30 PM    6    1.97    0.00    0.39    0.00    0.00    0.02    0.00    0.00    0.00   97.62
#05:08:30 PM    7    2.01    0.00    0.40    0.00    0.00    0.02    0.00    0.00    0.00   97.58



### sar 可看今天的 CPU 利用率
sar
#Linux 5.7.4-1.el7.elrepo.x86_64 (IE-L-EGI-ops) 	05/19/2021 	_x86_64_	(8 CPU)
#
#12:00:01 AM     CPU     %user     %nice   %system   %iowait    %steal     %idle
#12:10:01 AM     all      1.87      0.00      0.38      0.00      0.00     97.74
#12:20:01 AM     all      1.86      0.00      0.37      0.00      0.00     97.76
# .......... 省略中間部分 .............
#04:50:01 PM     all      1.87      0.00      0.40      0.00      0.00     97.73
#05:00:01 PM     all      1.93      0.00      0.40      0.00      0.00     97.66
#05:10:01 PM     all      1.94      0.00      0.44      0.00      0.00     97.62
#Average:        all      1.89      0.00      0.39      0.00      0.00     97.72



### 使用 sar 監控 CPU 每隔 2 秒鐘的狀況, 並監控 5 次
sar -u 2 5

# 使用 nohub 搭配 sar 做監控, 執行後可登出
nohup sar -o sar_output 2 5 >/dev/null 2>&1 &
# ↑ 產出的 sar_output 為 binary. 需使用 ↓ 來查看
sar -f sar_output



### 可查出目前襲斷 CPU 的元兇
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10


### iostat 來查看 自前次開機到現在, CPU 統計資訊 & I/O 統計
iostat



### vmstat 可查看 processes, memory, paging, block IO, traps, disks, cpu activity
vmstat