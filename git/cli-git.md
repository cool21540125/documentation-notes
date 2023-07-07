
# 設定

```bash
### 常用配置
GIT_USER_NAME=TonyChou
GIT_EMAIL=cool21540125@gmail.com
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_EMAIL"

git config --global core.fileMode false
git config --global apply.whitespace nowarn
git config --global pull.rebase true
git config --global color.ui true

git config --global credential.helper 'cache --timeout=86400'  # (使用非ssh維護專案時)快取密碼 604800 一週 ; 86400 一天 (Windows 可免)
git config --global credential.helper store                    # 慎用!! 會以明碼的方式, 儲存在 「~/.git-credentials」

# from here: https://catalog.us-east-1.prod.workshops.aws/workshops/869f7eee-d3a2-490b-bf9a-ac90a8fb2d36/en-US/4-basic/lab0-codecommit/setup-codecommit
git config --global credential.helper '!aws codecommit credential-helper $@'  # git aws 相關 (現在還不是很懂這個要幹嘛...)
git config --global credential.UseHttpPath true                               # git aws 相關 (現在還不是很懂這個要幹嘛...)


### 懶人指令 (git tree)
git config --global alias.br "branch"
git config --global alias.cm "commit -m"
git config --global alias.co "checkout"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
git config --global alias.lgg "log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]%Creset' --decorate"
git config --global alias.pu "push"
git config --global alias.st "status"
git config --global alias.tree "log --graph --decorate --pretty=oneline --abbrev-commit"
git config --global alias.sm "submodule"
```


# 測試

```bash
### 測試能否與 Git Server 連線
$# ssh -vT git@${GIT_SERVER_DOMAIN} -p ${PORT}
# 若 PORT 為預設的 22, -p PORT 可略
# GIT_SERVER_DOMAIN, ex: gitlab.com
# 永遠使用 git user 來測
```


# 使用

```bash
### 強制 Golang 使用 ssh(而非 http) 從 private repo 拉資料
# https://matthung0807.blogspot.com/2021/07/go-unable-to-get-modules-from-private-gitlab-repository.html
# Golang 從私有的GitLab取得依賴module Unable to get modules from private gitlab repository
git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"


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


### 比對兩次 commit 所有差異
git diff $OLD_COMMIT $NEW_COMMIT

### 比對兩次 commit 特定檔案的差異
git diff $OLD_COMMIT $NEW_COMMIT -- $FILE

### 比對目前 commit 與特定 commit 差異
git diff $COMMIT
```


# 特殊處理

## I. 使用另一把 key 來操作相同 Git Server 底下的其他 Git Projects

- [How to configure a local Git repository to use a specific SSH key](https://dev.to/web3coach/how-to-configure-a-local-git-repository-to-use-a-specific-ssh-key-4aml)

```bash
### (不動設定) 手動指定 Key path
GIT_SSH_COMMAND='ssh -i ~/.ssh/PrivateKeyName' git clone ${Git_Url}
# ex: 在 Public Gitlab 裡頭有自己帳號塞一把 key && 公司帳號也塞一把 key
# 在做 git 操作時, 預設都會使用 `~/.ssh/id_rsa` 這把做金鑰認證

# 或

### 一次性設定
git config --local core.sshCommand "ssh -i ~/.ssh/PrivateKeyName"
# 上述配置會記錄在 ./.git/config 裡頭的
# [core]
#    sshCommand = ssh -i ~/.ssh/PrivateKeyName
```


# submodule

## 假設要在 目前 GitProject 底下, 加入一個 子專案, 作法如下

```bash
### 先進入 目前 GitProject

### 首次設定(一個 GitProject 如果要附加 子專案 的話, 只需做過一次即可)
git submodule init


### 設定 子專案
git submodule add git@github.com:cool21540125/aws-labs.git
# 如此一來, aws-labs 這個 GitSubmodule 就會附加到當前 GitProject 底下了


### 如果設錯了, 需要修復底下的東西
#  1 .git/config
#  2 .git/modules/SubModuleDir 
#  3 .gitmodules


### 更新
git submodule update


### 將來要持續更新 submodule
cd ${SubModule}
git pull origin master
```
