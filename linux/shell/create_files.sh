#!/bin/bash
# 2018/04/11
# 

echo "建立檔案~"
read -p "Your name: " user

# 為了避免隨意按 Enter, 利用變數功能分析檔名是否有設定
filename=${user:-"filename"}

date1=$(date --date='2 days ago' +%Y%m%d)   # 前2天
date2=$(date --date='1 days ago' +%Y%m%d)   # 前1天
date3=$(date +%Y%m%d)

file1=${filename}${date1}
file2=${filename}${date2}
file3=${filename}${date3}

touch "${file1}"
touch "${file2}"
touch "${file3}"
