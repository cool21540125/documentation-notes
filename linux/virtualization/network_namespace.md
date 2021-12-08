# Linux 網路虛擬化 - Network Namespace

- 2020/08/30
- 2020/11/02


## Notes

- 每個 namespace 都有自己的 `/proc/net/`
- C語言 透過調用 Linux 的 `clone(CLONE_NEWNET)` (UNIX `fork()` 的延伸) 來建立 namespace; 或者, 可透過 `ip` CLI 來實作 操作 namespace
- 如果 namespace 裡面想要與 外界(除了 lo 以外的其他網卡) 溝通, 需要在 NS 裡面建立 `veth pair` (就像是 Linux 的 `pipe`)

```bash
### 建立名為 netns1 的 network namespace
$# ip netns add netns1
# 會在 /var/run/netns 建立一個 掛載點
# 此 掛載點, 方便對 NS 管理 && 使 NS 即使沒有程序運行也能繼續存在

### 進入名為 netns1 的 NS, 查詢 ip 配置
$# ip netns exec netns1 ip link list
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000      # 預設只應該有這個
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00                                   # 預設只應該有這個
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000    # (Centos:7 Container 才有這個, 但這啥別鳥他)
    link/ipip 0.0.0.0 brd 0.0.0.0                                                             # (Centos:7 Container 才有這個, 但這啥別鳥他)
3: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000  # (Centos:7 Container 才有這個, 但這啥別鳥他)
    link/tunnel6 :: brd ::                                                                    # (Centos:7 Container 才有這個, 但這啥別鳥他)
# lo 的啟用狀態是 DOWN 哦!

### 系統內有哪些 network namespace
$# ip netns list
netns1

### 進入 netns1, ping localhost
$# ip netns exec netns1 ping 127.0.0.1 -c 1
connect: Network is unreachable
# 因為預設是 DOWN

### 進入 netns1, 啟用 lo 
$# ip netns exec netns1 ip link set dev lo up
# 啟用後再 ping 一次就有了~

### (最後再來做)刪除名為 netns1 的 network namespace (先別刪除, 下面會用到)
$# # ip netns delete netns1
# !!! 並非真實移除, 只是移除了他的 掛載點 (裡面有程序運行著的話, 它就會一直存在)
```

如果此 NS 想要與外界溝通, 那麼就得建立 `veth pair` (Linux 的雙向管道)

```bash
# 首先, 目前主機上就兩張網卡, lo & 實體網卡 ens3
$# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 02:11:32:25:e5:72 brd ff:ff:ff:ff:ff:ff

### 新增一對 veth-pair, 分別為 veth0 & veth1 (建立了一對 虛擬乙太網卡)
$# ip link add veth0 type veth peer name veth1
$# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 02:11:32:25:e5:72 brd ff:ff:ff:ff:ff:ff
3: veth1@veth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether de:4d:aa:e2:4a:aa brd ff:ff:ff:ff:ff:ff
4: veth0@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 4a:b2:92:35:a8:e0 brd ff:ff:ff:ff:ff:ff

# 把 veth1 移動到 netns1 這個 NS (未移動前, 預設都在 root Network NS)
$# ip link set veth1 netns netns1

### 兩個 veth-pair 配置好 IP && up
$# ip netns exec netns1 ifconfig veth1 10.1.1.1/24 up  # 啟動 netns1 NS 的 veth1, 並綁定 IP
$# ifconfig veth0 10.1.1.2/24 up                       # 啟動 root   NS 的 veth0, 並綁定 IP
# 之後就可以互相 ping 了
$# ping 10.1.1.1                                       # root NS of veth0 PING netns1 NS of veth1
$# ip netns exec netns1 ping 10.1.1.2                  # netns1 NS of veth1 PING root NS of veth0

```