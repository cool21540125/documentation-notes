# Ch5  - Managing Priority of Linux Processes

## 優先權

- Priority: [-99, 39] 越高越優先
- Nice Value: [-20, 19] 越低越優先


```sh
# 啟動某個程序, 並給定初始的 Nice Value(預設為10)
$ nice -n <NI> <Command>


# 修改某個 pid 的 Nice Value
$ renice -n 5 <PID>
# 一般使用者只能調高, 無法調低, 且只能給 +值, 即[0, 19]
```
