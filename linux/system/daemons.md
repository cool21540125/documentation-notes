# 系統服務 daemons
- 2018/07/31

`/etc/init.d/*` 這舊時代的 `systemV` 已經被新一代的 `systemd` 取代了



# SystemV (CentOS6以前) 的 init 管理

init 分類:
- 獨立啟動
- 被一支總管程式管理

系統為了某些功能, 需要提供一些 `服務 service` , 達成 服務的 `程式` , 又稱之為 `daemon` (CentOS6以前, 放在 `/etc/init.d`)
- 啟動 : `/etc/init.d/daemon start`
- 停止 : `/etc/init.d/daemon stop`
- 重啟 : `/etc/init.d/daemon restart`
- 看狀態 : `/etc/init.d/daemon status`


服務的區分:
1. 獨立啟動 (stand alone) : 常駐在記憶體裡面... 速度很快
2. 被其他服務管理 (super daemon) : 由 `xinetd` 或 `inetd` 提供 `Unix Socket` 或 `TCP Socket(port)` 來對映管理. 用戶要求時, 總管才會去喚醒相對應的服務程式. (會比較慢啊)


設定預設開機啟動
- `chkconfig daemon on`
- `chkconfig daemon off`
- `chkconfig --list daemon`


系統等級切換

```sh
# 切換到文字介面
$ init 3

# 切換到圖形介面
$ init 5
```



# Systemd 系統服務管理

- 每個`服務`都是一個 Unit
- Target 代表一個`階段標的`, 訂定在某個階段需要啟動什麼 Unit
- 服務的啟動是依照系統啟動的「runlevel 執行階段」訂定的
- `systemd 的 Target` 取代 `init 的 runlevel`


 `systemd` 設定檔存放位置, 讀取順序:

1. `/etc/systemd/system/` : 依據系統所要提供的功能所撰寫的服務腳本
2. `/run/systemd/system/` : 系統執行過程中, 產生的服務腳本
3. `/usr/lib/systemd/system/` : 每個服務最主要的`啟動腳本設定檔` (類似早期的 `/etc/init.d/`) (<font color="red">寫好的 service 應該放這邊</font>)


systemd定義所有的服務為 `一個服務單位(unit)`, 並將該 `unit` 依照 `副檔名` 歸類為各種 `類型(type)`


extensions | Desciption
---------- | ---------------
.service   | `一般服務類型(service unit)` ; 主要都是`系統服務` ; 背景執行(速度快)
.socket    | `內部程序資料交換的插槽服務(socket unit)` ; 不同程序之間資料的傳輸管道. 主要是 `IPC(Inter-process communication)` 的 `socket file` ; client連線時才啟動(速度慢)
.target    | `執行環境類型(target unit)` ; 一整包的 units : ['.target', '.socket', ...]
.mount<br>.automount | 檔案系統掛載相關的服務
.path      | 偵測特定檔案或目錄類型 `path unit`, 提供 `佇列服務`
.timer     | 循環執行的服務


## - Linux 新舊時代的 `systemV 系統服務管理`

systemd                             | SysV init
----------------------------------- | ------------------------
新一代的系統服務管理                | 舊有的服務管理
由「Unit 服務」「Target 標的」構成  | ????


## - 常見服務及說明

Service Name             | Description
------------------------ | -----------------------------
atd.service              | 一次行排程
crond.service            | 週期性排程
NetworkManager.service   | 動態網路連線設定管理器
network.target           | 固定式網路管理服務
sysinit.target           | 系統服務
quotacheck.service       | 硬碟配額檢查服務
syslog.service           | 系統日誌管理服務 (old)
sendmail.service         | 電子郵件伺服器服務
smartd.service           | 硬碟健康狀態回報服務
sshd.service             | 加密的遠端登入服務
httpd.service            | 網頁伺服器服務
cups.socket              | 列印伺服器服務


## systemd 服務 ( Unit , Target )

### Unit 服務 - 標準文字檔紀錄服務資訊

```sh
# 查看系統「一次行排程服務 atd」
$ cat /etc/systemd/system/multi-user.target.wants/atd.service

[Unit]
Description=Job spooling tools                          #
After=syslog.target systemd-user-sessions.service       # 在哪個服務之後啟動

[Service]
EnvironmentFile=/etc/sysconfig/atd                      # 執行環境檔
ExecStart=/usr/sbin/atd -f $OPTS                        # 執行時的指令
IgnoreSIGPIPE=no                                        # 
# Environment="XXX"  可以使用來設定環境變數, 而且可以多行 Environment
# Environment="PYTHONPATH=xxx"

[Install]
WantedBy=multi-user.target                              # 在多人模式時啟動
### 每個 Unit描述檔, 都一定會有上面3個段落
```


### Target (階段)標的 - 在某個階段時, 需啟動什麼服務

系統重要的 target
Series | target name       | Description
:-----:|:-----------------:| ---------------------------
1      | sysinit.target    | 確保系統檔案完整啟動
2      | basic.target      | 系統啟動後自動進入的模式, *multi-user.target*的依賴模式
3      | multi-user.target | 多人文字模式, 同 init 的 runlevel3
4      | graphical.target  | 圖形界面, 同 init 的 runlevel5
5      | default.target    | 系統預設的模式(連結符號), 大都連結到 *multi-user* 或 *graphical*

```sh
# 查看系統的 default.target -> graphical.target
$ cat /etc/systemd/system/default.target
[Unit]
Description=Graphical Interface                                               # 說明
Documentation=man:systemd.special(7)                                          # 標的文件
Requires=multi-user.target                                                    # 執行前依賴對象, 若此對象被停止, 則本項目也會停止
Wants=display-manager.service                                                 # 若本項目被啟動, 則 Wants的對象也會啟動
Conflicts=rescue.service rescue.target                                        # 本階段標的與 rescue.target不相容
After=multi-user.target rescue.service rescue.target display-manager.service  # 圖形界面階段之前, 應先進入多人模式階段
AllowIsolate=yes                                                              # 此項目可否在 systemctl isolate之後使用(類似舊有的 init runlevel)
```

```sh
# 馬上切換到 runlevel3 (多人命令模式)
$ sudo systemctl isolate multi-user.target

# 馬上切換到 runlevel5 (圖形界面)
$ sudo systemctl isolate graphical.target
```


# CentOS7服務相關指令 && 狀態意義

```sh
# 啟動與關閉<service>
$ systemctl start <service>
$ systemctl stop <service>

# 重新啟動相關
$ systemctl reload <service>    # 不關閉服務的前提下, 重載組態
$ systemctl restart <service>   # 服務關掉後再啟動

# 重新開機後生效<service>
$ systemctl enable <service>
$ systemctl disable <service>

# 列出所有 Unit Type = service 的 Daemons
$ systemctl        list-units   --type=service
# CommandUtility   SubCommand   Option
```

daemon重啟狀態 (Loaded 最後面)
- enabled : 重啟後使用
- disabled : 重啟後不使用
- static : 此服務不可自行啟動, 但會被其他 enabled 的服務呼喚
- mask : 無法被啟動的服務(已經被註銷) ; 可使用 `systemctl unmask xxx` 恢復

daemon相關狀態 (Active 括號內)
- active (running) : 持續運行中的程序
- active (exited) : 沒有常駐在記憶體, 執行一次就結束了的服務
- active (waiting) : 執行中, 但在等待其他事件才會繼續處理
- inactive


```sh
# 列出所有 systemd 裡頭, 正在監聽本機 的 socket files
$ systemctl list-sockets
LISTEN                  UNIT                       ACTIVATES
/dev/log                systemd-journald.socket    systemd-journald.service
/run/dmeventd-client    dm-event.socket            dm-event.service
# ... 約10~30個 sockets ...
```

```sh
# 查看啟用失敗的程序
$ systemctl --failed --type=service
  UNIT          LOAD   ACTIVE SUB    DESCRIPTION
● kdump.service loaded failed failed Crash recovery kernel arming

LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.

1 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
# kdump 好像是虛擬機相關的東西, 需要耗費大量RAM, 而這台NB才 4G RAM, 所以會啟用失敗
```

```sh
# 系統服務 與 port 對映檔
$ cat -n 2 /etc/services
# 服務名稱       埠號/協定                       # 說明
# service-name  port/protocol  [aliases ...]   [# comment]
ssh             22/tcp                          # The Secure Shell (SSH) Protocol
ssh             22/udp                          # The Secure Shell (SSH) Protocol
http            80/tcp          www www-http    # WorldWideWeb HTTP
http            80/udp          www www-http    # HyperText Transfer Protocol
http            80/sctp                         # HyperText Transfer Protocol
https           443/tcp                         # http protocol over TLS/SSL
https           443/udp                         # http protocol over TLS/SSL
https           443/sctp                        # http protocol over TLS/SSL
mysql           3306/tcp                        # MySQL
mysql           3306/udp                        # MySQL
# ...(僅節錄部分)...
```
