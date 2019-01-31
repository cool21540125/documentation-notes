# Git版空

- [Learning git in 30 days](https://github.com/doggy8088/Learn-Git-in-30-days/tree/master/zh-tw)
- [Git branch的操作](https://blog.gogojimmy.net/2012/01/21/how-to-use-git-2-basic-usage-and-worflow/)
- [Git初學者心得分享](http://www.mrmu.com.tw/2011/05/06/git-tutorial-for-beginner/)
- [為你自己學Git](https://gitbook.tw/chapters/config/user-config.html)
- [Git中文化電子書](https://git-scm.com/book/zh-tw/v2)
- [Git視覺化遊戲](http://learngitbranching.js.org/)
- [Github Cheat Sheet](https://metavige.github.io/2015/04/20/github-chest-sheet/#%E5%BE%9E%E5%B7%A5%E4%BD%9C%E5%8D%80%E5%8E%BB%E9%99%A4%E5%A4%A7%E9%87%8F%E5%B7%B2%E5%88%AA%E9%99%A4%E6%96%87%E4%BB%B6) 感覺值得花時間看看~ 2018/07/19 新增



# 底下幾個指令自己太常用... 備註到最前面

```sh
# 首次設定 PKI
ssh-keygen -t rsa -b 4096 -C "tony@tonynb"

# 本地分支 push 至 origin
git push --set-upstream origin feature

# 設定本地分支追蹤的遠端分支
git branch --set-upstream-to=origin/feature feature

# 改變追蹤 URL
git remote set-url origin git@github.com:cool21540125/documentation-notes.git

# 重新 Commit
git commit --amend -m "<Commit String>"

# 基本重要設定
git config --global user.name "TonyCC"
git config --global user.email "cool21540125@gmail.com"
git config --global alias.tree "log --graph --decorate --pretty=oneline --abbrev-commit"

# 設定 git 預設的編輯器 (預設為 vim)
git config --global core.editor "notepad"
```

```sh
# 作業環境
$ uname -a
Linux tonynb 3.10.0-514.el7.x86_64 #1 SMP Tue Nov 22 16:42:41 UTC 2016 x86_64 x86_64 x86_64 

# 版本
$ git --version
git version 2.14.3
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

此節點標籤, 永遠代表最新的 commit
```sh
$ git show HEAD
# 顯示最新 commit的詳細資料
```


## git merge

把指定的分支, 合併到目前的分支
```sh
# 目前位於 branch A
# 打算合併 branch B
$ git merge B
#  B  A
#   \ |
#    \|
#     A
```


## git merge 「fast-forward merge」

讓 master分支, 沿著分支快轉前進(不會產生新的節點)
```sh
# 「O」代表每次 commit, (越下面的 commit表示越新,)
# 「*」代表目前所在分支
#
#  O master (較舊)
#   \
#    O 
#    |
#    O bug/123* (最新)

# Case1 - 合併 master與 bug/123 (合併後, 沒有留下合併的歷史紀錄)
$ git checkout master
$ git merge bug/123
#  O
#   \
#    O 
#    |
#    O bug/123, master*

# Case2 - 合併 master與 bug/123, 使用「--no-ff」 (合併後, 留下歷史紀錄)
$ git checkout master
$ git merge bug/123 --no-ff 
#  O
#  |\
#  | |
#  | O bug/123
#  | |
#  |/
#  O master*
```


## git merge 「3-way merge」

因為分支與 master 都有各自 commit了, 導致彼此的歷史沒有重疊
```sh
#         O 
#         |\
#         O | 
#         | O bug/123*
#  master O
$ git checkout master
$ git merge bug/123
#         O 
#         |\
#         O | 
#         | O bug/123
#         O |
#         |/
#         O master*
```


## git reset 取消提交

將 git檔案庫回復到某一個舊節點的狀態.
- 取消最近一次的合併動作
- **無法對 remote branch作用!!!!**
> `git reset HEAD^ --hard`, --hard, 表示資料夾中的檔案也要一起回復
```sh
# O C0               (old)
# |
# O C1
# |
# O C2 <-master      (new)

$ git reset HEAD^    # 把分支參考點退回上一個 commit (重寫歷史的概念)
# O C0
# |
# O C1 <-master
```


# git reset --hard

```sh
# !!! 如果本地已經有 git, 且已有最近一次的 Commit, ex:
# -----------------------------------
# * 2353tc9 (HEAD -> dev, origin/dev) 改寫部分結構
# * 745b529 修改架構
# * b8t58d7 縮減結構
# -----------------------------------

# 而在 2353tc9 的前提之下, 作了部分修改並存檔(還沒作 git add), 發現把東西弄壞了... 想回到乾淨的 2353tc9

# reset 前 ------------------------
$ git status
On branch structuremove
Your branch is up-to-date with 'origin/structuremove'.

Changes not staged for commit:              # 即將消失---------------------------
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   bis_emc/settings.py     # 即將消失---------------------------

Untracked files:    # 這裡的不會變動, 因為從頭到尾 git 都不認識
  (use "git add <file>..." to include in what will be committed)

        .vimrc
        bis.ini

no changes added to commit (use "git add" and/or "git commit -a")

# 大膽的回去
$ git reset --hard
HEAD is now at 2353tc9 改寫部分結構

# reset 後 ------------------------
$ git status
On branch structuremove
Your branch is up-to-date with 'origin/structuremove'.

Untracked files:    # 這裡的不會變動, 因為從頭到尾 git 都不認識
  (use "git add <file>..." to include in what will be committed)

        .vimrc
        bis.ini

nothing added to commit but untracked files present (use "git add" to track)
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


## cherry-pick (這...我不是很懂)
把某一個 commit節點的檔案版本, 合併到資料夾的檔案
```sh
$ git cherry-pick commit <節點標籤>
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


## git rebase

```sh

```



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

# 設定組態
$ git config --global user.name "TonyCC"
$ git config --global user.email "cool21540125@gmail.com"

# 忽略「空白」所造成的影響
$ git config --global apply.whitespace nowarn

# 增加Git輸出時的顏色
$ git config --global color.ui true
```

```sh
# 查看 分支 及 遠端追蹤情形
$ cat .git/config 
```


## 查詢、設定、移除 別名
> *設定別名* : `git config --<層級> alias.<縮寫名稱> <原始指令>`

> *移除別名* : `git config --<層級> --unset alias.<已建立的別名>`
```sh
$ git config --global alias.cm "commit -m"
# 將來可用 git cm "..." 來代替 git commit -m "..."

$ git config --global alias.unstage "reset HEAD --"     # 將檔案從 index中移除
# 將來可用 git unstage a.js 來取代 git reset HEAD a.js

$ git config --global alias.undo "reset --soft HEAD~1"  # 取消最近一次提交
# 將來可用 git undo a.js 來取代 git reset --soft HEAD~1 a.js

$ git config --global alias.tree "log --graph --decorate --pretty=oneline --abbrev-commit"
# 將來可用 git tree 來漂亮的看提交紀錄

$ git config --global alias.tree2 "log --graph --oneline --all --decorate"
# 將來可用 git tree2 來漂亮的看提交紀錄

$ git config --global push.followTags true  # ※ 好像沒有用處!!?? ※
# git push時, 連同 tag一起推送, git tag 
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

## 選項

選項 | 說明 | 範例 
--- | --- | ---
-s | 簡易資訊 | git status -s


## Git tag

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
- [保證簡單好懂得範例](./stash_example.md)


## git reset 改變範圍

param   | data in repo | git index | file in dir
------- |:------------:|:---------:|:------------:
--soft  | v            |           | 
--mixed | v            | v         | 
-- hard | v            | v         | v


## 建立新的git repo

> 參考: [共用儲存庫](https://ithelp.ithome.com.tw/articles/10132804)
```sh
$ git init
$ git init --bare
```


## 遠端分支

```sh
$ git config -l | grep master
branch.master.remote=origin
branch.master.merge=refs/heads/master
```

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
$ git tree
*   d3de22d (HEAD -> master, origin/master)  修改了XXX
|\
| | 287b263 (origin/develop) 這邊這邊~~~~
...

# 取消追蹤 origin 這個 remote 的 develop 分支
$ git branch -d -r origin/develop
Deleted remote-tracking branch origin/develop (was 287b263).

$ git tree
*   d3de22d (HEAD -> master, origin/master)  修改了XXX
|\
| | 287b263 這邊這邊~~~~
...
```


## 加入至stage狀態

[git add 差異說明](https://stackoverflow.com/questions/572549/difference-between-git-add-a-and-git-add)

> ※ 以下 `不保證完全正確`, 因為有版本問題...

script | New Files | Modified Files | Deleted Files | Sub-Folder Files
--- |:---:|:---:|:---:|:---:
git add -A | V | V | V | V
git add . | V | V | **`X`** | **`X`**
git add -u | **`X`** | V | V | ?

```sh
$ git add -i    # 建議使用互動式模式來加入檔案到stage狀態
$ git add .     # (不建議使用, 請用上者來代替)

# 把已經 git add 的檔案, 從已追蹤名單中移除
$ git rm --cached <檔名>
# ((--cached 也可以解釋成, 從快取中... 或 從 index中...))
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


## 刪除分支 移除分支

```sh
$ git branch -d <要刪除的分支名稱>
# 若該分支還沒作 merge, 則無法刪除

$ git branch -D <要刪除的分支名稱>
# 強制刪除
```


## 重新命名分支

```sh
$ git branch -m <新的分支名稱>
```


## 清理檔案庫

Git經過一段時間之後, .git的資料夾會變得無比的巨大, 可以使用下列指令來清理此檔案庫, 指令為
```sh
$ git gc
```

option       |                 說明
------------ | ----------------------------------------
N/A          | (預設) 會用比較快速的方式檢查&&清理
--aggressive | 最慢、最仔細
--auto       | Git自動判斷是否需要清理, 情況良好則不動作
--no-prune   | 不要清除repo, 而是用整了的方式


## 查詢歷史紀錄

> 語法: `git reflog <branchName>` , 查詢任何分支變動的歷史紀錄<br>
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
