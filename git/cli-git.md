# git 指令操作

## 設定篇

```bash



### 常用配置
# ---------------------------------------------------------
git config --global user.name "TonyChou"
git config --global user.email "cool21540125@gmail.com"

# 忽略檔案屬性變動的追蹤(chmod)
git config core.fileMode false --global

# 忽略「空白」所造成的影響
git config --global apply.whitespace nowarn
# ---------------------------------------------------------

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

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

git config --global alias.lgg "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]%Creset' --decorate"

# ↓ 使用上會有問題, 這個可在 Win 上頭, 編輯 config 使用, 不過無法設定成 alias (須修復才可用)
git config --global alias.lggg "log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]%Creset" --decorate --numstat"


### git pu
git config --global alias.pu "push"

### git cm
git config --global alias.cm "commit -m"
```


### 使用另一把 key 來操作相同 Git Server 底下的其他 Git Projects

- [How to configure a local Git repository to use a specific SSH key](https://dev.to/web3coach/how-to-configure-a-local-git-repository-to-use-a-specific-ssh-key-4aml)

```bash
### (不動設定) 手動指定 Key path
$# GIT_SSH_COMMAND='ssh -i ~/.ssh/use_another_key_to_operate' git clone ${Git_Url}
# ex: 在 Public Gitlab 裡頭有自己帳號塞一把 key && 公司帳號也塞一把 key
# 在做 git 操作時, 預設都會使用 `~/.ssh/id_rsa` 這把做金鑰認證

# 或

### 一次性設定
$# git config --local core.sshCommand "ssh -i ~/.ssh/use_another_key_to_operate"
# 上述配置會記錄在 ./.git/config 裡頭的
# [core]
#    sshCommand = ssh -i ~/.ssh/use_another_key_to_operate
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
$# git ls-remote -h git@github.com:cool21540125/documentation-notes.git
d737674386544fa4909b11bfd85f9aethn4q1h448	refs/tags/chat-app_v1.0.1
db5ae4mnj5ae4t1b6a5e1taet658naebaec9db321	refs/tags/chat-app_v1.0.2

### 查看 Remote Repository 有哪些 tags
$# git ls-remote -t git@github.com:cool21540125/documentation-notes.git
81aebae12cdadb33fet7ant9t849nr98ff59761e3	refs/heads/master
# 也可在 git 專案底下, 直接 「git ls-remote -t .」
```


# git checkout

```bash
### 還原所有檔案回最近一次 commit (unstaged 的部分)
git checkout -- .
# or all unstaged files in current working

git checkout -- path/to/file
# for specific file
```