
# 常見系統環境變數

 env variables  | description
 -------------- | -----------------
 $HOSTNAME      | tonynb
 $HOME          | /home/tony
 $PWD           | 目前位置
 $PATH          | ...(一大堆)...
 $USER          | tony
 $UID           | 1000
 $LANG          | en_US.UTF-8
 $RANDOM        | 0~32767整數亂數
 $?             | 上次指令結束後的狀態碼 (0:true, 1:false)
 $EUID          | 系統決定用戶對系統資源的訪問權限, 通常等同於 RUID
 $RUID          | 系統用來辨識用戶是誰. 用戶登入到 Unix 以後, 就確定了目前的 RUID


# Linux 時間

```sh
### Linux 檔案時間
$ ll /etc/man_db.conf; ll --time=atime /etc/man_db.conf ; ll --time=ctime /etc/man_db.conf
-rw-r--r--. 1 root root 5171  6月 10  2014 /etc/man_db.conf     # 內容最後變動時間 (預設使用 mtime)
-rw-r--r--. 1 root root 5171  7月  8 19:33 /etc/man_db.conf     # 狀態最後變動時間
-rw-r--r--. 1 root root 5171  2月 27 14:05 /etc/man_db.conf     # 內容最近讀取時間


### date 用法
touch bck_`date +\%H\%M`.sql
#bck_1608.sql


### timestamp 轉 datetime
date "+%Y-%m-%d %H:%M:%S" --date=@1565596800
#2019-08-12 16:00:00
```


# shell內

hotkey | description
------ | -----------
Ctrl+C | 中斷目前工作 ; 終止目前命令
Ctrl+D | 送出eof or 輸入結束特殊字元
Ctrl+Z | 暫停目前工作, 利用 `fg` 指令, 可以取得暫停的工作


## 測試硬碟讀取效能

```sh
# 檢測硬碟讀取效能
$ sudo hdparm -Tt /dev/sda
[sudo] password for tony:

/dev/sda:
 Timing cached reads:   14942 MB in  2.00 seconds = 7478.28 MB/sec
 Timing buffered disk reads: 344 MB in  3.01 seconds = 114.20 MB/sec
# 至於, 這數字實際代表意義是啥... 我目前沒概念= =
```



## 顯示年曆

```bash
$# cal 2020
                               2020

       January               February                 March
Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
          1  2  3  4                      1    1  2  3  4  5  6  7
 5  6  7  8  9 10 11    2  3  4  5  6  7  8    8  9 10 11 12 13 14
12 13 14 15 16 17 18    9 10 11 12 13 14 15   15 16 17 18 19 20 21
19 20 21 22 23 24 25   16 17 18 19 20 21 22   22 23 24 25 26 27 28
26 27 28 29 30 31      23 24 25 26 27 28 29   29 30 31

        April                   May                   June
Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
          1  2  3  4                   1  2       1  2  3  4  5  6
 5  6  7  8  9 10 11    3  4  5  6  7  8  9    7  8  9 10 11 12 13
12 13 14 15 16 17 18   10 11 12 13 14 15 16   14 15 16 17 18 19 20
19 20 21 22 23 24 25   17 18 19 20 21 22 23   21 22 23 24 25 26 27
26 27 28 29 30         24 25 26 27 28 29 30   28 29 30
                       31
        July                  August                September
Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
          1  2  3  4                      1          1  2  3  4  5
 5  6  7  8  9 10 11    2  3  4  5  6  7  8    6  7  8  9 10 11 12
12 13 14 15 16 17 18    9 10 11 12 13 14 15   13 14 15 16 17 18 19
19 20 21 22 23 24 25   16 17 18 19 20 21 22   20 21 22 23 24 25 26
26 27 28 29 30 31      23 24 25 26 27 28 29   27 28 29 30
                       30 31
       October               November               December
Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa   Su Mo Tu We Th Fr Sa
             1  2  3    1  2  3  4  5  6  7          1  2  3  4  5
 4  5  6  7  8  9 10    8  9 10 11 12 13 14    6  7  8  9 10 11 12
11 12 13 14 15 16 17   15 16 17 18 19 20 21   13 14 15 16 17 18 19
18 19 20 21 22 23 24   22 23 24 25 26 27 28   20 21 22 23 24 25 26
25 26 27 28 29 30 31   29 30                  27 28 29 30 31

$#
```


## 誰在線上

```sh
$ who
tony     :0           2018-03-01 15:34 (:0)
tony     pts/0        2018-03-02 13:58 (:0)
tony     pts/2        2018-03-02 14:06 (:0)
#誰在線上 (未知)       登入時間          (來源ip)

$ w
 14:45:41 up 1 day, 1 min,  3 users,  load average: 0.08, 0.05, 0.14
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
tony     :0       :0               Thu15   ?xdm?  28:40   0.44s gdm-session-worker [pam/gdm-password]
tony     pts/0    :0               13:58   18:13   2.76s  2.69s top
tony     pts/2    :0               14:06   18:13   0.26s  0.12s bash
# 可以多看使用者停頓時間, 佔用CPU運算資源時間, 正在執行的工作名稱...
```



# chown

```sh
# 10分鐘後關機
$ sudo shutdown -h +10

# 15分鐘後重新開機
$ sudo shutdown -r +15

# 點選視窗後,就可以把相關程序殺掉(GUI專用)
$ xkill

# 使用預設的 15訊號, 讓 terminal結束訊號
$ kill 8888

# 使用系統的 9訊號(KILL訊號), 強制結束(強制關閉 強制終止)
$ kill -9 8888

# 刪除所有 httpd服務
$ killall httpd

# 只顯示軟連結(-R為 recursive)
$ ll -R <path> | grep "\->"

# 搜尋 PATH內的執行檔 (完整檔名)
$ which python
/opt/anaconda3/bin/python

# 搜尋檔案的 fullpath (完整檔名)
$ whereis python
python: /usr/bin/python /usr/bin/python2.7 /usr/lib/python2.7 /usr/lib64/python2.7 /etc/python /usr/include/python2.7 /opt/anaconda3/bin/python /opt/anaconda3/bin/python3.6-config /opt/anaconda3/bin/python3.6m /opt/anaconda3/bin/python3.6 /opt/anaconda3/bin/python3.6m-config /usr/share/man/man1/python.1.gz

# 更新檔案系統資料庫 /var/lib/mlocate/mlocate.db
$ sudo updatedb

# 同上, 但採用背景執行
$ sudo updatedb &

# 到 /var/lib/mlocate/mlocate.db 查詢 (片段檔名)
$ locate ifconf # 要查詢的東西, 檔名可以不完整
```


# su 這東西

- 2018/07/08
- [換人做做看 --sudo 和 su](http://kezeodsnx.pixnet.net/blog/post/25810396-%E6%8F%9B%E4%BA%BA%E5%81%9A%E5%81%9A%E7%9C%8B--sudo-%E5%92%8C-su)

```sh
# 使用 「sudo su」
[tony@tonynb ~]$ sudo su
[sudo] password for tony:   # 輸入 tony 的 admin 密碼~
[root@tonynb tony]# exit
[tony@tonynb ~]$

# 使用 「su」
[tony@tonynb ~]$ su
密碼：                      # 輸入 root 密碼~
[root@tonynb tony]# exit
[tony@tonynb ~]$
```



# sshd (CentOS 7 已內建 && 預設啟動)

```sh
# 產生ssh公私金鑰
ssh-keygen -t rsa -b 4096 -C "tony@tonynb" -f "key_name"
# -t [rsa|tsa] : 加密演算法
# -b <number> : 加密位元數, 建議都 2048 以上
# -C <xxx> : keygen 名稱


### ed25519 (比 rsa 更有效率 && 安全)
# https://docs.gitlab.com/ee/ssh/README.html#ed25519-ssh-keys
$# ssh-keygen -t ed25519 -C "tony@tonynb"
# 產生 id_ed25519 && id_ed25519.pub
```

1. 安裝sshd
```sh
$ sudo yum -y install openssh-server
$ systemctl start sshd
```

2. 檢查看看(應該要有下面兩個)
```sh
$ ps -e | grep ssh
xxxx ? 00:00:00 sshd
xxxx ? 00:00:00 ssh-agent
# CentOS7 的 圖形話介面, 預設啟用 ssh-agent
```

3. 若出現下列狀況
```sh
$ ssh localhost
ssh: connect to host localhost port 22: Connection refused
# 請先依照第2點的說明查看是否有啟動 ssh-agent 及 sshd 才可以 ssh localhost, 所以只要
$ sudo service sshd restart
$ sudo systemctl enable sshd(這個還不是非常確定是否可行)
```


## 若發現無法啟動, 可能原因如下 (應該不會有 sys-admin這樣作吧?)

1. sshd 被砍了~
2. sshd 被關閉了~
3. 防火牆擋住了~



# SSH 概念說明

每次作 ssh 連線時, 會作 2 件事情 :
1. 建立加密連線通道 (set up the secure encryption for the communication channel)
2. 對 Server 作驗證 (authenticate the server)

> Client 使用 `ssh-keygen` 時, 比較明智的做法是使用 passphrase(密語), 但如此一來, 每每要動到 `private key` 時, 都得輸入 `passphrase`, 相當麻煩, 因此有了 `ssh-agent` 幫忙作代理, 只需要首次使用時, 輸入 passphrase, 日後就不再需要輸入 passphrase 了!

> 客戶端 **每次** ssh 到 Server 時, Server 都會給客戶端它的 `public key`; 客戶端再找出自己的 `~/.ssh/known_hosts` 裏頭該 Server 的 `public key` 來比對看看是否 public key 有改變過, 若改變過(可能客戶端 restart sshd 或者 網路遭到劫持...), 則無法 ssh. [解法: 砍掉該 Server 的 known_hosts 裏頭的 public key, 再重連(假設沒遭到crack入侵的話)] ; 而客戶端會把自己的 `public key` 丟到 Server端的 `~/.ssh/authorized_keys`

> 然而每次 Client ssh 到 Server 都得打密碼太麻煩了, 所以乾脆直接讓 Server 認識 Client 就好了啊!! 因此 Client 可以使用 `ssh-copy-id <remote user id>@<remote host>` 把自己的 `public key` 都給 Server(預設會 Copy `~/.ssh/id_rsa.pub`), 日後 ssh 到 Server 後, Server 會主動將該 Client 的 public key 從 Server 的 `~/.ssh/authorized_keys` 取出來, 去要求 Client 作 公私鑰比對認證,


### 權限部分
- *private key*                    : 600
- *public key*                     : 644
- *~/.ssh(Client)*                 : 700
- *~/.ssh/authorized_keys(Server)* : 600



## ※安全觀點 : sshd 組態 /etc/ssh/sshd_config

組態更改後, 需要 `systemctl restart sshd`

```ini
# PermitRootLogin yes                   # 禁止 ssh root
# PermitRootLogin without-password      # 折衷方案, 禁止 root 使用密碼登入
PermitRootLogin no                      # (預設) 未禁止 ssh root

#PasswordAuthentication yes             # 禁止 使用密碼來作 ssh
PasswordAuthentication yes              # (預設) 未禁止 使用密碼來作 ssh
# ↑ 很重要! 作這之前, 記得先丟 ssh-copy-id 阿~~ 不然登出後就進不來了
```


## SSH 若關閉密碼驗證

```sh
# 私鑰 登入
$ ssh -i <私鑰憑證> user@IP

# 對於僅能使用 key 登入的機器(禁止密碼驗證), 可用此方式來傳遞 public key
$ cat ~/.ssh/id_rsa.pub | ssh -i <私鑰憑證> user@IP "cat - >> ~/.ssh/authorized_keys"
```


# 查看誰登入

```sh
# 可看到 誰從哪裡登近來, 然後在幹嘛
$ w
 20:01:47 up  1:19,  2 users,  load average: 0.02, 0.07, 0.12
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
tony     :0       :0               18:43   ?xdm?   1:21   0.21s /usr/libexec/gnome-session-binary --session gnome-c
tony     pts/0    192.168.124.101  18:46    3.00s  0.19s  0.02s w
# TTY : 「:0」 為 圖形化介面
# TTY : 「pts/0」 為 pseudo-terminal 登入
# FROM : 從哪裡來的

```




# 開啟 port並設定防火牆

- 2018/02/19
- [CentOS 7 設定防火牆允許特定 PORT 連線](https://blog.yowko.com/2017/09/centos-7-firewall.html?m=1)

> 語法: `firewall-cmd --zone=public --add-port=3333/tcp --permanent`  對外永久開放 3333 port, 支援 TCP連線

> `firewall-cmd --reload` 重新讀取 firewall設定
```sh
# 看看 FirewallD是否執行中
$ firewall-cmd --state
running

# 列出目前已設定的 zone
$ firewall-cmd --get-active-zone
public                          # 主機的防火牆設定為「公開場所」
  interfaces: wlp2s0            # 網路介面卡

# 列出 public這個 zone的詳細防火牆資訊
$ firewall-cmd --zone=public --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: wlp2s0
  sources:
  services: dhcpv6-client ssh
  ports:
  protocols:
  masquerade: no
  forward-ports:
  sourceports:
  icmp-blocks:
  rich rules:

# 所有可選擇的 zones
$ firewall-cmd --get-zones
work drop internal external trusted home dmz public block

# 開啟 port, 可接收外界連線請求
$ firewall-cmd --zone=public --add-port=3333/tcp
success

$ firewall-cmd --zone=public --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: wlp2s0
  sources:
  services: dhcpv6-client ssh
  ports: 3333/tcp                  # <--- 對外開放了
  protocols:
  masquerade: no
  forward-ports:
  sourceports:
  icmp-blocks:
  rich rules:
```

#### 防火牆嚴謹度, 由高到低
ser | zone名稱 | desc
--- | -------- | -----
1   | public   | 不信任網域內的所有主機, 只有被允許的連線才能進入
2   | external | 同 public, 但用於 IP偽裝的 NAT環境
3   | dmz      | 主機位於 DMZ區域, 對外部為開放狀態, 對內部網路存取有限制的網路環境, 只有被允許的連線才能進入
4   | work     | 工作場合(信任大多數同網域的主機), 只有被允許的才能連入
5   | home     | 家用場合(信任同網域的主機), 只有被允許的才能連入
6   | internal | 內部網路(信任同網域的主機), 只有被允許的才能連入
7   | trusted  | 允許所有網路連線

#### 有關封包處置的 zone
ser | zone名稱 | desc
--- | -------- | -----
1   | drop     | 丟棄所有 incoming的封包(不回應任何資訊), 只會有 outgoing的連線
2   | block    | 阻擋所有 incoming的封包, 並以 `icmp`回覆對方, 只有從本機發出的連線是被允許的

> 永久套用設定的語法: `firewall-cmd --permanent --zone=dmz --change-interface=ens0s3`
```sh
$ firewall-cmd --get-active-zone
public
  interfaces: wlp2s0

# 指定 zone所使用的網路界面
$ firewall-cmd --zone=home --change-interface=wlp2s0
The interface is under control of NetworkManager, setting zone to 'home'.
success

$ firewall-cmd --reload         # 重新讀取設定檔
$ firewall-cmd --get-active-zone
public
  interfaces: ens0s3 wlp2s0

# 永久改變
$ firewall-cmd --permanent --zone=dmz --change-interface=ens0s3
```

Service服務在 FirewallD中代表 1~多個 port所組成的一個服務.
(一個 service可包含多個 port或 protocal)

> ex: `ssh服務代表 22/TCP`; `mysql服務代表 3306/TCP`
```sh
# 取得所有已通過防火牆的服務
$ firewall-cmd --get-services
dns docker-registry ftp https mysql smtp ssh telnet ...(略)...
# 這些 services定義在 /usr/lib/firewalld/services/
```

### 允許通過防火牆 FirewallD
> service可過防火牆, 語法: `firewall-cmd --zone=<zone名稱> --add-service=<服務名稱>`

> port可通過防火牆, 語法: `firewall-cmd --zone=<zone名稱> --add-port=<port>/<協定>`
```sh
# 查看 public的防火牆設定
$ firewall-cmd --zone=public --list-all
public (active)
  ...(略)...
  services: dhcpv6-client ssh
  ...(略)...

# 防火牆允許 http服務(永久)
$ firewall-cmd --permanent --add-service=http

# ex: 某主機是公司的 DNS Server, 則應在 zone中加入 dns service
$ firewall-cmd --zone=public --add-service=dns
success

$ firewall-cmd --zone=public --list-all
public (active)
  ...(略)...
  services: dhcpv6-client dns ssh           # 多了 dns
  ...(略)...

# 永久允許 3333/tcp通過 public的防火牆
$ firewall-cmd --zone=public --add-port=3333/tcp --permanent
success

$ firewall-cmd --zone=public --list-all
public (active)
  ...(略)...
  ports: 3333/tcp                           # 3333/tcp
  ...(略)...
```



---
## 目前使用者
[Get current user name in bash](https://stackoverflow.com/questions/19306771/get-current-users-username-in-bash)
```sh
$ echo $USER
tonynb

$ whoami
tonynb

$ logname
tonynb

# 查看使用者
$ id
uid=1000(tonynb) gid=1000(tonynb) groups=1000(tonynb),10(wheel),983(docker) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

# 看其他使用者 (只能看到基本資訊)
 id root
uid=0(root) gid=0(root) groups=0(root)

$

$ id -u
1000

$ id -u -n
tonynb
```

呼叫目前使用者群組 user group
```sh
$ id -g -n
tonynb
```


---
## source 與 bash
- [鳥哥 - bash 與 source](http://linux.vbird.org/linux_basic/0340bashshell-scripts.php#script_run)

1. 建立一個檔案, 名為 urname.sh, 內容如下 :
```sh
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Your name : " name      # 提示使用者輸入
read -p "Your age :  " age       # 提示使用者輸入
echo "Your full name and age : ${name} ${age}" # 結果由螢幕輸出
```

2. 執行看看~
```sh
# 使用 sh 執行
$ echo ${name} ${age}
                                # 因為沒有這個環境變數, 所以啥都沒有, 這很正常
$ sh urname.sh  # 方法一
Your name : tony                     # <--- 輸入
Your age :  30                       # <--- 輸入
Your full name and age : tony 30     # 輸出結果

$ echo ${firstname} ${age}
                                # 一樣是空的哦~~~啥都沒有!! 因為剛剛的執行環境是 子bash

# 使用 source 執行
$ source urname.sh  # 方法二
Your name : tony
Your age :  30
Your full name and age : tony 30

$ echo ${firstname} ${age}
tony 30                         # 東西出現啦~~~~  只要此 terminal沒關, 這環境變數會一直存在
```


---
## 寫 shell script / bash script
範例1
```sh
# 寫 script
$ vi ex1.sh
n1=10
n2=15
test $n1 -eq $n2

$ chmod +x ex1.sh
$ ./ex1.sh
$ echo $?
1
```

範例2
```sh
# 寫 script
$ vi ex2.sh
n1=$1       # 第一個參數
n2=$2       # 第二個參數
echo $n1 -eq $n2

$ chmod +x ex2.sh
$ ./ex2.sh 30 40    # 給參數
$ echo $?
1

$ ./ex2.sh 40 40    # 給參數
$ echo $?
0
```

範例3
```sh
$ vi ex3.sh
n1=$1
n2=$2
if test $n1 -gt $n2   # if 參數1 > 參數2
  then
    echo "n1:$n1 is bigger than n2:$n2"
  else
    echo "n1:$n1 is not bigger than n2:$n2"
fi

$ chmod +x ex3.sh
$ ./ex3.sh 30 40
n1:30 is not bigger than n2:40
```

範例4
```sh
$ vi ex4.sh
for n in `seq 1 3`  # 重音符號「``」內, 優先執行
do
  echo $n
done
# (後略)
```

範例5
```sh
$ vi ex5.sh
for n in `ls`
do
  echo $n
done
# (後略)
```


## 其他不知道怎嚜分類

> `/proc`內部幾乎都是虛擬檔案(唯獨), 少數系統設定值可修改
```sh
$ cat /proc/sys/kernel/hostname
localhost.localdomain

$ echo "tonynb" > /proc/sys/kernel/hostname     # 要進到 su才可, 無法 sudo
# 此檔案權限為 -rw-r--r--. 1 root root 0
# 更改主機名稱就會變成 tonynb
```

### less 與 more
```sh
$ ll /dev | more
# more只能往下頁

$ ll /dev | less
# less可搜尋, 到第幾行, 往上頁, 往下頁
```
> 語法: `less <options> <file>`

options | description
------- | --------------
-m      | 顯示類似 more的百分比
-N      | 顯示 line number
/\<str> | 搜尋特定文字(向下找)
n       | 使用 / 後, 向下找
N       | 使用 / 後, 向上找
h       | 顯示 help介面


### 計數(word count) - wc

```sh
# wc -[lwc] <file>  Line, Word, Character
$ wc .bashrc
118  520 3809 .bashrc
# 檔案內有 118行, 520個字節數, 3809 Byte Counts
```

### 取代/刪除字元 - tr
```sh
$ echo "ABCDEFG"
ABCDEFG

$ echo "ABCDEFG" | tr ABC xyz
xyzDEFG

$ echo "ABCDEFG" | tr [:upper:] [:lower:]
abcdefg

$ echo "ABC" | tr -d 'A'
BC
```

### 跨主機複製 - scp

- Local 複製到 Remote : `scp <要複製的檔案> <要放置的id>@<要放置的host>:<放在哪邊>`
- Remote 複製到 Local : `scp <要複製的來源id>@<來源host>:<檔案絕對路徑> <放置位置>`

```sh
$ scp requirement.txt tony@192.168.124.81:/home/tony/tmp
# 把 requirement.txt 丟到 tony@192.168.124.81的 /home/tony/tmp裏頭

$ scp tony@192.168.124.81:/home/tony/tmp/requirement.txt .
# 把 tony@192.168.124.81 內的 /home/tony/tmp/requirement.txt 複製到目前目錄底下
```

### 產生序列數字 - seq
```sh
$ seq 1 2 7
1
3
5
7

# 補上「0」讓它們等寬
$ seq -w 1 2 7
01
03
05
07
```

### 排序 - sort
```sh
$ cat doc1
031
2
1345
001

# 預設逐字依照 ascii排序
$ sort doc1
001
031
1345
2

# -g: 嘗試以數字排序
$ sort -g doc1
001
2
031
1345
```

### 過濾重複 - uniq
> 將檔案中, `相鄰且重複`的多行資料, 取 set, 確保唯一 <br>
> 搭配 `sort`, 語法: `sort <檔案> | uniq`


### 同行拆解 && 擷取子字串 - cut (對不特定多空白格很沒輒...)

> 預設處理以「tab分隔」的檔案, 用 `-d` 指定分隔符號, `-f` 指定要取出的欄位

```sh
$ cut -d '分隔字元' -f NN /home/tony/file1
# -d : delimiter
# -f : 根據 delimiter, 取出第 NN 欄位

$ cut -c 字元區間
# -c : (ex: -c 8- 表示取第8個字以後)

$ cat doc2
tom,22,31000
jack,21,29500
eric,18,42000

$ cut -d ',' -f2 doc2
22
21
18

# 取出 $PATH 的第三個欄位資料
$ echo ${PATH} | cut -d ':' -f3
```


### 模式搜尋 - grep

```sh
$ grep -cinv '字串' file
# -c : 計算找到的次數
# -i : case-insenstive
# -n : Line Number
# -v : 反向選擇

$ grep --color=auto tony /home/tony/user
# 可以把 grep 找到的東西, 用顏色漂亮的列出來~~


```


### 主機名稱 - hostname
> 設定主機名稱, 重新登入後開始生效, 語法: `set-hostname <新的 hostname名稱>`
```sh
$ hostname
tony

$ hostnamectl

```

### 別名 - alias
> 底下的設定, 登出後就無效了, 因此可將別名設到 `.bashrc` 或 `/etc/profile(不建議)` 之中.
```sh
$ alias
alias ll='ls -alF'
alias ls='ls --color=auto'
...(很多別名)...

$ alias dv='du -sh /var'
# 自行設定別名

$ unalias dv
# 刪除別名
```


### type - 查指令特性
```sh
# type 主要在找出 執行檔 (而非一般檔案名稱)
$ type ls
ls is aliased to 'ls --color=auto'

$ type -t ls
alias

$ type -a ls
ls is aliased to 'ls --color=auto'
ls is /bin/ls
ls is /usr/bin/ls
```

### echo

「echo -e」 用法

```sh
#### 範例 1
$ echo "L1\nL2\nL3"
L1\nL2\nL3

# 讓特殊字元作用
$ echo -e "L1\nL2\nL3"
L1
L2
L3


#### 範例2
$# GREEN='\033[1;32m'
$# echo -e "${GREEN}印出的字會是綠色的"
印出的字會是綠色的  # <-- 綠色的
```



### 互動式 input - read
```sh
# read [-pt] variable
# -p xxx: 提示字元
# -t xxx: 等待秒數

$ read n
88   # 自行輸入

$ echo $n
88
```

### ls
[ls查看目錄內容](http://blog.xuite.net/altohorn/linux/17259902-ls+%E5%88%97%E5%87%BA%E7%9B%AE%E9%8C%84%E5%85%A7%E5%AE%B9)
> 語法: `ls [options] <檔案or資料夾>`

```sh
$ ls -i     # 列出 inode
$ ls -s     # 列出檔案大小
$ ls -R     # Recursive (遞回列出)
$ ls -r     # 反向排序
$ ls -h     # 檔案內容以 KB, MB, GB顯示
$ ls -d     # 只顯示 directory
$ ls -t     # 依時間排序
$ ls -S     # 依檔案大小排序
$ ls -F     # 附加資料結構, *: 可執行檔; /: 目錄; =: socket檔案; |: FIFO檔案;
$ ls -n     # 列出 UID 及 GID

$ ls -l     # 詳細資訊
drwxr-xr-x. 2 tony tony     6  5月 30 17:58 desktop
...(略)...

# 第 1 個字
# - : 檔案
# d : 目錄
# l : 連結
# b : 區塊類(硬碟, 光碟機, 週邊設備)
# c : 字元類(序列埠, 終端機, 磁帶, 印表機)

$ ls --full-time  # 列出 詳細時間
$ ls --time={atime, ctime}  # 列出 {access時間 , 改變權限屬性時間 }
```

### 靠 inode 來砍檔案

![](../img/filesystem_error_find_by_inode.png)

偶爾就是會發生 同資料夾底下檔名重複的東西, 但是實際上, 它已經不存在了! (如上圖的 328993)

正常的 rm -rf 方式已經砍不到東西, 因此改砍 inode

```bash
iNODEFILE=
find . -inum $iNODEFILE -exec rm -rfi {} \;
```


## 好用的資料處理工具(分欄位) - awk
> 語法: `awk '條件1{動作1} 條件2{動作2} ...' <filename>`; 欄位分隔符號預設為「空白鍵」or「tab鍵」

```sh
### 指定分隔欄位符號
$# awk -F:
# 使用「:」作為分隔號

$ last -n 5
tony     pts/10       192.168.124.94   Mon Apr  9 20:59   still logged in
tony     pts/11       192.168.124.88   Mon Apr  9 20:11 - 20:12  (00:01)
tony     pts/10       192.168.124.94   Mon Apr  9 19:37 - 20:51  (01:14)
tony     pts/9        192.168.124.94   Mon Apr  9 17:02   still logged in
tony     pts/9        192.168.124.94   Mon Apr  9 10:35 - 16:58  (06:23)

$ last -n 5 | awk '{print $1 "\t" $3}'
tony    192.168.124.94
tony    192.168.124.88
tony    192.168.124.94
tony    192.168.124.94
tony    192.168.124.94

### awk split 範例
$# export NAME=Tony
$# env | grep '^NAME'
NAME=Tony
$# echo $(env | grep '^NAME' | awk '{split($0,kk,"="); print kk[2]}')
Tony
# split 可將 awk 整行字串, 分割成 kk array, 使用 "=" 分割, 後續在印出第二個位置


### 抓出最後一個欄位
$# ll | awk '{print $NF}'
```

### mail

- `mail`(指令) 會去取得 MAIL(變數), 依照當時的使用者, 開啟 `/var/spool/mail/USER`


### ncftpget ncftpput

```sh
ncftpput -u <帳號> -p <密碼> <host>:~/ upload <標的檔案>
```


### substring
```sh
$ a='12345678'
$ echo ${a:2:3}
345
```


### 測試 - test

```bash
### 是否為 Block Device (ls -l 第一個字母為 b)
test -b /dev/disk0


### 是否為 character device (ls -l 第一個字母為 c)
test -c /dev/zero


### 是否為目錄
test -d /tmp


### 是否為檔案
test -e /etc/profile


### 是否具有 SGID 屬性
test -g $SGID


### 是否具有 Sticky bit 屬性
test -k $StickyBit


### 是否為 Link File (ls -l 第一個字母為 l) (不確定有沒有分 軟硬連結)
test -L /dev/stdin


### 字串是否有長度(並非空字串)
#  test -n 可直接寫成 test (-n 可省略)
test -n TonyChou
# 0 : 並非空字串
# 1 : 空字串, 也就是 ""


### 是否為 FIFO File
test -p $FIFO
# 找不到範例....


### 是否可 read
test -r /etc/profile


### 是否為「非空白檔案」
test -s /etc/profile


### 是否為 Socket File
test -S /var/run/docker.sock


### 是否具有 SUID 屬性
test -u $SUID


### 是否可 write
test -w /etc/profile


### 是否可執行
test -x /bin/ls


### 判斷字符串是否為 0 (空字串)
#     變數的字串長度若為0, 返回 true(也就是 0)
test -z ""
test -z "$NonExistingVariable"
# example:
# 回傳 1 : name=Tony; test -z $name; echo $?
# 回傳 0 : name=; test -z $name; echo $?

# 上述的 「test -z $name」 也可用 「[[ -z $name ]]」 來代替
```


# Locale - Linux語系編碼

```sh
$ locale
LANG=zh_TW.UTF-8    # 原本的語系 zh_TW.UTF-8
LC_CTYPE="zh_TW.UTF-8"      # 字元的編碼
LC_NUMERIC="zh_TW.UTF-8"    # 數字格式
LC_TIME="zh_TW.UTF-8"       # 時間格式
LC_COLLATE="zh_TW.UTF-8"    # (定序)文字如何比較(為了排序)
LC_MONETARY="zh_TW.UTF-8"   # 貨幣格式
LC_MESSAGES="zh_TW.UTF-8"   # 訊息顯示的格式(ex: 錯誤訊息)
LC_PAPER="zh_TW.UTF-8"
LC_NAME="zh_TW.UTF-8"
LC_ADDRESS="zh_TW.UTF-8"
LC_TELEPHONE="zh_TW.UTF-8"
LC_MEASUREMENT="zh_TW.UTF-8"
LC_IDENTIFICATION="zh_TW.UTF-8"
LC_ALL=

# 改變語系吧
$ LANG=en_US.utf8
$ export LANG=${LANG}
$ locale
LANG=en_US.utf8     # 底下一切都變了 en_US.utf8
LC_CTYPE="en_US.utf8"
LC_NUMERIC="en_US.utf8"
LC_TIME="en_US.utf8"
LC_COLLATE="en_US.utf8"
LC_MONETARY="en_US.utf8"
LC_MESSAGES="en_US.utf8"
LC_PAPER="en_US.utf8"
LC_NAME="en_US.utf8"
LC_ADDRESS="en_US.utf8"
LC_TELEPHONE="en_US.utf8"
LC_MEASUREMENT="en_US.utf8"
LC_IDENTIFICATION="en_US.utf8"
LC_ALL=

# locale -a 可以查看 Linux 支援了多少語系
$ locale -a | wc
    789     789    8231     # 支援了 789 個語系...

# zh_TW.big5 : 大五碼的中文編碼
# zh_TW.utf8 : 萬國碼的中文編碼
```


```sh
# umask : 讓目前使用者 建立 檔案 or 目錄 時的權限設定值
# 預設上, 檔案 最多應為 666
# 預設上, 目錄 最多可為 777
# umask 的分數指 該預設值需要檢調的權限!!
# 適用情境: 不同使用者, 要各自登入 linux, 要共同合作開發某資料夾下的專案, 可先改好 umask後, 便可方便將來合作


$ umask   # 用來清除對應的權限
0002    # 第 1 碼為特殊用途; 後面分別為 user, group, other

$ umask -S    # 以符號類型的方式, 顯示(如上例, umask 0002)
u=rwx,g=rwx,o=rx
```


```bash
### /etc/resolv.conf 用途
$# cat /etc/resolv.conf
nameserver   local_DNS_ip
search       tonychoucc.local
# 後面的 search 可用來做懶人的搜尋方式, 可 exclude search domain
#   可用「ping web」
#   取代「ping web.tonychoucc.local」
# search Domain 可以同時有多個, ex:
search       tonychoucc.com  tony123.com  tony456.cc
```


# mail

站內寄信, 使用 `mail`, 所有使用者都有個 mailbox, 會寄到別人那邊 (`/var/spool/mail/<user>`)

```sh
### 寄信方式1: 互動式介面寄信
$ mail -s "主題1" tony
Hello~~~  I am GOD!!
.   # 輸入「.」代表結束
EOT

### 寄信方式2: 使用資料劉重導向
$ mail -s "主題2" tony < ~/content2tony

### 寄信方式3: 使用管線
$ ls -al ~ | mail -s "主題3" tony
```


# 其他

- 光碟寫入工具
  - 光碟製作成 iso 鳥哥 `mkisofs`
  - 燒光碟 鳥哥很推薦這個哥 `cdrecord`

```bash
### 看目錄結構
$# tree -dL 4 venv
./venv
├── bin
├── include
├── lib
│   └── python3.7
│       └── site-packages
│           ├── pip
│           ├── pip-19.0.3.dist-info
│           ├── pkg_resources
│           ├── __pycache__
│           ├── setuptools
│           └── setuptools-40.8.0.dist-info
└── lib64 -> lib


### 找出組態檔內有意義的文字字段
grep -n -v  -e '^[#;]' /etc/samba/smb.conf.example | grep -v ':$' -
# 找特定檔案, 列出行號
# 非 #; 開頭
# 非 空白行
# pipeline 給 非 : 結尾(因有行號:)


### stat 檢查檔案細項屬性
stat /etc/passwd



### Linux Terminal 交談 - 發送給 User 的 TTY
write tony pts/2
# 輸入完訊息後「Ctrl+D」發送


### Linux Terminal 交談 - 廣播
wall '這是廣播訊息~~'


### Linux Terminal 交談 - 設定是否接受交談
mesg n
mesg y
# 但此設定對 root 無效 (一樣會收到 root 發送的 message)


### 取得檔名
basename /etc/nginx/nginx.conf

### 取得目錄名
dirname /etc/nginx/nginx.conf

### 列出內容(包含行號)
nl /etc/nginx/nginx.conf


### 取得 CentOS7 OS 內頁單個內存緩衝區大小
getconf PAGE_SIZE
4096


### 查看 CPU 數量
grep 'processor' /proc/cpuinfo
#processor       : 0
#processor       : 1
#processor       : 2
#processor       : 3
# 我有一顆 4 核心的 CPU


### 

```
