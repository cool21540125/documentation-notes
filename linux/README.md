# CentOS 7

安裝的 ISO 說明: 自從 CentOS7 開始, `版本命名依據` 就跟 `發表日` 有關

    CentOS-7-x86_64-Everything-1503-01.iso
    -------- ------ ---------- ---- --
       A        B        C      D   E

    A: Linux distribution - CentOS 7
    B: 64位元
    C: 包山包海的版本(內建所有的說明文件)
    D: 於 2015/03 發表
    E: 7.1版 (連同 A 一起看)

```sh
# 環境
$ uname -a
Linux tonynb 3.10.0-514.el7.x86_64 #1 SMP Tue Nov 22 16:42:41 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

# 環境
$ hostnamectl
   Static hostname: tonynb
         Icon name: computer-laptop
           Chassis: laptop
        Machine ID: 6e935c5d22124158bd0a6ebf9e086b24
           Boot ID: 3262e51d23a9478dbc268f562556a74c
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-514.el7.x86_64
      Architecture: x86-64

# 環境
$ cat /etc/centos-release
CentOS Linux release 7.3.1611 (Core)

# 環境
$ rpm --query centos-release
centos-release-7-3.1611.el7.centos.x86_64

# 這東西需要額外安裝 yum install redhat-lsb
$ lsb_release -a
LSB Version:    :core-4.1-amd64:core-4.1-noarch
Distributor ID: CentOS
Description:    CentOS Linux release 7.4.1708 (Core)
Release:        7.4.1708
Codename:       Core

# Type Chinese
$ yum install kde-l10n-Chinese
```
