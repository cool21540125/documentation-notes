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