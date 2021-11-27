# X Window System

- 2018/11/27

* X server 畫布 (遠端桌面的 Client)
* X client 畫家 (遠端桌面的 Server)

# Xdmcp

Xdmcp, X display manager control protocol (default 6000 port) 由 DM 程式提供

- GNOME 提供的 DM 為 `gdm` (CentOS 預設)
- X11 提供的 DM 為 `xdm`
- KDE 提供的 DM 為 `kdm`


名詞

* Display Manager(DM) : (簡化WM), 就是 tty2, tty3, tty4... 啦!! (提供登入環境), 並載入 WM
* Window Manager(WM) : 控制所有 X client 的管理程式, ex: GNOME, KDE, ...

啟用 Xdmcp 後

1. Linux Server (X client) : 開始監聽 177/UDP
2. OS (X server) : 連接到 X client 的 177/UDP
3. X server 透過 Xdmcp 載入 WM 相關的 X client
4. 取得 GUI Remote connection

```sh
### 我的圖形化介面 CentOS7 列出來的
$# yum grouplist
Loaded plugins: fastestmirror, langpacks
There is no installed groups file.
Maybe run: yum groups mark convert (see man yum)
Loading mirror speeds from cached hostfile
 * base: centos.ustc.edu.cn
 * extras: mirrors.163.com
 * updates: ftp.twaren.net
Available Environment Groups:
   Minimal Install
   Compute Node
   Infrastructure Server
   File and Print Server
   Basic Web Server
   Virtualization Host
   Server with GUI
   GNOME Desktop
   KDE Plasma Workspaces    # groupinstall 它!!
   Development and Creative Workstation
Available Groups:
   Compatibility Libraries
   Console Internet Tools
   Development Tools
   Graphical Administration Tools
   Legacy UNIX Compatibility
   Scientific Support
   Security Tools
   Smart Card Support
   System Administration Tools
   System Management
Done

$# yum groupinstall "KDE Plasma Workspaces"

# 話雖如此, 上面不鳥它, 一開始就有 下面這東西了~
$# vim /etc/gdm/custom.conf
[daemon]

[security]  # 登錄相關, 資安相關
# AllowRemoteRoot=yes           # xdmcp 預設無法 root login
# DisallowTCP=false             # 允許 X Server 使用 TCP 連線到 xdmcp

[xdmcp]
# Enable=true                   # 啟動 xdmcp 的主要項目

[chooser]

[debug]

$# 
```



# 圖形化介面的 sftp 用戶端軟體 : Filezilla