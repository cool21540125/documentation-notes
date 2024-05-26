#!/opt/homebrew/bin siege
exit 0
# brew install siege
# -----------


### Example1
siege -c 1 -t 20s $URL
# -c n : 模擬同時訪問的用戶數 (設越大, 本地 Memory 耗用越高)
# -t n : (不能與 -r 同時存在) 持續運行多久
# -r n : (不能與 -t 同時存在) 重複 n 次


### Example2
siege -c 100 -t 10m $URL


### 
