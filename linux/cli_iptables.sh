#!/bin/bash
exit 0
# `iptables` 會透過 `getsockopt/setsockopt` 等 IPC 方式與 Kernel 進行溝通
#
#$ iptables -t {filter|nat|mangle}            針對 table 做操作 (預設為 -t filter)
#$ iptables -N {INPUT|OUTPUT}                 create chain
#$ iptables -X {INPUT|OUTPUT}                 delete chain
#$ iptables {-A|-C|-D}                        add|check|delete 一條規則
#$ iptables -I CHAIN [RuleNum] MATCH TARGET   isnert 一條規則
#$ iptables -R CHAIN RuleNum MATCH TARGET     replace 一條規則
#$ iptables -L [-n] [CHAIN]                   list chain 的規則 (-n 表示不做 hostname 解析, 僅顯示 IP)
#$ iptables -F [CHAIN]                        flush chain 底下的所有 Rules. 如果沒指定 chain, 就是清除 table 底下所有 chains!!
#
# MATCH
# !Rule                                       表示 NOT Rule
# -m MatchName [MATCH-OPTIONs]                引用外部比對模組
# -i IFace                                    指定連入的 network interface
# -o IFace                                    指定輸出的 network interface
# -p {tcp|udp|icmp|all}                       指定封包的協定
# -s ADDR[/MASK]                              指定 Source Network
# -d ADDR[/MASK]                              指定 Destination Network
# --sport PORTS                               指定封包來源的 port number
# --dport PORTS                               指定封包目標的 port number
#
# TARGET
# 表示符合 MATCH 時, 封包的處理規則
# -j {ACCEPT|DROP}
# --------------------------------------------------------------------

### 清除 iptables 規則
iptables -F        # 清除所有
iptables -X        # 清除所有 udf chain
iptables -Z        # 所有 chain 的計數及流量統計歸零
sudo iptables-save # 執行任何 iptables 異動後, 做永久異動寫入
###

### 設定「iptables FORWARD policy」為 ACCEPT (原為 DROP)
sudo iptables -P FORWARD ACCEPT
# 永久生效需做

### 開放 3306 port
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT

### 移除
iptables -D INPUT -p tcp --dport 3306 -j ACCEPT

### 只針對特定 IP 開 3306 port
iptables -A INPUT -p tcp -s Your_IP --dport 3306 -j ACCEPT
iptables -D INPUT -p tcp -s 12.34.56.78 --dport 22 -j ACCEPT
iptables -I INPUT -p tcp -s 12.34.56.78 --dport 22 -j ACCEPT
