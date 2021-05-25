
# CentOS6.x 安裝備註

- 這個有點舊了, 2017/05 以前的東西, 將來「若吃飽太閒」, 再回來整裡



# 讓使用者成為 pu

```sh
$# visudo  # 千萬不要使用「vim /etc/sudoers」
# 於ALL=(ALL)   ALL下一行增加
<user>=(ALL)   ALL

# 如果覺得每次都要打密碼很麻煩 把下列寫入即可
tony ALL=(ALL) NOPASSWD: ALL
# 上 su 免輸入密碼
```



# 網路

- CentOS 6.0 in Hyper-V
- [Installing Linux Integration Services Version 3.1](https://terrytlslau.tls1.cc/2011/08/installing-linux-integration-services.html)
- [Configure CentOS6 Network Settings](https://www.serverlab.ca/tutorials/linux/administration-linux/configure-centos-6-network-settings/)


先掛載光碟機 `mount /dev/cdrom /media/`

需要額外安裝兩樣東西(64-bits)

1. rpm -ivh /media/x86_64/kmod-microsoft-hyper-v-rhel6-60.1.x86_64.rpm
2. rpm -ivh /media/x86_64/microsoft-hyper-v-rhel6-60.1.x86_64.rpm

手動設定連線

```sh
$# ll /etc/sysconfig/network-scripts/

### DHCP
$# vim ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=dhcp
IPV4_FAILURE_FATAL=yes
NAME="dmystem eth0"

### Static IP
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=none
IPADDR=172.30.0.53
PREFIX=24
GATEWAY=172.30.0.1
IPV4_FAILURE_FATAL=yes
NAME="System eth0"

$# service network restart
```


使用 `system-config-network`

```sh
$# system-config-network-tui
```



安裝selenium
http://seleniumhq.github.io/selenium/docs/api/py/index.html
https://github.com/mozilla/geckodriver/releases


geckodriver
http://seleniumhq.github.io/selenium/docs/api/py/index.html
selenium for python用, 建立軟連結到 /usr/local/bin



# 安裝中文字型

```sh
$ sudo yum install cjkuni-*
```
