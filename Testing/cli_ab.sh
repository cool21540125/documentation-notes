#!/bin/bash
exit 0
# 
# --------------------------------------------------------

###
ab -V
#This is ApacheBench, Version 2.3 <$Revision: 1903618 $>


###
API_URL=http://localhost:5000/users
ab -n 10 -c 2 $API_URL
# -n : 請求次數
# -c : 併發次數
# -s : (default 30 secs) 好像是壓測持續多久的樣子?


### 