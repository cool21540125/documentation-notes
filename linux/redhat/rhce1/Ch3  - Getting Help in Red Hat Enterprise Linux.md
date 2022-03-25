# 指令求助 `man` 或 `--help`

Section | Content type
------- | -------------
1       | User  command
2       | System calls (很進階的東西...)
5       | File formats
8       | System admin commands


```sh
man 1 passwd        # 查看 passwd 指令
man 5 passwd        # 查看 /etc/passwd 組態說明
man passwd          # 沒指定頁面的話, 預設會開啟最小且存在的那頁
# q 可離開

# 或者
passwd --help
```
