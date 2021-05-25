

## 讓 CPU 飆升的測試(耗時計算)

```sh
### 計算圓周率, 計算到小數點以下8000位
echo "scale=8000; 4*a(1)" | bc -l -q >> /dev/null
# 另一個 Terminal 再 htop

### 模擬 CPU 飆升
head -n 5000000 /dev/urandom | md5sum
# ↑ 5,000,000 大約跑 10 秒內, 所以還算安全

### 讓 CPU 飆高
for i in `seq 1 $(cat /proc/cpuinfo |grep "physical id" |wc -l)`; do dd if=/dev/zero of=/dev/null & done

### 讓 CPU 飆高
dd if=/dev/zero of=/dev/null
```