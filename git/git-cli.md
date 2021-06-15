# git 指令操作

## 設定篇

```bash
### 基本資訊
git config --global user.name "TonyChou"
git config --global user.email "cool21540125@gmail.com"

### 忽略「空白」所造成的影響
git config --global apply.whitespace nowarn

### (使用非ssh維護專案時)快取密碼 604800 一週 ; 86400 一天
git config --global credential.helper 'cache --timeout=86400'
# Windows 不需要設定, 認證管理員會自己幫忙維護密碼
# 會把密碼資訊儲存在 RAM 裡面

### (使用非ssh維護專案時)永久紀錄密碼
git config --global credential.helper store
# Linux 慎用!! 會以銘碼的方式, 儲存在 「~/.git-credentials」

### 增加Git輸出時的顏色
git config --global color.ui true

### 檔案改變權限(chmod)後, git 不會把他們視為變更
git config --global core.fileMode false

### 首次設定 PKI
ssh-keygen -t rsa -b 4096 -C "tony@tonynb" -f "key_name"

### ed25519 (比 rsa 更有效率 && 安全)
# https://docs.gitlab.com/ee/ssh/README.html#ed25519-ssh-keys
$# ssh-keygen -t ed25519 -C "tony@tonynb"
# 產生 id_ed25519 && id_ed25519.pub
```

底下為懶人包指令

```bash
### git tree
git config --global alias.tree "log --graph --decorate --pretty=oneline --abbrev-commit"

### git pu
git config --global alias.pu "push"

### git cm
git config --global alias.cm "commit -m"
```


## 查詢設定篇

```bash
### 全域設定
git config --global --list
```


## 測試篇

```bash
### 測試能否與 Git Server 連線
$# ssh -vT git@GIT_SERVER_DOMAIN -p PORT
# 若 PORT 為預設的 22, -p PORT 可略
# GIT_SERVER_DOMAIN, ex: gitlab.com
# 永遠使用 git user 來測
```


## 使用篇

```bash
### 重新 Commit
git commit --amend -m "<Commit String>"

### 改變追蹤 URL
git remote set-url origin git@github.com:cool21540125/documentation-notes.git

### 設定追蹤遠端分支
BRANCH=dev
git branch --set-upstream-to=origin/${BRANCH} ${BRANCH}

### 手動推送到遠端分支
BRANCH=feature
git push --set-upstream origin ${BRANCH}

### 改變追蹤 URL
REPOSITORY=origin
GIT_URL=git@github.com:cool21540125/documentation-notes.git
git remote set-url ${REPOSITORY} ${GIT_URL}

### push tag
TAG_NAME=1.0.0
git push origin ${TAG_NAME}
```

> git ls-remote -h ${GIT_REPO_URL}

```bash
### 查看 Remote Repository 有哪些 heads
git ls-remote -h git@github.com:cool21540125/documentation-notes.git

### 查看 Remote Repository 有哪些 tags
git ls-remote -t git@github.com:cool21540125/documentation-notes.git
```