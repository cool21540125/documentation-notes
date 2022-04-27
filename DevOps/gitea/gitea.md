
# gitea

- 2020/01/29
- [Install gitea](https://gist.github.com/appleboy/36313a525fbef673f8aefadb9c0f8247)
- [YT](https://www.youtube.com/watch?v=shxiz_bos3I&t=1942s)

```bash
### 建立 git 這個使用者 && 安裝 git
### 開 3000 port

### 2020/01/29 目前最新 1.9.6 (抓 amd64 for centos7)
(git)$ wget https://dl.gitea.io/gitea/1.9.6/gitea-1.9.6-linux-amd64 gitea
# 版本參考這邊 https://dl.gitea.io/gitea/

### hosting service
$ ./gitea web

### http://YOUR-GITEA-DOMAIN:3000/install
### 1. Domain 改成 ip 或 domain-name
### 2. Application URL 的 localhost 也要改

```


```bash
### 使用 caddy 換 port
$ wget https://github.com/caddyserver/caddy/releases/download/v1.0.2/caddy_v1.0.2_linux_amd64.tar.gz -O caddy.tar.gz
# 自己來換版本了 https://github.com/caddyserver/caddy/tags
# 教學 0.9.5 舊版 Caddy 使用 ACME1 已經無法做 letsencrypt 認證了
$ mkdir caddy && tar -zxvf caddy.tar.gz -C caddy
```



```bash
###
$# vim Caddyfile
# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
### 這是 https
#demo.gitea.com {
#  proxy / 127.0.0.1:3000
#}

# 這是 http
http://demo.gitea.com {
  proxy / 127.0.0.1:3000
}
# ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
```


# SSH Container Passthrough

- [SSH Container Passthrough](https://docs.gitea.io/en-us/install-with-docker/#ssh-container-passthrough)

如果 Gitea Container 需要使用 ssh 來作訪問(也就是支援 ssh 協定)

一種做法是在 Host 2222 port -> Container 22 port

另一種做法是, 轉發本地的 SSH Connection from Host -> Container

1. 使用者到 Gitea Web 配置自己的 SSH Public Key
2. Gitea 會把上述 SSH Public Key 加入到 ~git/.ssh/authorized_keys 裏頭
3. 此 SSH Public Key 會以 **command=** 開頭 This entry has the public key, but also has a command= option. It is this command that Gitea uses to match this key to the client user and manages authentication.
4. The client then makes an SSH request to the SSH server using the git user, e.g. git clone git@domain:user/repo.git.
5. The client will attempt to authenticate with the server, passing one or more public keys one at a time to the server.
6. For each key the client provides, the SSH server will first check its configuration for an AuthorizedKeysCommand to see if the public key matches, and then the git user’s authorized_keys file.
7. The first entry that matches will be selected, and assuming this is a Gitea entry, the command= will now be executed.
8. The SSH server creates a user session for the git user, and using the shell for the git user runs the command=
9. This runs gitea serv which takes over control of the rest of the SSH session and manages gitea authentication & authorization of the git commands.


### Step1. 設定容器的 USER_UID 與 USER_GID

```bash
useradd git ; echo <要設定的密碼> | passwd --stdin git
```

```yml
### gitea 容器的配置檔
environment:
  - USER_UID=1000
  - USER_GID=1000
```

### Step2. 掛載

```yml
### gitea 容器的配置檔
volumes:
    - /home/git/.ssh/:/data/git/.ssh
ports:
    - "127.0.0.1:2222:22"  # 宿主機 2222 -> 容器 22
```

### Step3. 建立 git user 的 Key Pair

```bash
sudo -u git ssh-keygen -t rsa -b 4096 -C "Gitea Host Key"

cat /home/git/.ssh/id_rsa.pub >> /home/git/.ssh/authorized_keys
```

底下為說明

宿主機產生的這個 Key-Pair, 需要把 Public Key 加入到宿主機的 `/home/git/.ssh/authorized_keys` (同時, 也藉由 mount, 同步到容器中)

將來若使用者透過 Web 加入 SSH Public Key, 則此份檔案看起來像下面這樣

```bash
### /home/git/.ssh/authorized_keys
# 此由宿主機 /home/git/.ssh/id_rsa.pub 加入的
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKjBhZCCTau6MYeugB3glTBeVjUjytP2ZTivIYnbzw/hoxH4AKFJ/PpRMgYqc84lmO7rsiw8A4MxgSlTno8xvBIxrHcHo4O3vhfM6F0QvQnkHcy5hyFw3y3jaenGNvi/LzhSbAafYH1L6fAdf4lwV1XsZMvKmDXFmXJZnl/GfZ5PgfQ7k1L3topGPnY1dPPZGUmytvOEhvJw5mbXwUaQ9co8PG2d+b7wHusTFQ2tJ6hQiW5YsvvBHiX9fzt9cAv/AvgZp4rgnKjryEJU6+rTOtHkdjECFAtI0i+eyQDzWcN22IJ8NiS1MGFDlrpwDR+CykZWt71yrgpDdnIOhUs7lvb89jegjnUB1vGC/wMgsnm8/Pr1mPig9lBUuei9t1h+XMrzBu3AhbNHlhtJqLWTD0S99WpVunLMP6wYnpfc1JIc9dIx1hBS5b9xQUYmPrgNPftP1p13/bzqeiYSjKtuPCGTVSN59I4H1KwkBAaI96/7Tdik6eGlJFin3s2suloKwCoFyLfQdKYUPTrPcSaVqZ3iJ3a5IboZdWrMHnnyJh3rLQfwSD593FsBeYELyhY/hObzlK3R91S43NNsMVCf8zWMre4SwsnK1zIz/fyokdyr0TU6x+xtNIWuCn1zH3bsiEK16LVBEiONgln8Er3bwZWwxpg4YHzV8wMJkP/MpM2w== Gitea Host Key

# 此為 User 透過 Web, 自行加入 Client 的 ~/.ssh/id_rsa.pub
command="/usr/local/bin/gitea --config=/data/gitea/conf/app.ini serv key-4",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3aIWdIubUizyFt7A6UM1SRvkO9xjndwcM6+D2N5dAU3icEzi8d02nM01mENeKZ1DedjEgqNmKpVUOew2jZUlVjjqlyfpLECOa/5BdJWSokU1/sAl9XoTfSiO0KOJ7dD/kmJs30js5PJox4pP3N0FfteW11olGCEdwmtU9HWvphLyKvZS1pIIjoGpmRxUx7mWlOqIYuJx+Iaw623HLztuWg4ilU4WJCnDQLaizbm9TFDlDqSu/OdABo4OAwzJX1L66rWy9JfAWDuUgf+8Gaoh4banLIyi4vETcqpu0E3t+Po5Ah32DEN2pHykJccFcOEvFeRtbejQfXzBiUUnbAD98o2/BpqMMMm7iMAfzq5ㄣ+4tl+ogsqmvvK48JUsY1C59oRG+D99B9zOpfviMXwsNur1fLO6azNjvJetG++8cwDYQ+sRXvfvk3OcIyEZXKVinXb2+AZ/cwOB8coHTaztYspfGLGPSnwVjwzGx3JPJJdGgVJ8WqZFJjhPT+E75NL6tw= cool21540125@gmail.com
```

### Step4. 在宿主機, 建立一個 executable

```bash
touch /usr/local/bin/gitea
echo 'ssh -p 2222 -o StrictHostKeyChecking=no git@127.0.0.1 "SSH_ORIGINAL_COMMAND=\"$SSH_ORIGINAL_COMMAND\" $0 $@"' > /usr/local/bin/gitea
#            ^^^^ Host 與 Container mapping port
chmod u+x /usr/local/bin/gitea
cat /usr/local/bin/gitea
ll /usr/local/bin/gitea
```


## 說明

1. SSH Request 發送到宿主機, 使用 git user. 執行像是 `git clone git@repo:user/repo.git`
2. 位於宿主機的 `/home/git/.ssh/authorized_keys`, command 會去執行 `/usr/local/bin/gitea`
3. `/usr/local/bin/gitea` 專發宿主機的 SSH Request 到 2222 port, 後續再 mapping 到 Container 22
4. Host 藉由 git user 的 `/home/git/.ssh/authorized_keys` 來作主機 → Container 認證成功, 最後由 SSH request forward 到 Gitea Container

將來如果 Web 增加新的 key, 則宿主機也會跟著增加

SSH Container passthrough 成功的條件:

- Container 必須運行 `opensshd`
- `AuthorizedKeysCommand` 並沒有與 `SSH_CREATE_AUTHORIZED_KEYS_FILE=false` 結合使用來 disable authorized files key generation
- `LOCAL_ROOT_URL` 維持不變

最後, 防火牆要開 22 port
