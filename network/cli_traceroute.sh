#!/bin/bash
exit 0
#
# 路由路徑追蹤工具, 找出 icmp 封包到 目的主機 的路徑(中途節點, 可能因為安全性考量, 而無法回應)
#
#
#
# traceroute -[IT]
# -I : 使用 ICMP
# -T : 使用 TCP
# -U : (default) UDP
# -m max_ttl : (default 30) 可自行修改  max hops
#
# ------------------------------------------------------------------------------------------------

###
traceroute www.yahoo.com
#traceroute to www.yahoo.com (98.137.246.8), 30 hops max, 60 byte packets
# 1  172.253.71.139 (172.253.71.139)  7.514 ms 172.253.71.117 (172.253.71.117)  12.276 ms 209.85.249.95 (209.85.249.95)  8.593 ms
# 2  74.125.243.186 (74.125.243.186)  8.529 ms 108.170.245.100 (108.170.245.100)  95.182 ms 108.170.245.102 (108.170.245.102)  7.533 ms
# 3  * * *
# 4  ae-7.pat1.gqb.yahoo.com (216.115.96.45)  11.395 ms  11.435 ms ae-7.pat2.gqb.yahoo.com (216.115.101.109)  11.568 ms
# 5  et-0-0-0.msr1.gq1.yahoo.com (66.196.67.97)  11.253 ms et-1-0-0.msr1.gq1.yahoo.com (66.196.67.101)  11.065 ms et-18-1-0.msr2.gq1.yahoo.com (66.196.67.115)  12.619 ms
# 6  et-0-0-0.clr2-a-gdc.gq1.yahoo.com (67.195.37.73)  11.188 ms  11.539 ms et-1-0-0.clr2-a-gdc.gq1.yahoo.com (67.195.37.97)  11.521 ms
# 7  et-18-6.bas2-2-flk.gq1.yahoo.com (98.137.120.27)  11.674 ms et-16-6.bas1-2-flk.gq1.yahoo.com (98.137.120.6)  11.803 ms  11.440 ms
# 8  media-router-fp2.prod1.media.vip.gq1.yahoo.com (98.137.246.8)  11.326 ms  11.618 ms  11.293 ms
# # 每一行, 稱之為一個 TTL, 預設 30 個 TTL 若無法抵達目的地, 則視為 unreachable
# # 每個 TTL 預設會做 3 次 probe(探測), 每次探測的時間代表匝道之間的 TIME EXCEEDED(往返時間)
# # 傳統上, 5 秒內無法回應的話會回傳 *
# # 現代, 因防火牆被廣泛使用 及 一堆我還不懂的原因, 匝道可能因為安全性考量, 而不揭露目前位置, 取而代之只顯示 *
# # 若出現 !H, !N, !P  分別代表 (host, network, protocol  unreachable), 當然還有其他... 這邊不贅述

###