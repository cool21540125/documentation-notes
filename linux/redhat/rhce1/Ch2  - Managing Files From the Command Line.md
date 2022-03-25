# Linux樹目錄結構

```sh
$ ls -l /
```

- /etc : 系統相關的組態檔
- /bin : 指向 /usr/bin 的軟連結
- /sbin : 指向 /usr/sbin 的軟連結
- /usr/bin : 一般使用者 使用的工具/指令/執行檔
- /usr/sbin : admin 使用的工具/指令/執行檔
- /var : 會隨著系統運作而變動的檔案 ex: 登錄檔/程序檔/資料庫/Log
- /run : 系統開機後所產生的各項資訊 ex: xxx.pid
- /proc : 系統運作時的記憶體內資訊(非磁碟)
- /tmp : 你可以對她做任何事~



# 使用 `Brace expansion` 加速指令操作

```sh
# 快速新增
# file1 file2 file3 file4
# touch file{1..4}
cd
rm -rf test_dir
mkdir test_dir
cd test_dir
touch tv_season{1..2}_episode{1..6}.ogg
ls -l

mkdir -p Documents/{editor,plot_change,vacation}
ls -l Documents

cd ..
rm -rf test_dir
```



# 使用 `Command substitution` 活化指令操作

```sh
echo `date +%F`     # 比較老舊版本的指令
echo $(date +%F)    # 此方式較佳

host=${hostname}
echo "**** 可以查看 hostname = ${host} *****"       # 弱引號「"」
echo '**** 看不到 hostname = ${host} *****'         # 強引號「'」
```
