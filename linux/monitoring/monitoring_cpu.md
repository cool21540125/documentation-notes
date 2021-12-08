
- mpstat


### mpstat - Multiprocessor Statistics

監控 CPU 的工具, 會去檢視 `/proc/stat` 裡面的資訊


#### Summary

```bash
### Install
$# yum install -y sysstat

### Version
$# mpstat -V
10.1.5

### Help
$# mpstat -h
Usage: mpstat [ options ] [ <interval> [ <count> ] ]
Options are:
[ -A ] [ -u ] [ -V ] [ -I { SUM | CPU | SCPU | ALL } ]
[ -P { <cpu> [,...] | ON | ALL } ]
```


#### Usage

```bash
### 顯示 avg(CPU Core) 使用狀況
$# mpstat
Linux 5.7.4-1.el7.elrepo.x86_64 (IE-L-EGI-ops) 	05/19/2021 	_x86_64_	(8 CPU)

05:12:33 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
05:12:33 PM  all    1.95    0.00    0.43    0.00    0.00    0.04    0.00    0.00    0.00   97.57
# CPU 的平均狀況~~~ (如果某耗能程式, 只能跑在單核心, 這個監控結果根本沒鳥用)


### 顯示 each(CPU Core) 使用狀況
$# mpstat -P ALL
Linux 4.19.128-microsoft-standard (IR-TONY-OPS)         09/11/21        _x86_64_        (8 CPU)

15:37:20     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
15:37:20     all    0.04    0.00    0.10    0.00    0.00    0.00    0.00    0.00    0.00   99.86
15:37:20       0    0.04    0.00    0.12    0.00    0.00    0.01    0.00    0.00    0.00   99.83
15:37:20       1    0.03    0.00    0.08    0.00    0.00    0.00    0.00    0.00    0.00   99.89
15:37:20       2    0.04    0.00    0.14    0.00    0.00    0.00    0.00    0.00    0.00   99.81
15:37:20       3    0.03    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.00   99.90
15:37:20       4    0.04    0.00    0.15    0.00    0.00    0.00    0.00    0.00    0.00   99.81
15:37:20       5    0.03    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.00   99.91
15:37:20       6    0.04    0.00    0.16    0.00    0.00    0.00    0.00    0.00    0.00   99.80
15:37:20       7    0.03    0.00    0.06    0.00    0.00    0.00    0.00    0.00    0.00   99.91
# 看吧, 所以現在的電腦 CPU 根本都在浪費                                                       ↑↑↑↑↑

### 即時排查使用. 讓畫面 hang 住, 每隔 5 秒顯示一次, 總共顯示 2 次
$# mpstat -P ALL 5 2
# 輸出結果太佔空間, 不列出
```

#### Detail

當 `mpstat` 沒有搭配參數的時候, 呈現的是 **自系統開機到現在, 平均的狀況**.

欄位解說

- %usr    : 
- %nice   : 
- %sys    : 
- %iowait : 
- %irq    : 
- %soft   : 
- %steal  : 
- %guest  : 
- %gnice  : 
- %idle   : 