# Git版空

- [Learning git in 30 days](https://github.com/doggy8088/Learn-Git-in-30-days/tree/master/zh-tw)
- [Git branch的操作](https://blog.gogojimmy.net/2012/01/21/how-to-use-git-2-basic-usage-and-worflow/)
- [Git初學者心得分享](http://www.mrmu.com.tw/2011/05/06/git-tutorial-for-beginner/)
- [為你自己學Git](https://gitbook.tw/chapters/config/user-config.html)
- [Git中文化電子書](https://git-scm.com/book/zh-tw/v2)
- [Git視覺化遊戲](http://learngitbranching.js.org/)
- [Github Cheat Sheet](https://metavige.github.io/2015/04/20/github-chest-sheet/#%E5%BE%9E%E5%B7%A5%E4%BD%9C%E5%8D%80%E5%8E%BB%E9%99%A4%E5%A4%A7%E9%87%8F%E5%B7%B2%E5%88%AA%E9%99%A4%E6%96%87%E4%BB%B6) 感覺值得花時間看看~ 2018/07/19 新增


# git credential helper

- 依照 OS 的不同, git 會使用不同的 credential-helper
  - Git 內建
    - git-credential-store : credentials 明碼儲存
    - git-credential-cache : credentials 暫時儲存於 Memory (for Unix Like)
  - Platform 特定
    - git-credential-osxkeychain : 儲存在 macOS keychain (for Mac)
    - git-credential-libsecret : 儲存在像是 GNOME keyring / KDE Wallet 等 Linux service service
    - git-credential-wincred : 儲存在 Windows Credential Manager (for Windows)
  - OAuth
    - git-credential-oauth : 似乎適用於多數 Linux Distributions
  - Storage specific
    - git-credential-gopass
    - git-credential-1password
  - Other
    - AWS CodeCommit
      - CICD Pipeline 運行過程會去訪問 CodeCommit 的話, 需要聲明:
        - `git config --global credential.UseHttpPath true`
      - 並且指定要如何做認證:
        - `git config --global credential.helper '!aws codecommit credential-helper $@'` (告訴 CodeCommit, 請使用 IAM role 做 credentials 的驗證)
        - `git config --global credential.helper '!aws --profile CodeCommitProfile codecommit credential-helper $@'` (指定特定的 profile)


# 底下幾個指令自己太常用... 備註到最前面

```sh
# 本地分支 push 至 origin
git push --set-upstream origin feature

# 設定本地分支追蹤的遠端分支
git branch --set-upstream-to=origin/feature feature


### 暫存目前變更
git stash

### 彈出最小暫存
git stash pop
# 其實, pop = apply + drop

### 套用特定暫存
git stash apply stash@{2}
# 並不會移除 stash@{2}

### 刪除暫存檔
git stash drop stash@{2}

### 移除所有暫存
git stash clear
```


## cherry-pick 合併特定 Commit 節點的特色

```sh
# 如果 G 節點想要 F 節點的特色, 但不要有 J 節點的東西
#
#     G
#    /|  J
#   / |  |
#  |  |  F
#  D  E /
#  |  |/
#  B  C
#   \ |
#    \|
#     A

# (切換到 G )
$ git cherry-pick J
```



# A. 概念

> Git為 `分散式版本控管系統(Distributed Version Control System)`.


## 示意圖

![Git0](../img/git01.jpg)

![Git1](../img/git02.jpg)



# B. 名詞定義

## 分支名稱

Name   | Description
------ | ----------------------------------
master | `本地端分支`的預設名稱
origin | `遠端儲存庫`的預設名稱


## 分支概念(有遠端儲藏庫的話, 可區分為下列 4種)
1. 遠端追蹤分支
2. 本地追蹤分支
3. 本地分支
4. 遠端分支
> `追蹤分支` 主要用來跟 `遠端的分支做對應`. 不應在這之上, 建立版本. 而是把這些「本地追蹤分支」當成 read only.

```sh
# 顯示所有「本地分支」(又稱 'Topic Branch' or 'Development Branch')
$ git branch
* master

# 顯示所有「本地分支」、「本地追蹤分支」
$ git branch -a
* master
  remotes/origin/master
```


## HEAD節點標籤

HEAD(代表最新版本) - 為`參照名稱`的一種 (tag 也是)

此節點標籤, 永遠代表最新的 commit
```sh
$ git show HEAD
# 顯示最新 commit的詳細資料
```





## git revert 取消提交 (保有 git commit的實作方式)

```sh
# O C0               (old)
# |
# O C1
# |
# O C2 <-master      (new)

$ git revert HEAD
# O C0
# |
# O C1
# |
# O C2
# |
# O C2' <-master
```


## 放棄合併衝突

執行合併後, 產生衝突, 打算放棄此合併, 則會回到未執行合併前的狀態
```sh
$ git merge --abort

$ git rebase --abort        # rebase分兩段, 第一段結束後, 要放棄 rebase
$ # git rebase --continue   # 解決完第一段 rebase衝突後

$ git cherry-pick --abort
```


## git reflog

> 任何透過指令修改的`參照(ref)的內容` or `更任何分支的 HEAD 參照內容`, 都會建立歷史紀錄. ex: commit, checkout, pull, push, merge, ...


# C. Git 組態

## 層級
LEVEL  | option   | Path           | Description
------ | -------- | -------------- | -------------------------
Local  | --local  | .git/config    | 只對目前的repo有效(預設)
User   | --global | ~/.gitconfig   | 對目前使用者有效
System | --system | /etc/gitconfig | 對所有使用者/儲存庫都有效


## 查詢、設定、移除

```sh
# 查詢組態
$ git config -l
$ git config -l --system
$ git config -l --global
$ git config -l --local
$ git config  <Config_Section.Config_Name> # 顯示特定組態

# 查看 分支 及 遠端追蹤情形
$ cat .git/config
```


## 查詢、設定、移除 別名
> *設定別名* : `git config --<層級> alias.<縮寫名稱> <原始指令>`

> *移除別名* : `git config --<層級> --unset alias.<已建立的別名>`
```sh
$ git config --global alias.unstage "reset HEAD --"     # 將檔案從 index中移除
# 將來可用 git unstage a.js 來取代 git reset HEAD a.js

$ git config --global alias.undo "reset --soft HEAD~1"  # 取消最近一次提交
# 將來可用 git undo a.js 來取代 git reset --soft HEAD~1 a.js
```


## .gitignore - 取消追蹤

```
*.txt        # 不要追蹤所有 txt檔
!note.txt    # 但是排除 note.txt(要追蹤)
```


## 更改 remote repo

```sh
$ git remote -v
origin  https://github.com/cool21540125/illu.git (fetch)
origin  https://github.com/cool21540125/illu.git (push)

# 改用 ssh協定
$ git remote set-url origin git@github.com:cool21540125/documentation-notes.git
Verify that the remote URL has changed.

$ git remote -v
origin  git@github.com:cool21540125/documentation-notes.git (fetch)
origin  git@github.com:cool21540125/documentation-notes.git (push)
```


## 改變追蹤遠端分支

建立一個新的 foo branch, 並追蹤 origin/master
```sh
# 法一: 藉由參考到 remote branch來 checkout 新的 branch
$ git checkout -b foo origin/master

# 法二: 使用 git branch -u
$ git branch -u origin/master foo
```



# D. 操作指令

## Git cat-file

```bash
###
$# git cat-file -p XXX
# XX 可為 `commit` or `Tag` or `branch`


### 列出簡易資訊
git status -s
```

## Git tag

- [Git Tag](https://github.com/doggy8088/Learn-Git-in-30-days/blob/master/zh-tw/15.md)
- [Git Tags](https://www.youtube.com/watch?v=4wPjo5C-v8Y)
- 2020/02/04

git tag 分為 2 種:

- lightweight
    - 位於 `~/.git/refs/tags/<TAG_NAME>`
    - `git tag <tag-name> [commit]`
- annotated
    - 位於 `~/.git/objects/`
    - 比較嚴謹的方式. 可作 tagging message, 也可以做 GPG(GNU Privacy Guard) verify
    - `git tag -a <tag-name> -m"<annotation> [commit]` - unsigned
    - `git tag -s <tag-name> -m"<annotation> [commit]` - GPG-signed


[推送 tag問題](https://stackoverflow.com/questions/5195859/how-to-push-a-tag-to-a-remote-repository-using-git)
> 推送 tag到遠端, 語法: `git push <遠端名稱> <tag name>`

```sh
# 作「v1.0」的標籤
$ git tag v1.0

# 推送 「v1.0」的 tag到遠端
$ git push origin v1.0

# 刪除 「v1.0」的 tag
$ git tag -d v1.0

# 連同
$ git push --follow-tags
```


### Release Notes

- Patch release
    - List of bug fixes
- Minor release
    - List of changes
    - Usage details
- Major release
    - List of removals
    - List of additions
    - Upgrade process


## Merge 與 Rebase

> Merge: `合併後, 分支仍然存在`
```sh
$ git branch
* master
  tony

$ git merge tony
...(一堆log)...
```

> Rebase: `合併後, 分支與 master在相同 index`
```sh
$ git branch tony
  master
* tony

$ git rebase master         # 把 tony搬到 master的下一個階段
...(一堆log)...

$ git checkout master

$ git rebase tony           # 把 (落後的)master, 合併到 tony
```


## git stash 暫存版

- `git stash` 已追蹤 的檔案 建立暫存版 (同 `git stash save`)
- `git stash -u`　已追蹤 + 未追蹤 的檔案 建立暫存版 (存到 Stack)
- `git stash --keep-index` 把 untracked files 作 stash
- `git stash list` 彈出已占存的 暫存版清單
- `git stash pop` 把 stash 的東西作 pop 最新一筆
- `git stash apply "stash@{1}"` 把特定 stash 的 暫存版名字 作 pop

- [參考這邊](https://github.com/doggy8088/Learn-Git-in-30-days/blob/master/zh-tw/13.md)
- [簡單好懂得範例](./stash_example.md)


## git reset 改變範圍

param   | data in repo | git index | file in dir
------- |:------------:|:---------:|:------------:
--soft  | v            |           |
--mixed | v            | v         |
-- hard | v            | v         | v


```sh
# 查看本地/遠端分支
$ git branch -a
* develop
  logging
  master
  remotes/origin/logging
  remotes/origin/master
```


## 修改 Commit訊息 重新commit

```sh
$ git commit --amend -m "<Commit String>"
```


## 鎖定遠端repo、遠端repo追蹤

> 加入 remote repository, 語法: `git remote add <遠端名稱> <網址>`
```sh
# 追蹤遠端分支
$ git remote add origin https://github.com/test21540125/illu.git

# 追蹤遠端分支的來源(通常 upstream用來指最原始的儲存庫位址)
$ git remote add upstream https://github.com/cool21540125/illu.git
```

script                                | Description
------------------------------------- | ------------
`git push <remote> <branch name>`     | 把指定分支的最新狀態, 推送到 remote repo
`git push -u <remote> <branch name>`<br>( `-u` 可改成 `--set-upstream` ) | (同上), <br>且會在設定檔內紀錄「本地 repo分支」與「遠端 repo分支」的對應關係

```sh
# terminal A - 推送到遠端分支
$ git push --set-upstream origin develop

# terminal B - 追蹤遠端分支
$ git branch --set-upstream-to=origin/develop develop
git pull
```

> 重要概念: `git push origin master`的意思是「先到我的 repo 找出所有 "master branch" commit紀錄, 與 **origin**這個 remote 的 "master branch"的 commit 紀錄比對是否相同, 若相同, 就更新」

```sh
$ git init
$ git add README.md
$ git commit -m 'xxx'
$ git remote -v
#(沒東西)

$ git remote add origin https://github.com/cool21540125/tttt.git

$ git remote -v
remote.origin.url=https://github.com/cool21540125/tttt.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*

$ git push -u origin master
```

- [git --track vs --set-upstream vs --set-upstream-to](https://gist.github.com/miku/613ccf7a7030a6f32df1)

```sh
# 兩者好像相同效果
# --set-upstream 已被 Deprecated了! 改用 --set-upstream-to
[any]$ git checkout -b dev origin/dev
[dev]$ git branch --set-upstream-to origin/dev
```


#### 取消追蹤遠端分支
[參考這裡](https://stackoverflow.com/questions/3046436/how-do-you-stop-tracking-a-remote-branch-in-git)
```sh
$ git branch -vv
* develop 287b263 [origin/develop: behind 1] bbb
  master          d999afd [origin/master: behind 11] ccc

# 取消追蹤目前分支的遠端追蹤
$ git branch --unset-upstream

$ git branch -vv
* develop 287b263 bbb         # 取消追蹤遠端 origin 的 develop 分支
  master          d999afd [origin/master: behind 11] ccc
```

> 取消追蹤遠端分支, 語法`git branch -d -r origin/<remote branch name>`
```sh
# 取消追蹤 origin 這個 remote 的 develop 分支
$ git branch -d -r origin/develop
Deleted remote-tracking branch origin/develop (was 287b263).
```




## 回到過去

- 使用 `^`向上移動一個 commit
- 使用`~<num>`向上移動多個 commit
```sh
$ git branch -f master HEAD~3
# 強制移動master指向從HEAD往上數的第3個 parent commit (改變 branch指向的 commit)

# ex: master^^  , 找到 master的前兩個 parent commit
# 上式, 等同於 master~2
```



## 查詢歷史紀錄

> 語法: `git reflog <branchName>` , 查詢任何分支變動的歷史紀錄
  若只有打 `git reflog` or `git reflog HEAD`, 則表示列出 HEAD變動的歷史紀錄
```sh
$ git reflog HEAD
5fc27fb (HEAD -> master, origin/master, origin/HEAD) HEAD@{0}: commit: fix git.md
b333f91 HEAD@{1}: commit: modify docker, i18n, html, linux, ubuntu1604
65251ea HEAD@{2}: commit: ADD html.md
a41e99a HEAD@{3}: commit: sql.md
ac69d3f HEAD@{4}: pull: Merge made by the 'recursive' strategy.
# 上頭的 : commit:, 表示是 commit所導致的變動, 另外還有 rebase, pull, ...等

# 若要回到以前的狀態 ac69d3f
$ git reset --hard HEAD@{4}
# 慎用 --hard
```



# E. 其他零碎片段

> `沒有工作目錄的儲藏庫`(no working tree / no working directory), 為 「bare repository」

> `index` 的目的: 用來記錄「那些檔案即將被提交到下一個 Commit版本中」

```sh
# 把被改壞的檔案, 還原回它當時在此 branch的狀態, 如此可避免使用「git reset --hard」
$ git checkout <branch> <fileName>

# -f 選項直接讓分支指向另一個 commit
$ git branch -f master HEAD~3

$ git checkout HEAD~1
```
