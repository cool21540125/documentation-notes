
```bash
### 將資料分割成 N 等分
$# split
# 1. 製作 400MB 檔案
dd if=/dev/zero of=demo_large_file bs=4194304 count=100

# 2. 分割
split -b 64m demo_large_file multi_part_


### 
```
