# CentOS / RHEL 7 : How to disable Transparent Huge pages (THP)

- https://www.thegeekdiary.com/centos-rhel-7-how-to-disable-transparent-huge-pages-thp/
- 本文未經嚴謹驗證

系統中有兩種類型的 HugePage: 

- 由 配置此參數來啟用 `vm.nr_hugepages sysctl`
- 自動由 Kernel 配置


## Verify if THP is enabled

CentOS/Redhat 上的 `tuned.service` 預設為 `always` (即使在 `grub kernel command` 已經禁用, 在開機期間, 也會被設定為 `always`)

```bash
cat /sys/kernel/mm/transparent_hugepage/enabled
#[always] madvise never
# ↑ 預設是這樣子的

systemctl stop tuned
systemctl disable tuned
# 或
tuned-adm off
```

```bash
# ↓ MongoDB 官網的範例
mkdir -p /etc/tuned/virtual-guest-no-thp
cat <<EOF > /etc/tuned/virtual-guest-no-thp/tuned.conf
[main]
include=virtual-guest

[vm]
transparent_hugepages=never
EOF
# ↑ MongoDB 官網的範例
# ↓ 此文的範例
mkdir -p /etc/tuned/nothp_profile
cat <<EOF > /etc/tuned/nothp_profile/tuned.conf 
[main]
include= throughput-performance

[vm]
transparent_hugepages=never
EOF
# ↑ 此文的範例

chmod +x /etc/tuned/nothp_profile/tuned.conf

tuned-adm profile nothp_profile
```


## profiling

> allocs: A sampling of all past memory allocations.

> heap: A sampling of memory allocations of live objects. You can specify the gc GET parameter to run GC before taking the heap.

> profile: CPU profile. You can specifiy the duration in the seconds GET parameter. After you get hte profile file, use the go tool pprof command to investigate the profile.

> trace: A trace of execution of the current program. You can specify the duration in the seconds GET parameter. After you get the trace file, use the go tool trace command to investigate the trace.

> threadcreate: Stack traces that led to the creation of new OS threads.

> block: Stack traces that led to blocking on synchronization