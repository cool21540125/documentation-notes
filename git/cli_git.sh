#!/usr/bin/bash
exit 0
#

#
# ------------------------------------------------------------

### ======================= 常用 =======================

### 重新 Commit
git commit --amend -m "<Commit String>"

### 改變追蹤 URL
git remote set-url origin git@github.com:cool21540125/documentation-notes.git
#                   repo   git_url

### 重新釘選 Local Branch 到遠端 (ignore all local changes)
git reset --hard origin/BRANCH
# 常用於 Remote 做過 force push 的直接暴力追蹤

### 設定追蹤遠端分支
git branch --set-upstream-to=origin/${BRANCH} ${BRANCH}

### 手動推送到遠端分支
git push --set-upstream origin ${BRANCH}

### git push tag
git push origin ${TAG}

### 比對兩次 commit 所有差異
git diff $OLD_COMMIT $NEW_COMMIT

### 比對兩次 commit 特定檔案的差異
git diff $OLD_COMMIT $NEW_COMMIT -- $FILE

### 比對目前 commit 與特定 commit 差異
git diff $COMMIT

### 清除 .gitignore 宣告的檔案們
git clean -idx # 互動式詢問


### ======================= AWS CodeCommit 常見問題 =======================

### CodeCommit 的 dependencies 問題
# 若安裝 dependencies 的時候, 來源為 private CodeCommit, 出現下列錯誤, 就用這行
# npm ERR! command git --no-replace-objects ls-remote https://git-codecommit.us-west-2.amazonaws.com/v1/repos/MY_REPOSITORY
# npm ERR! fatal: unable to access 'https://git-codecommit.us-west-2.amazonaws.com/v1/repos/MY_REPOSITORY/': The requested URL returned error: 403
git config --local credential.helper '!aws codecommit credential-helper $@'
git config --local credential.UseHttpPath true
# 若無法
git config --local url."ssh://git-codecommit.us-west-2.amazonaws.com/v1/repos/".insteadOf "https://git-codecommit.us-west-2.amazonaws.com/v1/repos/"
# (或許本地使用 ssh 來做推拉, 然而 dependencies 卻使用了 https)

### ======================= 同一個 Git Server, 使用不同的 Key =======================

### 使用另一把 key 來操作相同 Git Server 底下的其他 Git Projects - How to configure a local Git repository to use a specific SSH key
#    https://dev.to/web3coach/how-to-configure-a-local-git-repository-to-use-a-specific-ssh-key-4aml
# ex: 在 Public Gitlab 裡頭有自己帳號塞一把 key && 公司帳號也塞一把 key
# 在做 git 操作時, 預設都會使用 `~/.ssh/id_rsa` 這把做金鑰認證
export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa_personal' git clone ${Git_Url}
# 或
# 下列配置會記錄在 ./.git/config 裡頭的
# [core]
#    sshCommand = ssh -i ~/.ssh/id_rsa_personal
git config --local core.sshCommand "ssh -i ~/.ssh/id_rsa_personal"

git config --local user.name TonyChou
git config --local user.email cool21540125@gmail.com

### 配置完 gpgsign 以後, 再對專案層級做啟用
git config --local commit.gpgsign true
git config --local user.signingkey $SIGNING_KEY_UID

### ======================= 基礎配置 =======================

### 常用配置
GIT_USER_NAME=TonyChou
GIT_EMAIL=cool21540125@gmail.com
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_EMAIL"

git config --global core.fileMode false
git config --global apply.whitespace nowarn
git config --global pull.rebase true
git config --global color.ui true

git config --global credential.helper 'cache --timeout=86400' # (使用非ssh維護專案時)快取密碼 604800 一週 ; 86400 一天 (For Linux/Mac, but NOT for Windows)
git config --global credential.helper store                   # 慎用!! 會以明碼的方式, 儲存在 「~/.git-credentials」

git config --global --add --bool push.autoSetupRemote true # 自動推送為追蹤的分支

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

### 由 CodeCommit 拉依賴的時候遇到的權限問題因應方式
# from here: https://catalog.us-east-1.prod.workshops.aws/workshops/869f7eee-d3a2-490b-bf9a-ac90a8fb2d36/en-US/4-basic/lab0-codecommit/setup-codecommit
git config --local credential.helper '!aws codecommit credential-helper $@' # git aws 相關
git config --local credential.UseHttpPath true                              # git aws 相關

### 強制 Golang 使用 ssh(而非 http) 從 private repo 拉資料
# https://matthung0807.blogspot.com/2021/07/go-unable-to-get-modules-from-private-gitlab-repository.html
# Golang 從私有的GitLab取得依賴module Unable to get modules from private gitlab repository
git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"

### ======================= Test Connection =======================

### 測試能否與 Git Server 連線
ssh -vT git@${GIT_SERVER_DOMAIN} -p ${PORT}
# 若 PORT 為預設的 22, -p PORT 可略
# GIT_SERVER_DOMAIN, ex: gitlab.com
# 永遠使用 git user 來測

### ======================= 夾雜在 ShellScript 裡頭常見實用腳本 =======================

### 清除 .gitignore 宣告的檔案們
git clean -ffdx # (移除 .gitignore 宣告的檔案們 - 適用於 CICD Pipeline)

### 取得 current Branch Name
git rev-parse --abbrev-ref HEAD
#master

### 取得 master Branch 的 upstream remote name
git config --get branch.master.remote
#origin

### current Branch 是否已經設定過 upstream branch
git rev-parse --abbrev-ref --symbolic-full-name '@{u}'
#origin/master

### 自動化流程, 強制更新
git fetch --tags --force --progress -- $(git remote -vv | head -1 | awk '{print $2}') +refs/heads/*:refs/remotes/origin/*

### 自動化流程(ex: Jenkins), 切換到特定 Branch,
git rev-parse refs/remotes/origin/${Branch}^{commit}

### ============================================== 特殊處理 ==============================================

### 列出 releases 之間的 commit (無法使用)
git log --pretty=format:%s release --no-merges {FROM_THIS_COMMIT_HASH_ID}...HEAD

### ============================================== Submodule ==============================================

### 移除 Submodule
SM=xxx
git submodule deinit -f $SM
rm -rf .git/modules/$SM
git config -f .gitmodules --remove-section submodule.$SM
git config -f .git/config --remove-section submodule.$SM
git rm --cached $SM
rm -rf $SM

## 假設要在 目前 GitProject 底下, 加入一個 子專案, 作法如下

### (進入目前 GitProject) 首次設定(一個 GitProject 如果要附加 子專案 的話, 只需做過一次即可)
git submodule init

### 設定 子專案
git submodule add git@github.com:cool21540125/aws-labs.git
# 如此一來, aws-labs 這個 GitSubmodule 就會附加到當前 GitProject 底下了

### 更新 submodules
git submodule update --init --recursive

### 將來要持續更新 submodule
cd ${SubModule}
git pull

### ============================================== xxx ==============================================
