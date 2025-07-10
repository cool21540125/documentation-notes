# Linux 架設 DNS - bind

```bash
yum install -y bind bind-chroot bind-utils
firewall-cmd --add-service=dns
systemctl start named

### -------------------------------------
#/etc/
#    /named.conf                 # DNS 設定主檔
#    /named.rfc1912.zones        # Named Server 管轄網域設定檔, 內含各網域的設定值區段
#    /sysconfig/
#        /named                      # 是否啟動 chroot 及額外參數 的控制檔案 (不知道在幹嘛...)
#/usr
#    /sbin/
#        /named                      # named 服務執行檔
#/var
#    /log/
#        /named.log                      # DNS Log
#    /named                          # 所有 "管轄網域" 的資源紀錄資料庫 預設目錄
#        /chroot/                        # 使用 bind-chroot 「禁錮bind」機制後, bind 的新根目錄
#            /dev/
#            /etc/
#            /run/
#            /usr/
#            /var/
#        /data/
#        /dynamic/
#        /named.ca
#        /named.localhost
#        /named.loopback
#        /slaves/
#    /run
#        /named/                         # named 程式執行時的 pid file 放置位置
### -------------------------------------
```

```bash
### /etc/named.conf     named 設定主檔
cat /etc/named.conf
#options {
#    listen-on port 53 { any; };     # 不設定代表接受全部
#    directory       "/var/named";   # RR 預設放置的目錄
#    allow-query     { any; };       # 不設定代表接收全部 ; 誰可以對我(DNS) 作查詢
#    recursion yes;                  # DNS Client 向 DNS Server 查詢的模式
#    forward only;                   # 我的 DNS 僅作 forward (如此以來就不會用到「.」了)
#    allow-transfer { none; };       # 除非作成 master/slave DNS架構, 否則就設定為 none
#    forwarders {                    # 設定 「forward only」後, 要前往查詢的位置
#        192.168.124.115;            # 目前網段使用的 DNS
#        192.168.124.116;            # 目前網段使用的備用 DNS
#        168.95.1.1;                 # 進行轉遞的位置(中華電信快取 DNS)
#    };
# ↑ 僅節錄部分
```
