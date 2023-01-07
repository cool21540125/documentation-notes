
# 維運上的疑難雜症排查


## Memory Management for TCP

- https://cromwell-intl.com/open-source/performance-tuning/tcp.html
- 2023/01/05 (沒有很認真閱讀...)

關於 TCP 的 Kernel parameters, 可在下列檔案裡頭看到(v4, v6 皆適用):

- `/proc/sys/net/core/[rw]mem*`
- `/proc/sys/net/ipv4/tcp*`

像是 `dmesg`, 看到下面資訊

    TCP: out of memory -- consider tuning tcp_mem

表示: **TCP stack 已把 kernel 安排的 memory page 耗盡** OR **系統上有太多的 orphaned/open sockets**



```bash
### 
# how many kernel pages can be allocated to TCP stack
$# grep . /proc/sys/net/ipv4/tcp*mem
/proc/sys/net/ipv4/tcp_rmem:4096        131072  6291456
/proc/sys/net/ipv4/tcp_wmem:4096        16384   4194304
# 參數分別代表: minimum  default  maximum

### 
$# 
```
