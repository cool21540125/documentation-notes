

# SSH Tunnel (跳板)

- 2018/09/29

在 localhost(`A`) (透過 `C`) 訪問 `B`

- A: 169.254.10.30
- B: 169.254.10.10 (先安裝 `httpd`)
- C: 169.254.10.20

語法 : `ssh -L 本地Port:目的IP:目的Port user@跳板IP`

```sh
# 透過 tony@169.254.10.20 訪問 169.254.10.10:80, 並將結果回傳到本地的 8088 port (在A電腦執行)
$ ssh -L 8088:169.254.10.10:80 tony@169.254.10.20

# 瀏覽器~~ 「localhost:8088」 就看到網頁了~~
# 但是不知道為什麼　curl會出現
# curl: (7) Failed to connect to localhost port 8088: Connection refused
```


# 非正規 Port

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
    StrictHostKeyChecking   no              # 忽略 known_hosts 的檢查 (參考最下面的連結)
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


## 參考

- [如何在ssh登入主機遠端主機時不要有key的檢查](https://ssorc.tw/1288/%E5%A6%82%E4%BD%95%E5%9C%A8ssh%E7%99%BB%E5%85%A5%E4%B8%BB%E6%A9%9F%E9%81%A0%E7%AB%AF%E4%B8%BB%E6%A9%9F%E6%99%82%E4%B8%8D%E8%A6%81%E6%9C%89key%E7%9A%84%E6%AA%A2%E6%9F%A5/)




# CLI

## ssh-keyscan

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

