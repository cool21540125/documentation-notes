#!/bin/bash
exit 0
# 資料處理工具(分欄位) - awk
# `awk '條件1{動作1} 條件2{動作2} ...' <filename>`; 欄位分隔符號預設為「空白鍵」or「tab鍵」
# -----------------------------------------

### 指定分隔欄位符號
#awk -F:
# 使用「:」作為分隔號

last -n 5
#tony     pts/10       192.168.124.94   Mon Apr  9 20:59   still logged in
#tony     pts/11       192.168.124.88   Mon Apr  9 20:11 - 20:12  (00:01)
#tony     pts/10       192.168.124.94   Mon Apr  9 19:37 - 20:51  (01:14)
#tony     pts/9        192.168.124.94   Mon Apr  9 17:02   still logged in
#tony     pts/9        192.168.124.94   Mon Apr  9 10:35 - 16:58  (06:23)

last -n 5 | awk '{print $1 "\t" $3}'
#tony    192.168.124.94
#tony    192.168.124.88
#tony    192.168.124.94
#tony    192.168.124.94
#tony    192.168.124.94

### awk split 範例
export NAME=Tony
env | grep '^NAME'
NAME=Tony
echo $(env | grep '^NAME' | awk '{split($0,kk,"="); print kk[2]}')
#Tony
# split 可將 awk 整行字串, 分割成 kk array, 使用 "=" 分割, 後續在印出第二個位置

### 抓出最後一個欄位
ll | awk '{print $NF}'
