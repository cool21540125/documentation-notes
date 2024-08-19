#!/bin/bash
exit 0
### 網路封包擷取工具
# https://www.ibm.com/docs/zh-tw/aix/7.3?topic=t-tcpdump-command
#
# tcpdump [OPTIONs] [EXPRESSION]
# -A : 以 ASCII 顯示 packet 內容
# -b : 以 IP address 格式顯示 BGP 的封包資訊
# -c N : 執行幾次 (否則持續偵測)
# -C N : 指定每個 packet 檔案大小, 單位為 10^6 Bytes. 若為多檔案, 則會在 -w 產出檔加上序號
# -D : 檢查 tcpdump 可處理的網卡, 並列出 序號(可用於 -i OPTION)
# -e : 額外顯示出 L2 Header
# -F EXP_FILE : 過濾條件格式檔案
# -i IFACE : 網卡裝置, ex: eth0
# -I : 將無線網卡執行在 monitor mode (並非所有網卡都支援)
# -l : 將 stdout 行設為緩衝 (似乎後面可用來作 | grep xxx ??)
# -n : 不反解 hostname (僅顯示 IP)
# -nn : 不反解 hostname 及 service (僅顯示 IP port)
# -p : 不啟用網卡混雜模式 (啥?)
# -q : 僅以簡式封包資訊方式呈現
# -r IN_FILE : 依照 EXPRESSION 條件讀取 packet file
# -s0 : (預設為 68 bytes, 適用於 IP, ICMP, TCP, UDP) 若要擷取其他協定, 要適時調整此 snaplen, 太小會不當截斷其他協定的封包, 太大會造成額外負擔
# -t : 不顯示 ts
# -v   : 列出封包詳情
# -vv  :
# -vvv :
# -w OUT_FILE : 結果寫入檔案. 格式為 .pcap
# -x : 16 進制呈現
# -X : 16 進制 + ASCII 呈現
# -z CMD : (與 -C 一同使用) 每當完成一組 packet file, 就執行該動作. ex: -z gzip
#
# 可參照 Pcap Filter
# dst host HOST
# src host HOST
# host HOST
# ether dst EHOST
# ether src EHOST
# ether host EHOST
# gateway host
# dst net NET
# src net NET
# net net
# dst port PORT
# src port PORT
# ------------------------------------------------------------------------

### Version
tcpdump --version
#tcpdump version 4.99.1 -- Apple version 137
#libpcap version 1.10.1
#LibreSSL 3.3.6

###
HOST=giftshopgw.systex.com
sudo tcpdump -nn -l -A -c1 dst host $HOST

###
sudo tcpdump -s0 -A -n -l

###
sudo tcpdump -i en0 -nn -s0 -v port 80

###
sudo tcpdump -r $HOME/tmp/demo_tcpdump.pcap

###
sudo tcpdump -i eth0 -s0 -w tmp/test.pcap
