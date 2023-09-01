

```bash
### 生成 key
ssh-keygen -b 4096 -C "$SSH_KEY_裡頭的結尾名稱" -f "$產出的SSH_KEY檔名" -P "$使用此SSH_KEY的passphrase" 
# -t [rsa|tsa] : 加密演算法
# -b <number> : 加密位元數, 建議都 2048 以上
# -C <xxx> : keygen 名稱


### ed25519 (比 rsa 更有效率 && 安全)
# https://docs.gitlab.com/ee/ssh/README.html#ed25519-ssh-keys
ssh-keygen -t ed25519 -C "tony@tonynb"
# 產生 id_ed25519 && id_ed25519.pub


### 修改 OpenSSH private key and PEM private key formats
# https://man.openbsd.org/ssh-keygen#m
ssh-keygen -p -N "" -m $要修改成哪種Key_Format -f $要修改的PrivateKey
# -p -N "xxx" : 要改成使用此 passphrase
# format
#    -m RFC4716
#    -m PKCS8
#    -m PEM


### 
```
