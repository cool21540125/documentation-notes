#!/usr/bin/bash

# 監控 CPU, RAM, Disk
# 2019/07/19
# 參考自: Python Linux 系統管理與自動化運維 Ch6
# Note:
#   yum install -y bc
#   若單純使用 $((100 - 99.8)), 有小數時會出錯, 所以使用 bc. (效率也比較高)
#####################################

cpu_idle=$(top -n1 | grep 'Cpu' | tail -n 1 | awk '{ print $8 }')
cpu_usage=$(echo "100 - ${cpu_idle}" | bc)

# free + buff/cache
mem_free=$(free -m | awk '/Mem:/{ print $4 + $6 }')

mem_total=$(free -m | awk '/Mem:/{ print $2 }')
mem_used=$((${mem_total} - ${mem_free}))
mem_rate=$((${mem_used} * 100 / ${mem_total}))

disk_usage=$(df -h / | tail -n 1 | awk '{ print $5 }')
disk_used=$(df -h / | tail -n 1 | awk '{ print $3 }')

echo '-----------------'
echo "CPU利用率: ${cpu_usage}"
echo "RAM用量 ${mem_used}M , 利用率 ${mem_rate}%"
echo "Disk用量 ${disk_used} , 利用率 ${disk_usage}"
echo '-----------------'
