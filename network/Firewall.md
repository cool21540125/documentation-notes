
- 2018/09/28


# Linux 防火牆的主要類別

參考來源: 鳥哥的Linux伺服器架設(第三版)(CentOS6), 與現行的 CentOS7 不知道差多少...

區分為 `網域型` 與 `單一主機型`

- 單一主機型
    - Netfilter
    - TCP Wrappers
- 網域型(區域型) - 都拿來當作 `Router`
    - Netfilter
    - Proxy


## 1. Netfilter (封包過濾機制)

取出來源請求封包表頭, 分析 `MAC`, `IP`, `TCP`, `UDP`, `ICMP`...

主要分析 OSI 的 2, 3, 4 層


## 2. TCP Wrappers (程式控管)

分析 誰對某程式進行存取, 該 Server 誰能連線、誰不能 ; 因為標的是`程式`, 所以與啟動的 port 無關, 只與程式名稱有關


## 3. Proxy (代理伺服器)

偽裝內部網路對外的請求, 由統一的 Public IP 為對外窗口.
