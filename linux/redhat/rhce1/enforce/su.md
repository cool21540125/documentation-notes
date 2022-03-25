# su 的一些細節

- 2018/11/10
- 預估閱讀時間 < 5 minutes

> 這細節或許很無聊, 但`魔鬼往往藏在細節裡`. 這次的議題, 對於多數 Linux 使用者來講, 會是沒有學習價值的 

今天你做把 admin user 切換成 `su` 的時候怎麼做?


```sh
### 情況一 ***************************************
# tony 在自己家目錄
[tony@localhost ~]$ pwd
/home/tony

# 注意囉~~~ 使用「su」進行使用者切換
[tony@localhost ~]$ su
Password:                       # 輸入 root 密碼

# 看!!!         ↓↓↓↓ 切換成 root 之後, 依然在 tony 家目錄底下
[root@localhost tony]$# pwd
/home/tony

# 「某部分環境變數」並不會切換成「root」的環境變數
[root@localhost tony]$# echo $PATH
/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/home/tony/.local/bin:/home/tony/bin
# 看到了沒~~~                                                 ↑↑↑↑↑↑↑↑↑↑↑           ↑↑↑↑↑↑↑↑↑↑↑↑↑↑


### 情況二 ***************************************
# tony 在自己家目錄
[tony@localhost ~]$ pwd
/home/tony

[tony@localhost ~]$ su -
Password:                       # 輸入 root 密碼

# 看!!!         ↓    切換成 root 之後, 跑到 root 家裡了
[root@localhost ~]$# pwd
/root

# 這下子環境變數才會變成都是「root」的
[root@localhost ~]$# echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
# 看到了沒~~~                                                 ↑↑↑↑↑↑↑↑↑
```

