# 主要目錄

Linux 各大 dictribution 都有自己的 `文件存放位置`, 但幾乎都遵照 `Filesystem Hierarchy Standard (FHS)`, 重點在於規範 `每個特定的目錄下應該要放置什麼樣子的資料`

| .        | Non-SysAdmin Usable            | SysAdmin Use Only       |
| -------- | ------------------------------ | ----------------------- |
| static   | /usr <br> /opt                 | /etc <br> /boot         |
| variable | /var/mail <br> /var/spool/news | /var/run <br> /var/lock |

下面的目錄樹結構, 是經年累月慢慢補上去的...(大致上按 英文 排序, 部分依 功能別 放在一起)

```sh
/bin/                           # 單人維護模式還能用的可執行檔; (os7後, 連結至 /usr/bin/)
/boot/                          # 開機時使用的核心檔案目錄.
     /grub2/                        # 開機設定檔
/dev/                           # Linux的任何裝置及設備目錄
    /cdrom/                         # 光碟機裝置(指向 sr0)
    /sr0                            # 光碟機裝置
    /fd0/                           # 軟碟機裝置
    /sda                            # 第一顆磁碟裝置
    /sdb                            # 第二顆磁碟裝置
    /sd1/                           # SCSI硬碟裝置
    /md0                            # 第一顆 軟體磁碟陣列裝置
    /hda/                           # IDE硬碟裝置
    /lp0/                           # 印表機裝置
/etc/                           # 系統 設定檔. ex: inittab, resolv.conf, fstab, rc.d
    /anacrontab                     # 定期 驅動執行 cron.daily, cron.weekly, cron.monthly 的腳本
    /ansible/
        /ansible.cfg                    # ansible 設定主檔
        /hosts                          #
        /roles/                         #
    /auto.master                    # autofs 主要設定檔
    /auto.master.d/                 # autofs 設定副檔(master-map file) (裡面的檔名必須是 *.autofs)
    /bashrc                         # 系統層面的 functions 及 alias
    /chrony.conf                    # 時間校正的服務設定檔
    /cron.d/*                           # Packages 相關的排程應該放這 ; admin 為了方便管理, 也可統一放這邊
        /0hourly                            # 每小時 驅動執行 cron.hourly 的腳本
    /cron.daily/*                       # 每天　 要被驅動執行的 Shell Script 放這
    /cron.hourly/*                      # 每小時 要被驅動執行的 Shell Script 放這
    /cron.monthly/*                     # 每月　 要被驅動執行的 Shell Script 放這
    /cron.weekly/*                      # 每週　 要被驅動執行的 Shell Script 放這
    /crontab                        # 如果有明確指名幾點幾分的排程工作, 建議放這裡
    /default/                       #
        /xxx                            # 對於 Debian 來說, 就是 /etc/init.d/xxx 啟動前 & 關閉前, 會先來做 source /etc/default/xxx
        /useradd                        # 使用 useradd 後, 預設的 新使用者 建立相關初始設定
        /grub                           # 開機程序的組態設定(中介)檔(修改此檔可經由指令檢查, 在放到真正的開機組態執行位置)
    /drone-runner-exec/
        /config                         # Drone exec runner (for root user)
    /exports                        # NFS 的主要設定檔
    /fstab                          # mount 掛載組態設定檔 (開機時 會依照此設定來作自動掛載; 每次使用 mount時, 預設也會動態更新此檔案)
    /firewalld/                     # OS7管理 firewalld 的組態放置區
    /gdm/                           # CentOS 預設的 DM 為 GNOME 提供的 gdm (殺小...)
        /custom.conf                    #
    /hostname                       # 主機名稱檔
    /hosts                          # ip 與 dns 對照
    /hosts.allow                    # 防火牆白名單(先)
    /hosts.deny                     # 防火牆黑名單(後)
    /httpd/                         # Apache 的組態設定檔
        /conf/                          # Apache 設定主檔dir
            httpd.conf                      # Apache 設定主檔
        /conf.d/                        # Apache 附加設定檔dir
    /init.d/                        # (CentOS6前, 所有的 服務啟動腳本) CentOS7仍在(但已經不使用 init 來管理服務了), 只剩部分東西還在這 (連結至 rc.d/init.d)
        netconsole                      # 各種模式下的 *netconsole 連結
        network                         # 各種模式下的 *network 連結至此
    /inittab                        # (舊有的 xwindow服務, os7以後, 已經被 xxx.target 所取代)
    /issue                          # 查看進站歡迎訊息(自己看得爽而已)
    /krb5.conf                      # kerberos 集中驗證 設定主檔; central keroeros 架構
    /krb5.conf.d/                   # kerberos 集中驗證 設定副檔目錄
    /letsencrypt/                   # 安裝 Certbot 後, 儲存 CSR, Certificate, PrivKey, ... 的地方
    /locale.conf                    # 系統預設語系定義檔 (一開始安裝就決定了!)
    /localtime                      # 系統時間, 可從 /usr/share/zoneinfo/Asia/Taipei 複製過來
    /login.defs                     # 建立使用者時, 該使用者的 系統愈設初始值
    /logrotate.conf                 # Journal log 的配置主檔
    /logrotate.d/
    /my.cnf                         # MySQL 組態 主要設定檔
    /nginx/                         # Nginx 組態檔目錄
        /conf.d/                        # Nginx 自訂組態目錄 (裡面的檔名要設定成 *.conf)
            /default.conf                   # Nginx 預設主機配置
        /nginx.conf                     # Nginx 主要設定檔
    /nologin                        # 如果有這個檔案的話, 用戶會被禁止登入!! 非常可怕!! 不要用!!
    /nsswitch.conf                  # 集中驗證相關; User into && Auth service 該如何被系統使用的設定檔
    /openldap/                      # 集中驗證相關
        /cacerts                        # 儲存 LDAP Server 用來驗證 SSL憑證 的 Root Certificate Authorities(CA)
        /ldap.conf                      # central LDAP Server 組態設定
    /opt/                           # 第三方協作軟體 /opt/ 的相關設定檔
    /pam.d/                         # 驗證相關; 各種服務該如何組態 Auth 的設定檔.
    /passwd                         # id 與 使用者帳號(User ID, UID) && 群組(Group ID, GID) 資訊
    /pki/                           # 公鑰存放區
        /CA/                            # 如果自己這台 Server 當成 CA, 建議把 PrivateKey && Certificate && Serial 放這邊
            /certs/                         # CA Server 的 Certificates
            /crl/                           # CA Server 簽署的 CSR 所產生的 *.crl
            /private/                       # CA Server 的 Private Keys
        /ca-trust/                      #
            /source/anchours/               # 自己信任的 CA Authority 所發放的憑證, 都放到這邊
        /rpm-gpg/*                      # rpm Repository 公鑰存放區 (rpm 檢核用的 public key)
            /RPM-GPG-KEY-CentOS-7           # CentOS7 的 原廠GPG數位簽章公鑰檔
        /tls/                           # APP Server 存放 公私鑰的 建議存放位置
            /certs/                         # APP Server 的 Certificates
            /private/                       # APP Server 的 Private Keys
    /postfix/
        /master.cf                      # Postfix mail server 主要組態設定檔
    /profile                        # 系統層面的 環境 及 起始程式
    /profile.d/
        /vim.sh                         # vim 設定檔
    /rc.d/                          # 各種執行等級的啟動腳本
        /init.d/                        #
            netconsole                      # 各種模式下的 *netconsole 連結至此
            network                         # 各種模式下的 *network 連結至此
        /rc1.d/                         # 單人維護模式
        /rc3.d/                         # 純文字模式
        /rc5.d/                         # 文字+圖形介面
            K50netconsole                   # (連結至 ../init.d/netconsole)
            S10network                      # (連結至 ../init.d/network)
    /resolv.conf                    # DNS 主機的 IP 的設定檔
    /rsyslog.conf                   # 定義 "rsyslog 服務" 應把 各種 Log 存到哪裡的組態檔
    /rsyslog.d/                     # 客製化 Log 定義組態檔, 放這邊比較好
    /selinux/                       # CentOS7 的 SELinux組態放置區
        /config                         # SELinux 組態設定檔
    /services                       # 服務 與 port 對映檔
    /shells                         # 某些服務運作時會來檢查使用者能使用的shells
    /skel/                          # 預設建立使用者後, 使用者家目錄底下的東西(會從這邊 copy 過去 new USER HOME)
    /squid/                         # Proxy Server
        /squid.config                   # squid 設定主檔
        /mime.conf                      # squid 支援 Internet 上的檔案格式(沒事別亂動)
    /ssh/
        /ssh_config                     # SSH Client 組態
        /ssh_host_*_key.pub             # SSH Server 公鑰(ecdsa, ed25519, rsa, ...)
        /sshd_config                    # SSH Server 組態
    /sssd/                          # 集中驗證相關
        /sssd.conf                      # System Security Services Daemon; 網路不通時, 從 cache 作 Login 驗證
    /subuid                         #
    /sudoers                        # 定義 sudo, wheel... 相關事項(使用 "visudo" 來取代 "vim /etc/sudoers" 的愚蠢操作!)
    /sudoers.tmp                    # 使用 visudo 指令來更改 /etc/sudoers 的安全中介檔
    /supervisord.conf               # supervisord 設定主檔 (USE supervisorctl)
    /supervisord.d/                 # supervisord 設定副檔
        /*.ini                          # supervisor 自定義
    /sysconfig/                     # CentOS6 舊時代的組態設定
        /network-scripts/               # 網路設定資料
            /ifcfg-*                        # 網卡連線設定命名規則為 "ifcfg-$CONN_NAME"
        /selinux                        # SELinux 組態設定檔 (連結至 /etc/selinux/config)
    /systemd/                       # 軟體的啟動腳本
        /journald.conf                  # journalctl 的 組態設定
        /system/                        # 依據系統所要提供的功能所撰寫的 服務腳本, 優先於 /run/systemd/system/ 及 /usr/lib/systemd/system/
    /unbound/
        /unbound.conf                   # unbound 主要設定檔 (設定 DNSSEC 使用)
    /X11/                           # X Window相關設定檔
    /xml/                           # 與 XML 格式相關的設定檔
    /zabbix/                        # 監控軟體
        /zabbix_server.conf             # Zabbix Server 設定主檔
        /zabbix_agentd.conf             # Zabbix Agent 設定主檔
/home/                          # 家目錄
/lib/                           # 系統的共用函式庫檔案 (連結至 /usr/lib/)
    /modules/                       # 可抽換式的核心相關模組(驅動程式); 不同版本的核心模組
        /3.10.0-862.el7.x86_64/         # kernel 核心版本 (可由「uname -r」取得)
            /kernel/                        #
/media/                         # 可移除的裝置; 移動式磁碟or光碟 掛載目錄 (可移除的裝置)
/mnt/                           # "暫時性" 檔案系統 掛載目錄; 現在許多裝置都移到 /media/ 了, 所以暫時的, 依舊放這
/opt/                           # 非 Linux預設安裝的外來軟體 (第三方協作軟體(非原本distribution所提供的)), 早期都習慣放在 /usr/local
/proc/                          # 虛擬檔案系統(virtual filesystem), 東西都存在於 memory, 不占用 disk; 行程資訊目錄
    /1/                             # 開機時所執行的第一支程式 systemd 的 PID=1
    /<XX PID>/                     # 某個開機後被執行的程式(or服務)
        /cgroup                         # 可得知,
        /cmdline                        # 啟動這個程序的指令, ex: python manage.py runserver
        /cwd                            # 很特別! 指向「完全獨立的 /」, 進程運行目錄 (獨立的運行空間, 裡面有/bin, /boot, /dev, /etc, ...) (chroot 的概念?)
        /exe                            # 指向上面 /cmdline 所指的 python (可執行程式) (binary)
        /environ                        # 該程序的環境變數內容
        /fd/                            # 進程打開的每個文件的 file descriptor. 指向實體文件的連結符號(握把值的概念)
        /limits                         # 進程使用資源的限制資訊
        /task/                          # 當前 進程 所包含的每個 線程 的相關資訊.
            /<某個TID1>                     # 進程之下的線程
    /cmdline                        # 系統載入 kernal 時, 所嚇得的指令與參數 (通常由 grub 來傳遞)
    /cpuinfo                        # CPU 詳細資訊 (N核心的話, 裏頭就有 N 個部分)
    /devices                        # 系統已經載入的 Block Device && Character devices(這啥?)
    /diskstats                      # Disk I/O 統計資訊清單
    /filesystems                    # 系統已載入的檔案系統(目前系統有支援的檔案系統)
    /loadavg                        # 保存了系統負載平均值(1, 5, 15 分鐘)
    /meminfo                        # free 指令查到的東西 (但這裡頭更加詳細)
    /mounts                         # 系統已掛載的檔案系統
    /net/                           #
        /dev                            # 網路封包 流入/流出/錯誤... 統計資訊 (ifconfig 看到的那些, 但這裡的東西我看不懂XD)
    /partitions                     # Linux 核心分割表資訊, 欄位分別為 major/minor/Block數量/磁區 (fdisk -l 看到的)
    /swaps                          # 目前 swap 空間
    /uptime                         # 累計開機時間(單位是啥阿~~) (uptime 看到的)
    /version                        # 當前系統版本 (uname -a 看到的)
    /vmstat                         # 目前系統 虛擬內存 的統計資訊
/run/                           # 系統開機後所產生的各項資訊 (可用記憶體來模擬); 某些服務or程式啟動後, 他們的 pid 會放在這.
    /lock/                          # 某些裝置或檔案, 一次只能一人使用, 使用中會上鎖.
    /log                            # journalctl服務(新Log機制), 預設重開機後, 只會保留最近一次開機前的 log
    /sys/                           #
        /net/                           #
            /ipv4/*                         # Linux Kernel 預設的攻擊抵擋機制
    /systemd/                       #
        /system/                        # 系統執行過程中所產生的 服務腳本, 此內腳本優先於 /usr/lib/systemd/system/
/sbin/                          # 系統管理員 用的 工具or指令or執行檔; (連結至 /usr/sbin/)
    /kdb5_util                      # kerberos 集中驗證, 依照 /etc/krb5.conf 來初始化資料庫到 /var/kerberos/krb5kdc/principal*
/srv/                           # 網路服務的一些東西 (如果不打算提供給外部網路存取的話, 建議放在 /var/lib/ )
/sys/                           # 虛擬檔案系統(virtual filesystem), 東西都存在於 memory, 不占用 disk; 紀錄核心與系統硬體資訊
/tmp/                           # 重開機後會清除
/usr/                           # (unix software resource) Linux系統安裝過程中必要的 packages (軟體安裝/執行相關); 系統剛裝完, 這裡最占空間
    /bin/                           # 一般使用者 用的 工具or指令or執行檔;
        /mysql*                         # 底下有 20 個左右的 MySQL 工具
    /games/                         # 與遊戲相關
    /include/                       # c++ 的 header 與 include 放置處; 使用 tarball 方式安裝軟體時, 會用到裡面超多東西
    /lib/                           # 系統的共用函式庫檔案
        /locale/                        # 存放語系檔
        /systemd/                       #
            /system/                        # 每個服務最主要的 啟動腳本設定 , 類似CentOS6前的 /etc/init.d 底下的東西
    /libexec/                       # 大部分的 X window 的操作指令都放這. (不被使用這慣用的執行檔or腳本)
    /local/                         # sys admin 在本機自行安裝的軟體, 建議放這邊(早期)
          /sbin/                        # 本機自行安裝的軟體所產生的系統執行檔(system binary), ex: fdisk, fsck, ifconfig, mkfs 等
          /PACKAGE/                 # (泛指任何使用者自行安裝的套件)
            /man                        # 假如使用的是 tarball 來作安裝, 要把此路徑加入到 PATH, 才能使用此套建的 man page
    /sbin/                          # 系統專用的 工具/指令/執行檔, ex: 某些伺服器軟體程式的東西
        /mysqld                         # mysqld (server)
        /sendmail                       # 老舊的寄信程式(指向 /etc/alternatives/mta, 再指向 /usr/sbin/sendmail.postfix)
    /share/                         # 唯讀架構的資料檔案; 共享文件; 幾乎都是文字檔
          /doc                          # 系統說明文件
          /man                          # 線上操作手冊
          /zoneinfo                     # 時區檔案
    /src/                           # 一般原始碼 建議放這
        /linux/                         # 核心原始碼 建議放這
/var/                           # 登錄檔, 程序檔案, MySQL資料庫檔案, ... (與系統運作過程有關); 系統開始運作後, 這會慢慢變大;
    /cache/                         # 系統運作過程的快取
        /yum/                           # yum 安裝時, 下載下來的 rpm 檔
    /kerberos/
        /krb5kdc/                       # kerberos 集中驗證 KDC 所需的資料庫環境
    /lib/                           # 程式運作過程所需用到的 資料檔案 放置的目錄. ex: MySQL DB 放在 /var/lib/mysql/; rpm DB 放在 /var/lib/rpm/
        /docker/                        # Docker 相關元件存放區
            /volumes/                       # DockerVolume 位置
        /iscsi/
            /nodes/                         # (iSCSI Client)裡面可以看到 iSCSI target 提供的 LUN
        /mysql/                         # mysql資料庫的資料儲存位置, InnoDB log && System TableSpace
            /mysql.sock                     # MySQL Connection Socket
        /postgres/                      #
            /data/                          #
                /postgresql.conf                # PostgreSQL 設定主檔
    /lock/                          # 某些裝置或檔案, 一次只能一人使用, 使用中會上鎖. (連結至 /run/lock/)
    /log/                           # rsyslog服務(舊Log機制) 放置 log 的位置, 最多保留4份檔案, daily cron 會每天來清理
        /boot.log                       # 系統開機相關
        /cron                           # 定期排程相關
        /dmesg                          # 開機時偵測硬體與啟動服務的紀錄
        /maillog                        # mail server 相關
        /messages                       # 認證相關exception, email, debugging log, 幾乎所有 syslog message 都在這
        /secure                         # security 及 authentication 相關錯誤訊息
        /yum.log                        # 使用 yum 安裝/刪除/更新 的所有紀錄
    /mail/                          # 個人電子郵件信箱的目錄. 這目錄也被放置到 /var/spool/mail/, 與之互為連結
    /run/                           # 早期 系統開機後所產生的各項資訊. (連結至 /run/)
        /docker.sock                    # Docker Server 預設監聽的位置(通訊協定)
    /spool/                         # 通常用來放 佇列(排隊等待其他程式來使用)資料(理解成 快取目錄). ex: 系統收到新信, 會放到 /var/spool/mail/ , 但使用者收下信件後, 會從此刪除
        /at/                            # 一次行 工作排程
        /anacron/
            /cron.daily                     # 最新一次執行 daily contab 的時間
            /cron.weekly                    # 最新一次執行 weekly crontab 的時間
            /cron.monthly                   # 最新一次執行 monthly crontab 的時間
        /cron/                          # 週期性 工作排程
            /root                           # root user 輸入 「crontab -l」、「crontab -e」 的時候看到的
        /mail/                          # 所有使用者的 信件資料夾集中處 ; 系通收到新信, 會放到這; 等待寄出的 email
            /root
            /tony
        /mqueue/                        # 信件寄不出去, 會塞到這
        /news/                          # 新聞群組
~/                              # 使用者家目錄 (/home/<User>/)
    /.aws/credentials               # aws CLI 組態位置
    /.bashrc                        # 使用者層面的 functions 及 alias 及 自定義 variables
    /.bash_history                  # 上次登出前, 在 Shell 內下過的指令(域設存1000筆), 登出後才會寫入此檔
    /.bash_login                    #
    /.bash_logout                   #
    /.bash_profile                  # 使用著層次的 環境 及 起始程式(Login Shell 才會讀取)
    /.drone-runner-exec/
        /config                         # drone exec runner 使用者自己的配置檔
```

## proc

- in-memory pseudo-file system
- Linux 的控制中心
- 可透過裏頭的文件, 來查找相關系統硬體, 當前正在運行進程的訊息.
- 裏頭檔案名稱為 `數字的目錄`(ps 的 id), 保存的是 `進程的訊息`.
- 可透過判讀 /proc 底下的 `數字的目錄` 數量, 來判斷 `當前系統的進程數量`

```python
### python 監控, 目前有多少進程數量
python
import os
pids = [item for item in os.listdir('/proc') if item.isdigit()]
len(pids)
# 397
```

```bash
### 獲得系統的啟動參數
$# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-3.10.0-862.el7.x86_64 root=/dev/mapper/centos-root ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet LANG=en_US.UTF-8
```
