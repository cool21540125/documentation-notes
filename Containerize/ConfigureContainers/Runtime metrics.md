# [Runtime metrics](https://docs.docker.com/config/containers/runmetrics/)
- 2021/03/05


## Docker stats

使用 `docker stats` 監控 Containers `CPU, memory usage, memory limit, network IO metrics` 的即時串流指標 

![docker stats](../img/docker-stats.png)


## Control groups

Linux Containers 依賴底層的 *CGroup*, 這些 *CGroup* 揭露了 `processes`, `CPU, memory, block I/O usage` 的 metrics

> This is relevant for `pure` LXC containers, as well as for Docker containers.
^ 三小...

- *CGroup* 透過 `pseudo-filesystem` 的形式來現身
    - 舊系統可能掛載在 `/cgroup`, 無明顯的結構層次. 裡頭有點雜亂, 甚至還有 running container
    - 較近代的系統東西基本上放在 `/sys/fs/cgroup`, 底下的資料夾, 對應於不同的 *CGroup* 結構層次

```bash
### 系統上的 *CGroups* 究竟掛載在哪裡
$# grep cgroup /proc/mounts
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpu,cpuacct 0 0
# 以上來自 ec2 免費的 VM.... (僅節錄部分)
```

### Enumerate cgroups

若藉由 `grep cgroup /proc/mounts` 查詢的結果有看到 `/sys/fs/cgroup/cgroup.controllers`(有無 `/sys/fs/cgroup/` 這個資料夾), 表示使用的是 `CGroup v2`, 否則為 `CGroup v1`

↑ 這個是 docker 官網寫的, 但查其它地方的答案好像有些不同Orz

```bash
# 如果只看到2行, 表示系統支援 v2
grep cgroup /proc/filesystems
#nodev cgroup
#nodev cgroup2
# 如果只看到第一行, 表示為 v1
```

NOTE: aws 免費的 EC2 看起來是 v2, 但是以現在電腦環境來說, 得做些升級才能讓 Docker 使用 CGroup v2...

---------------------------------

#### CGROUP V1

```bash
### 查看 OS 已知的 CGroup subsystems
$# cat /proc/cgroups
#subsys_name    hierarchy   num_cgroups enabled
cpuset  9   5   1
cpu 4   68  1
cpuacct 4   68  1
blkio   7   68  1
memory  3   106 1
devices 10  68  1
freezer 2   5   1
net_cls 8   5   1
perf_event  5   5   1
net_prio    8   5   1
hugetlb 11  5   1
pids    6   68  1

### 可查看 /proc/<PID>/cgroup, 來得知 Process 屬於哪些 CGroups
$# cat /proc/1/cgroup 
11:hugetlb:/
10:devices:/
9:cpuset:/
8:net_cls,net_prio:/
7:blkio:/
6:pids:/
5:perf_event:/
4:cpu,cpuacct:/
3:memory:/
2:freezer:/
1:name=systemd:/
# CGroup 用相對於 / 的相對路徑來呈現他們的 mountpoint
# 若為 /, 表示這個 Process 並不屬於任何 group
# ex: /lxc/pumpkin 則可看出, 這個 Process 是名為 pumpkin 的 Container 的成員之一
```

#### CGROUP V2

`/proc/cgroups` 沒有意義. 取而代之應去查看 `/sys/fs/cgroup/`


### Changing cgroup version

這邊引導如何把 OS 由 *CGroup v1* -> *CGroup v2*

遇到再說

### Running Docker on cgroup v2

由 *Docker 20.10* 開始實驗性的支援 v2. 有底下版本的基本要求:

- containerd: v1.4+
- runc: v1.0.0-rc91+
- Kernel: v4.15+ (但建議 v5.2+)

其餘細節遇到再說


### Find the cgroup for a given container

看不懂這章節在說啥...


### Metrics from cgroups: memory, CPU, block I/O

NOTE: 在閱讀文件的今天, 這部分依舊在講的是 Docker using CGroup v1

對於每個 subsystem (memory, CPU, block I/O), 存在了 一或多個 pseudo-files, 並包含了統計資訊


#### Memory metrics: `MEMORY.STAT`

- 相較於 *CPU metrics*, *block I/O*, *Memory* 會比較複雜一點...
- 可在 *memory cgroup* 裡面找到 *Memory metrics*
- 因為 *Memory metrics* 可以非常細部的偵測到主機上面運用記憶體的狀況, 因此會多一些開銷, 因此在部分 OS 裡頭, 預設是被關閉的
    - 可藉由 *kernel CLI* 加上此參數: `cgroup_enable=memory swapaccount=1` 來啟用它
    - 此 metrics 存在於 pseudo-file `memory.stat` 看起來如下:
        - 前半部(非 total_ 開頭): contains statistics relevant to the processes within the cgroup, excluding sub-cgroups
        - 後半部(為 total_ 開頭): includes sub-cgroups as well

```
cache 11492564992
rss 1930993664
mapped_file 306728960
pgpgin 406632648
pgpgout 403355412
swap 0
pgfault 728281223
pgmajfault 1724
inactive_anon 46608384
active_anon 1884520448
inactive_file 7003344896
active_file 4489052160
unevictable 32768
hierarchical_memory_limit 9223372036854775807
hierarchical_memsw_limit 9223372036854775807
total_cache 11492564992
total_rss 1930993664
total_mapped_file 306728960
total_pgpgin 406632648
total_pgpgout 403355412
total_swap 0
total_pgfault 728281223
total_pgmajfault 1724
total_inactive_anon 46608384
total_active_anon 1884520448
total_inactive_file 7003344896
total_active_file 4489052160
total_unevictable 32768
```

底下紀錄了一些 Metric 相關的描述:

- cache:
- rss:
- mapped_file
- pgfault, pgmajfault: 
- swap: 
- active_anon, inactive_anon: 
- active_file, inactive_file: 
- unevictable: 
- memory_limit, memsw_limit:

----------

計算 *page cache* 使用的 memory 非常複雜

假設有 2 個 Processes 在不同的 CGroups 運行著, 

但他們都讀取相同的檔案(也就是 disk 上頭相同的 block)

則記憶體的消耗會被這 2 個 CGroups 分攤

若其中一個 CGroup 終止時, 可能會增加另一個 CGroup 的記憶體使用量

因為他們不再為 memory pages 來分攤成本了

----------


### CPU metrics: `cpuacct.stat`

- *CPU metrics* 存在於 `cpuacct` controller
- 對於每個容器來說, pseudo-file `cpuacct.stat` 包含 容器進程 的 CPU 累計使用情況, 可再切分為:
    - user time: exec process code 後, 一個 Process 直接控制 CPU 的時間
    - system time: kernel 代表 Process 執行 syscall 的時間
- 上述時間以 *1/100th of a second* 來作表示, 又稱為 *user jiffies*
    - There are `USER_HZ` "jiffies" per second, and on x86 systems, `USER_HZ` is 100. (不懂...)
    - 綜觀歷史, 這精確地映射到 *the number of scheduler "ticks" per second*, 但對於 更高頻率的排程 or *tickless kernels*, 使 *number of ticks* 變得無關緊要


#### BLOCK I/O METRICS

*Block I/O* 在 `blkio controller` 裡頭計算. 不同的 metrics 被分散在不同的 files

底下列出與目前主題會比較相關的 metrics, 若要進一步研究可參考 [blkio-controller file](https://www.kernel.org/doc/Documentation/cgroup-v1/blkio-controller.txt)

- blkio.sectors: 
- blkio.io_service_bytes:
- blkio.io_serviced: 
- blkio.io_queued: 


### Network metrics

*Network metrics* 沒有對 *CGroups* 直接暴露

*Network Interface* 存在於 *Network namespaces* 的 context
    
Kernel 可能會去累積有關 一組 Processes 收/發 *packets* & *bytes* 的 metrics, 但這可能是 useless
    - 像是 `lo interface` 的數據並不被記入
    - 單一 CGroup 內的 Processes 可能屬於多個 *Network namespace*, 使得度量這些指標變得更加難以解釋
        - *multi Network namespace* 意味著潛在多個 *lo interfaces*

這有就是為啥 沒有簡單的方法可以與 CGroup 一起蒐集 *Network metric* 的原因 (上面這邊看得好像有點懂, 但又不是非常懂)

但可由 *IPTABLES* 及 *INTERFACE-LEVEL COUNTERS* 來蒐集:


#### 1. IPTABLES

遇到再說


#### 2. INTERFACE-LEVEL COUNTERS

遇到再說


## Tips for high-performance metric collection

遇到再說


## Collect metrics when a container exits

> 有時候未必需要即時的 metrics, 但會想知道容器 exit 以後, 耗用了多少的資源. Docker makes this difficult because it relies on `lxc-start`, which carefully cleans up after itself. (看不懂)

但若是執意要蒐集上述的 metrics, ...遇到再說

`collected LXC plugin` 幫忙執行 定期蒐集 metrics 的任務