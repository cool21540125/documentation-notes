與 ssh 有關的大小事

# SSH Server

查詢 SSH Server 目前套用的配置, 語法:

> sshd -T

```bash
### 設定主檔
vim /etc/ssh/sshd_config

### 檢查 SSH Server 目前已套用的配置主檔
sshd -T | egrep -i AllowTcpForwarding
#-------------------------
# allowtcpforwarding yes
#-------------------------

### 若要允許 SSH Server Port Forwarding, 則這必須是 yes
sshd -T | egrep -i AllowTcpForwarding
#-------------------------
allowtcpforwarding yes  # Default yes
#-------------------------
# yes 及 all 同義詞
# local  則只允許 Local Forwarding
# remote 則只允許 Remote Forwarding

### 允許 Forward Unix domain sockets
sshd -T | egrep -i AllowStreamLocalForwarding
#-------------------------
allowstreamlocalforwarding yes  # Default yes
#-------------------------

### Server Host 預設不允許自己以外的主機 Connect to forwarded ports
sshd -T | egrep -i GatewayPorts
#-------------------------
#gatewayports no
#-------------------------
# ↑ 若要開放 Public forwarded ports, 需改成 「gatewayports yes」 或是
# 「gatewayports clientspecified」 ← 也就是說, Client 可使用:
ssh -R 5.6.7.8:9999:localhost:80 host147.aws.example.com
# ↑ 只有來自 5.6.7.8, 訪問 9999 會被許可
# ※ 若 Client 沒有 固定IP(而且也不透過VPN) 的話, 則設為 yes 或許是唯一解了
```

```conf
# /etc/ssh/sshd_config

UsePAM yes
# default: yes
# 如果設定成 no, 則將來機器只能藉由 /etc/passwd & /etc/shadow 來做認證
```

OpenSSH 也允許 forwarded remote port 到 0 (遇到再說了~)


# SSH Client

查詢 SSH Client 目前套用的配置檔, 語法:

> ssh -G [Host]

```bash
### 檢查 SSH Client 目前已套用的配置檔
ssh -G ec2 | egrep -i User
#-------------------------
#user ec2-user
#userknownhostsfile /c/Users/tony/.ssh/known_hosts /c/Users/tony/.ssh/known_hosts2
#syslogfacility USER
#-------------------------
# 此指令會優先套用 「~/.ssh/config」, 再者才是 「/etc/ssh/ssh_config」

### ssh to remote
ssh user@host
# 也可使用
ssh -l user host

### 讓 SSH Agent 設定一把金鑰
ssh-add -k $SSH_PEM_NAME
# adds private key identities to the OpenSSH authentication agent
# 用途是, 將來做 ssh -A $HOST 以後, 會攜帶此金鑰的身份到 $HOST, 並可在 $HOST, 使用上述設定好的 Identity, 再次 ssh 到 $OTHER_HOST

### 列出 SSH Agent 所擁有的 Identities
ssh-add -L
```


# SSH Tunnel

## Part 1.Local Forwarding

在 localhost(`A`) (透過 `C`) 訪問 `B`

- A: 169.254.10.30
- B: 169.254.10.10 (先安裝 `httpd`)
- C: 169.254.10.20

語法:

> ssh -L Local_Port:Destination_IP:Destination_Port user@Connection_Target_Host

> ssh -L Local_Port:Destination_IP:Destination_Port Connection_Target_Host

```sh
### Local Port Forwarding
$ ssh -N -L 8088:169.254.10.10:80 tony@169.254.10.20
# 透過 tony@169.254.10.20 訪問 169.254.10.10:80, 並將結果回傳到本地的 8088 port (在A電腦執行)
# -N: 單純只給 forwarding ports 使用(不執行 remote command)
# -L: Local Port Forwarding
# 瀏覽器~~ 「localhost:8088」 就看到網頁了~~
# 但是不知道為什麼　curl會出現
# curl: (7) Failed to connect to localhost port 8088: Connection refused

### 或者, 可以更嚴格的限定, 只能由 localhost:8888 來做 Tunneling
$ ssh -N -L 127.0.0.1:8088:169.254.10.10:80 tony@169.254.10.20
#           ↑↑↑↑↑↑↑↑↑
# 也可藉由修改 ssh config 的 「LocalForward」來做限定
```


## Part 2.Remote Forwarding

```bash
### Remote Port Forwarding
$ ssh -R 8080:localhost:80 public.example.com
# 
# -R: 處理 Remote Port Forwarding
```


# SSH Server 改 非正規 Port

```sh
### 1. 改組態
$# grep -n Port /etc/ssh/sshd_config
17:#Port 22
18:Port 6868
101:#GatewayPorts no

### 2. 重啟SSHD
$# systemctl restart sshd
$# systemctl status sshd

### 3. SELinux
$# semanage port -a -t ssh_port_t -p tcp 22
$# semanage port -l -C
SELinux Port Type       Proto    Port Number
ssh_port_t              tcp      6868

### 4. 防火牆
$# firewall-cmd --add-port=6868/tcp
$# firewall-cmd --add-port=6868/tcp --permanent
```


# 製作本機端管控遠端登入的組態檔 (可免改 /etc/hosts 或 DNS)

- [SSH](https://stackoverflow.com/questions/4565700/how-to-specify-the-private-ssh-key-to-use-when-executing-shell-command-on-git)

```bash
### 製作組態
$ vim ~/.ssh/config
# --------- 內容如下 ---------
#!/bin/bash
Host vm8                        # Remote Server 名稱
    StrictHostKeyChecking   no              
    # 忽略 known_hosts 的檢查 (登入遠端機器, 不做檢查是否是以前登入過的機器)
    # 不過似乎好像也是 首次登入時, 不要詢問 Yes/No

    HostName    172.20.61.210               # Remote Server IP
    Port    22                              # Remote Server ssh port
    ForwardAgent    yes                     # ??
    User    tony                            # Remote username
    Controlpath ~/.ssh/ssh-$r@%h:%p.sock    # ??


Host aws
    HostName    87.87.87.87
    User        ec2-user
    Port        22
    IdentityFile    /home/tony/aws.pem      # 登入私鑰 or 「D:\key\aws.pem」 for Win10
    IdentitiesOnly  yes                     # 避免 SSH 預設行為(否則會先使用 ~/.ssh/id_rsa 去訪問遠端)
# --------- 內容如上 ---------


### 登入
$ ssh tony@vm8
tony@172.20.61.210's password:
```


# CLI

```bash
### 掃描 SSH Server 上頭的 Public Key
$# ssh-keyscan 172.0.10.40
# ---------- ↓↓↓ ----------
# 172.0.10.40:22 SSH-2.0-OpenSSH_7.4
172.0.10.40 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMm4QJNSdEJq9GbVkFQ8K1lqeMOnkZD+PZ2xTCe34PU5KyDCf39rDWrs9QurfNQLsASCLJqwT19tLCjHqcHAZfILcQOCFLLZfePX+NbHWgTG+f04zg1Bm7tXuTDyJB9NLCp4JKeURvAe1VmWV+/ARZmX8H+/DZ5zodLzjOWRwS6irRlIVXeyspiMItBDRLnI5KsYlAm8UtZMWyRez9HeUMu9XdLGdJ5+v+ELAO7hyohO+B6DFJy3aooG42BX2fF+KgXmRMOpc846hHnjrhcJTAA3L99ffSDJA4UJoeFrVW3tJCkXiZKd0r7uQBLu3CQJafksWDUyMWL999sGW1pAjt
# 172.0.10.40:22 SSH-2.0-OpenSSH_7.4
172.0.10.40 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLQK2Bre5ClPj9l8mjTbjzSeWnf9sW1OtwEmMUxK6AQ
# 172.0.10.40:22 SSH-2.0-OpenSSH_7.4
172.0.10.40 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEPVtWnx9S2m/DYsa+NXfGrDiNFEXJjTQOSgtKxegBblOdLt9N+C5GaV1RK3hRw+9xxxW5XPtxVXRQgBum58zM8=
# 172.0.10.40:22 SSH-2.0-OpenSSH_7.4
# 172.0.10.40:22 SSH-2.0-OpenSSH_7.4
# ---------- ↑↑↑ ----------
# CentOS7 裏頭的 Public Keys 預設放在 /etc/ssh/*.pub
# - ssh_host_ecdsa_key.pub
# - ssh_host_ed25519_key.pub
# - ssh_host_rsa_key.pub
```
