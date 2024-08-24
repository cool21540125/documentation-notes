#!/bin/bash
exit 0
#
# Install
# sudo apt install gnupg
# brew install gnupg
# choco install gnupg
#
# 金鑰的
#   [SC] 表示用途為 Signing(簽署) 及 Certification(建立憑證)
#   [E] 表示用途為 Encryption(解密)
#   [A] 表示用途為 Authentication(認證)
# ------------------------------------------------------------------------------------------

# =============================== gpg 基礎操作 ===============================
gpg --version
#gpg (GnuPG) 2.4.5

### 生成自己的 GPG Key Pair
gpg --gen-key
gpg --full-generate-key

### 查看 gpg keys
gpg -k # list gpg Public Keys
gpg -K # list gpg private keys

###
gpg --armor --export $MY_GPG_KEY_UID
#

# =============================== 外來 Public Key 相關操作 ===============================

### 列出所有的 public keyrings
gpg --list-public-keys # 或 -k 或 --list-keys
# 假設其中一把為
#pub   ed25519 2024-08-24 [SC] [expires: 2027-08-24]
#      C63D719B63F420828C59BAF6D03A6E2FA0A1B443
#uid           [ultimate] easy <cool21540125@gmail.com>
#sub   cv25519 2024-08-24 [E] [expires: 2027-08-24]

### 將外部取得的 public key, 加入到 gpg trustdb(密鑰環)當中
gpg --import amazon-cloudwatch-agent.gpg
#gpg: key D58167303B789C72: public key "Amazon CloudWatch Agent" imported
#gpg: Total number processed: 1
#gpg:               imported: 1

### 列出 gpg key 的 fingerprint
gpg --fingerprint $GPG_KEY_UID
# 通常用來和對方官網對答案, 看看此 GPG Public Key 是不是真的是對方的

### 調整外部匯入的 GPG Public Key 的信任等級
gpg --edit-key $SOMEONES_KEY_UID
# ex: gpg --edit-key "Amazon CloudWatch Agent"

# =============================== 加解密操作 ===============================
### encryption
gpg -ear easy FILE
# 註: easy 為 gpg trustdb 已有的 public key uid
# 加密以後的檔案會是 FILE.asc

### decryption
gpg -d FILE.asc

# =============================== 匯出 Private Key ===============================
### 將 gpg public key 匯出 (傳給其他人做加密使用)
gpg --export easy >pub-easy.key    # (實際用途好像不大)
gpg --export -a easy >pub-easy.asc # (base64 輸出, 此為常見格式)

### 列出所有的 secret keys
gpg --list-secret-keys # 或 -K
gpg --export-secret-key -a easy >priv-easy.asc

# =============================== 移除 gpg Key (謹慎操作!!!) ===============================
# WARNING: 謹慎操作 remove private key
# 需先移除 private 再移除 public
# 建議先 backup
gpg --delete-secret-keys ExampleKeyUid
gpg --delete-keys ExampleKeyUid
gpg --delete-secret-and-public-key ExampleKeyUid
