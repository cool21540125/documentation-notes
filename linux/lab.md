

## 大量建置帳號

```bash
/bin/bash
# 建立群組 smart
# 建立 tony1, tony2, tony3, tony4, tony5
# 把 tony們加入到 smart 群組, 並設定每個
groupadd smart
for username in tony{1..5}
do
    useradd -G smart ${username}
    echo 'password' | passwd --stdin ${username}
done
```


## 共享目錄

```sh
# 建立 shared 群組
# 建立 /home/shared
# 該資料夾可讓 shared 群組的人們都可進來存取
groupadd shared
mkdir /home/shared
chgrp shared /home/shared
chmod 2770 /home/shared
ll -d /home/shared
```