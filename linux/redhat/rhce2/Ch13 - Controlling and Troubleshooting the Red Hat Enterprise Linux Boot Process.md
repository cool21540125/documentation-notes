# Ch13 - Controlling and Troubleshooting the Red Hat Enterprise Linux Boot Process

1. 開機流程
2. systemd target
3. root 密碼忘了
4. Boot Loader

## 1. 開機流程

- [鳥哥-開機流程](http://linux.vbird.org/linux_basic/0510osloader.php#startup_intro)

我不想講~~~~~~~

## 2. systemd target

系統開機後看到的介面

Target            | Purpose
----------------- | --------------------
graphical.target  | 圖形化桌面環境 `init 5`
multi-user.target | 白底黑字專業阿宅介面 `init 3`
rescue.target     | (進階)救援用
emergency.target  | (進階)救援用

```sh
# 查詢目前 系統操作介面狀態
$# systemctl get-default
graphical.target

# 查詢 系統操作介面狀態
$# systemctl status multi-user.target
$# systemctl status graphical.target

# 現在立刻更換 系統操作介面狀態
$# systemctl isolate multi-user.target
$# systemctl isolate graphical.target

# 下次開機後更換 系統操作介面狀態
$# systemctl set-default multi-user.target
$# systemctl set-default graphical.target
```

## 3. root 密碼忘了

1.  重開機
2.  於 boot loader 倒數階段, 按 "上下鍵" 中斷它倒數
3.  選擇你要救援的 kernel(基本上, 選擇最上面那個), 按「e」
4.  (會進入一個黑底白字的世界) 把指標移動到 linux16 這一行行首, 按「End」
5.  (與前面的東西要有空白)在行尾輸入「rd.break」
6.  按「Ctrl + x」(千萬別按 ENTER)
7.  輸入 「mount -o remount,rw /sysroot」 
8.  輸入 「chroot /sysroot」 (會取得 sh-4.2 )
9.  輸入 「passwd root」 (然後輸入要重新設定的 root 密碼)
10. 輸入 「touch /.autorelabel」    (讓 SELinux 重新設定 context)
11. 輸入 「exit」
12. 輸入 「exit」(然後要等一下子, SELinux 會為系統重新 relabel)

### 另一種方式(2020/04 同事提供, 因說上述方法第七步會卡住, 原因尚不明)

1. 重開機，按e進入界面
2. 修改 linux16 那行
 ro crashkernel=auto
->rw crashkernel=auto
3. 最後加入 init=/bin/sh
4. 重啟
 Ctrl+X
5. 出現 ":h-4.2#"
6. 輸入修改密碼指令
 echo "要改的密碼"|passwd --stdin root
7. SELinux 會為系統重新 relabel
 touch /.autorelabel 
8. 重啟系統 
 exec /sbin/init
 

## 4. Boot Loader

RHEL7 的 開機載入器 : `GRand Unified Bootloader, grub2`; 可以操作幾乎所有使用 BIOS 或 UEFI 的作業系統

- `/etc/default/grub`    : 預設的開機組態檔
- `grub2-mkconfig`       : (此為指令) 依照 `/etc/default/grub`, 產生新的開機掛載選單
- `/boot/grub2/grub.cfg` : 不想死的話, 就別直接改它. 而是透過 `grub2-mkconfig` 來改它

```sh
$# vim /etc/default/grub
# 例如, 在原本的 GRUB_CMDLINE_LINUX 後面再加上一些開機時的組態設定
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet audit=1" # 原本
GRUB_CMDLINE_LINUX="rd.lvm.lv=centos/root rhgb quiet audit=1" # 改成這樣

$# grub2-mkconfig -o /boot/grub2/grub.cfg
# 使用 grub2-mkconfig 指令, 去檢查 /etc/default/grub, 並重建 /boot/grub2/grub.cfg
```
