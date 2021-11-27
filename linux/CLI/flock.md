# flock

- 2020/04/17
- [利用flock來做同步和非同步應用](https://rpubs.com/wush978/flock)

## 直接看範例

```bash
$# vim test.sh
#! /bin/bash
sleep 10
date

$# chmod 700 test.sh
```

### 情境1

開啟兩個 Terminal, 同時執行這個檔案 `./test.sh`, 可同時執行(輸出時間一樣)

### 情境2

如果要加入同步鎖(同一時間只能有一個人來執行)

打開兩個 Terminal, 同時使用 `flock -x test.lock ./test.sh` (預設為自帶 -x, 代表排他)

兩個 Terminal 會先後執行

### 情境3

- Terminal1: `flock -n test.lock ./test.sh`
- Terminal2: `flock -n test.lock ./test.sh`

以上兩個執行下去之後, `-n` 表示若未拿到執行鎖, 放棄執行

### 情境4

使用上也可讓他可被多個程序擁有 `flock -s test.lock ./test.sh` (-s 與 -x 不能同時存在)

結果同 情境1


## 使用上

```bash
#!/bin/bash
flock -s test.lock ./test.sh &
flock -s test.lock ./test.sh &
flock -s test.lock ./test.sh &
flock -x test.lock echo "上面的工作完成了"

# 後續腳本...
```

如此可讓他們共同執行任務完後, 才繼續後續工作
