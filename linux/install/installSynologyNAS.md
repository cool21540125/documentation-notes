
# Synology NAS 安裝備註

環境如下:

> DS220+

```bash
### (為了 Markdown 顯示, 輸出有稍微調整過)
$# uname -a
Linux ChouHome 4.4.59+ \#25556 SMP PREEMPT Thu Mar 4 18:03:47 CST 2021 x86_64 GNU/Linux synology_geminilake_220+

$# dpkg --version
Debian `dpkg` package management program version 1.16.17 (amd64).
This is free software; see the GNU General Public License version 2 or
later for copying conditions. There is NO warranty.
```


# 使用社群套件

- 2021/06/20
- [How to install IPKG on Synology NAS](https://community.synology.com/enu/forum/1/post/127148)

Step1. Install

> 套件中心 > 設定 > 套件來源 > 新增

- 名稱: CPHub
- 位置: http://www.cphub.net

Step2. Usage

> 套件中心 > 社群


# Install ipkg

因為 Synology NAS 的 Distribution 似乎是從 Debian 改來改去改來的, 但又不那麼的 Debina, 因而社群弄出了個 `ipkg` 做為 額外的套件管理員

Step1. Install

> 套件中心 > 社群 > `Easy Bootstrap Installer` > (省略中間的安裝過程)

Step2. Environment Variable

```bash
echo 'export PATH="$PATH:/opt/bin"' >> /etc/profile
echo 'export PATH="$PATH:/opt/sbin"' >> /etc/profile
. /etc/profile
echo $PATH

ipkg update
ipkg upgrade
```

Step3. Usage

```bash
### 查看可安裝的套建 (超多@@... 1000多個)
ipkg list
```


# Install lrzsz

```bash
ipkg install lrzsz
# 東西放在 /opt/bin
```


# Install Usage of `lsof` && `fuser`

```bash
ipkg install lsof    # lsof
ipkg install psmisc  # fuser
```