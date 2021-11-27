# 在 CentOS7 安裝 NVIDIA 顯示卡驅動程式 (有問題!)
- 2018/03/24
- [Installing Nvidia GPU Driver with Nvidia Detect](https://www.youtube.com/watch?v=C9Yf71qh0i4)
- [Please Help with NVIDIA Driver installation on Centos 7](https://www.centos.org/forums/viewtopic.php?t=61162)
- [鳥哥-顯卡驅動](http://linux.vbird.org/linux_basic/0590xwindow.php#nvidia)

```sh
$ uname -a
Linux tonynb 3.10.0-514.el7.x86_64 #1 SMP Tue Nov 22 16:42:41 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

# 2018/04/07 下完 yum update後
$ uname -a
Linux tonynb 3.10.0-693.21.1.el7.x86_64 #1 SMP Wed Mar 7 19:03:37 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

### 硬體規格
Lenovo ideapad 310
i5 7th Generation
NVIDIA GEFORCE 920MX (2GB)
```


> CentOS7預設使用 `nouveau`這個顯示晶片的驅動程式, 若要安裝像是 Nvidia顯卡驅動的話, 得先下載好相對應的驅動程式, 關閉 `nouveau`, 然後關閉 `圖形界面(runlevel=3)` 的狀態下重新開機, 開始安裝 顯卡驅動, 然後重新設定 `runlevel=5`, 重新開機後, 應該就沒問題了^_^凸

> 但是!!!!!! 對於桌機來講, 應該可以正常使用, 但我電腦是NB... 網路上我看不太懂的東西說我這台比電有另一個顯示晶片, 弄玩後會發生一堆會錯, 所以暫時放棄!!!!!!


```sh
### 底下3個... 生產環境慎思阿~~~
$ sudo yum update
$ sudo groupinstall "Development Tools"
$ sudo yum install -y kernel-devel kernel-headers

# 查出電腦是用哪款的 NVIDIA顯卡, 有 2種方法
# 法1 從 PCI上查看, 顯示目前主機上面的各個 PCI 介面的裝置
$ lspci
00:00.0 Host bridge: Intel Corporation Device 5904 (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Device 5916 (rev 02)
00:14.0 USB controller: Intel Corporation Sunrise Point-LP USB 3.0 xHCI Controller (rev 21)
00:14.2 Signal processing controller: Intel Corporation Sunrise Point-LP Thermal subsystem (rev 21)
00:16.0 Communication controller: Intel Corporation Sunrise Point-LP CSME HECI #1 (rev 21)
00:17.0 SATA controller: Intel Corporation Sunrise Point-LP SATA Controller [AHCI mode] (rev 21)
00:1c.0 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root Port #5 (rev f1)
00:1c.5 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root Port #6 (rev f1)
00:1d.0 PCI bridge: Intel Corporation Sunrise Point-LP PCI Express Root Port #9 (rev f1)
00:1f.0 ISA bridge: Intel Corporation Device 9d58 (rev 21)
00:1f.2 Memory controller: Intel Corporation Sunrise Point-LP PMC (rev 21)
00:1f.3 Audio device: Intel Corporation Device 9d71 (rev 21)
00:1f.4 SMBus: Intel Corporation Sunrise Point-LP SMBus (rev 21)
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 10)
02:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8821AE 802.11ac PCIe Wireless Network Adapter
03:00.0 3D controller: NVIDIA Corporation GM108M [GeForce 920MX] (rev a2)       ### 找到型號了!!

### 法2 額外安裝NVIDIA軟體來查看
$ sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
$ sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.repo.noarch.rpm
$ sudo yum -y install nvidia-detect
$ nvidia-detect -v
Probing for supported NVIDIA devices...
[10de:134f] NVIDIA Corporation GM108M [GeForce 920MX]       ### 找到型號了!!
This device requires the current 390.25 NVIDIA driver kmod-nvidia   ### 系統說需要「390.25 NVIDIA driver」
[8086:5916] Intel Corporation Device 5916
An Intel display controller was also detected

### ~~到官方網站下載顯卡驅動程式~~

# 開機後, 系統不要載入的相關模組
$ sudo vi /etc/modprobe.d/blacklist.conf
blacklist nouveau
options nouveau modeset=0

# 修改 Boot Loader預設組態
$ sudo vi /etc/default/grub
GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet rd.driver.blacklist=nouveau nouveau.modeset=0"
# 在原本的 grub內, 加上「rd.driver.blacklist=nouveau nouveau.modeset=0」

# 重建 grub.cfg(grub2的 設定主檔)
$ sudo grub2-mkconfig -o /boot/grub2/grub.cfg
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-3.10.0-514.el7.x86_64
Found initrd image: /boot/initramfs-3.10.0-514.el7.x86_64.img
Found linux image: /boot/vmlinuz-0-rescue-e5c76287078c4e5fb54034d3d8b26e76
Found initrd image: /boot/initramfs-0-rescue-e5c76287078c4e5fb54034d3d8b26e76.img
done
# 建立完成後, 重新開機, 系統就不會載入 nouveau模組了

$ sudo reboot

# 重開機後
$ lsmod | grep nouveau
# (~~空的~~)

# 不重開機的情況下, 切換為 純文字模式(關掉圖形介面)
$ sudo systemctl isolate multi-user.target

# (文字界面, 開始安裝顯卡驅動)
$ sudo sh ./NVIDIA-Linux-x86_64-390.25.run

# 之後~~~
# Accept
# 安裝 32-bit 相容 library
# 讓程式主動去修改 xorg.conf

# 最後, 進行驅動程式升級檢查
$ nvidia-installer --update

# 回到圖形介面
$ sudo systemctl isolate graphical.target

### 然後我的電腦就GG了 QAQ ..................................

# 移除 NVIDIA driver
$ sudo systemctl isolate multi-user.target
$ sudo nvidia-uninstall
```
