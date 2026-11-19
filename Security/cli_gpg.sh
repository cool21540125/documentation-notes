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
gpg --import XXX.pub
#gpg: key D58167303B789C72

### 列出 gpg key 的 fingerprint
gpg --fingerprint D58167303B789C72
# 通常用來和對方官網對答案, 看看此 GPG Public Key 是不是真的是對方的

### 使用 gpg key 來做驗證
gpg --verify XXX.tar.gz.sig XXX.tar.gz

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


# =============================== 洋蔥路由瀏覽器 ===============================

## 2026/07/05 - https://support.torproject.org/zh-TW/tor-browser/getting-started/verifying-tor-browser/#macos

gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
#gpg: key 4E2C6E8793298290: public key "Tor Browser Developers (signing key) <torbrowser@torproject.org>" imported
#gpg: Total number processed: 1
#gpg:               imported: 1
#pub   rsa4096 2014-12-15 [C] [expires: 2027-07-15]
#      EF6E286DDA85EA2A4BA7DE684E2C6E8793298290    <----- NOTE: 這個!!
#uid           [ unknown] Tor Browser Developers (signing key) <torbrowser@torproject.org>
#sub   rsa4096 2024-07-15 [S] [expires: 2026-10-26]
# ---
# 簡單地說, gpg 使用 wkd 取得該網站的 Public Key, 會匯入到本地 keyring
# * gpg 使用 WKD (Web Key Directory) 機制, 去自動抓取指定身份的 Public Key
#     * nodefault, 關閉預設查找方式(通常是 keyserver)
#         * 改用 WKD 方式查找
#             * WKD 原理:GPG 會依據 email 的網域, (a.k.a. toproject.org), 推斷出 URL, 向該網域發 HTTPS 請求抓 Public Key. 前提是該網域架設了 WKD 服務
#     * 而不需要透過傳統 keyserver(keyserver 有被污染或不可靠的風險). 抓到金鑰後, 通常接著用它驗證下載檔案的 .asc 簽章
# ---

##
gpg --output ./tor.keyring --export 0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290
#(沒有輸出資訊)
# 將已經匯入本地的 Public Key