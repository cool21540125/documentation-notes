# find 指令進階用法


```sh
# 任何檔案只要是沒有 user owner 或是 group owner, 就把它列出來, 如果因為查了無權限的檔案導致錯誤的話, 不要產生錯誤訊息
find / -nouser -o nogroup 2> /dev/null
```