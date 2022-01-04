# 追蹤遠端分支
- 2018/06/17
- 這範例真他媽有點詭異

> 專案之間相似行頗高, 想把一個專案丟給A, B 客戶; <br> 
    A客戶 -> master 追蹤 `p1 分支` <br> 
    B客戶 -> master 追蹤 `p2 分支` <br>
    底下來模擬該如何實作



## 底下範例嘗試實作下面的狀況
```
  B客戶 p2分支    
  
  * (第一版)
   \        
    \      
     \
      \
       \       A客戶 p1分支  
        \      
         \     * (第二版)
          \    | 
           \   * (第一版)
            \ /
             *    master
```

## Prerequest

- 2組 github帳號
    - cool21540125
    - test21540125
- 3台 電腦
    - Host : 開發端 -> cool21540125
    - vm1  : A客戶  -> test21540125 (客戶端帳號)
    - vm2  : B客戶  -> test21540125 (客戶端帳號)


# Prerequest
- 熟悉 git add, git commit, git branch, git pull, git push
- 熟悉 git hub, 並改以 ssh協定傳輸



## 1. Host (cool21540125)

```sh
$ git init qq
$ cd qq
$ echo "Initialization~" >> README.md
$ git add .
$ git commit -m "Init commit"

# 前往 Github, 建立空專案, 名為 qq

$ git remote add origin git@github.com:cool21540125/qq.git

### push master 前
$ git branch -av
* master                                  2de1ad2 init commit
$ git branch -rv                  
$ git branch -vv                  
* master                                  2de1ad2 init commit

$ git push -u origin master

### push master 後
$ git branch -av
* master                                  2de1ad2 init commit
  remotes/origin/master                   2de1ad2 init commit ##

$ git branch -rv                  
  origin/master                           2de1ad2 init commit ##

$ git branch -vv                  
* master                                  2de1ad2 [origin/master] init commit ##

$ git checkout -b p1
$ touch f1
$ git add .
$ git commit -m "f1"


$ git push --set-upstream origin p1


### push p1 後
$ git branch -av
  master                2de1ad2 init commit
* p1                    feaef67 f1
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1

$ git branch -vv
  master 2de1ad2 [origin/master] init commit
* p1     feaef67 [origin/p1] f1

$ git checkout master
$ git checkout -b p2
$ touch ff1
$ git add .
$ git commit -m "ff1"



### push p2 後
$ git push --set-upstream origin p2

$ git branch -av
  master                2de1ad2 init commit
  p1                    feaef67 f1
* p2                    7db764a ff1             # p2分支新增
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1
  remotes/origin/p2     7db764a ff1             # p2分支新增

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1
  origin/p2     7db764a ff1                     # p2分支新增

$ git branch -vv
  master 2de1ad2 [origin/master] init commit
  p1     feaef67 [origin/p1] f1
* p2     7db764a [origin/p2] ff1                # p2分支新增
```






## 2. vm1 - A客戶端 (test21540125)
```sh
$ git clone git@github.com:cool21540125/qq.git
$ cd qq
$ ls
README.md


### pull p1 前

$ git branch -av
* master                2de1ad2 init commit
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1
  origin/p2     7db764a ff1

$ git branch -vv
* master 2de1ad2 [origin/master] init commit

$ git log --oneline --graph
* 2de1ad2 (origin/master, origin/HEAD) init commit


$ git pull origin p1


### pull projA 後 ( 在 master 上, pull p1 )
$ git branch -av
* master                feaef67 [ahead 1] f1        # master -> feaef67 (最新的 p1 branch)
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1
  origin/p2     7db764a ff1

$ git branch -vv
* master feaef67 [origin/master: ahead 1] f1        # master -> feaef67 (最新的 p1 branch)

$ git log --oneline --graph
* feaef67 (HEAD -> master, origin/p1) f1
* 2de1ad2 (origin/master, origin/HEAD) init commit

$ ls
README.md a.txt
```

## 3. vm2 - B客戶端 (test21540125)

```sh
$ git clone git@github.com:cool21540125/qq.git
$ cd qq
$ ls
README.md



### pull p2 前

$ git branch -av
* master                2de1ad2 init commit
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1
  origin/p2     7db764a ff1

$ git branch -vv
* master 2de1ad2 [origin/master] init commit

$ git log --oneline --graph
* 2de1ad2 (HEAD -> master, origin/master, origin/HEAD) init commit




$ git branch --set-upstream-to=origin/p2 master          # 設定 master -> origin/p2
Branch master set up to track remote branch p2 from origin.



### 設定 追蹤遠端分之 後
$ git branch -av
* master                2de1ad2 [behind 1] init commit
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1
  origin/p2     7db764a ff1

$ git branch -vv
* master 2de1ad2 [origin/p2: behind 1] init commit

$ git log --oneline --graph
* 2de1ad2 (HEAD -> master, origin/master, origin/HEAD) init commit


$ git pull



### pull p2 後
$ ls
README.md   ff1
$ git branch -av
* master                7db764a ff1
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1
  origin/p2     7db764a ff1

$ git branch -vv
* master 7db764a [origin/p2] ff1

$ git log --oneline --graph
* 7db764a (HEAD -> master, origin/p2) ff1
* 2de1ad2 (origin/master, origin/HEAD) init commit
```






## 4. Host (cool21540125) -> projA進版

```sh
$ git checkout p1
$ ls
f1 README.md

$ touch f2
$ git add .
$ git commt -m "f2"


### push p1 第二版前
$ git branch -av
  master                2de1ad2 init commit
* p1                    74ee335 [ahead 1] f2
  p2                    7db764a ff1
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1
  origin/p2     7db764a ff1

$ git branch -vv
  master 2de1ad2 [origin/master] init commit
* p1     74ee335 [origin/p1: ahead 1] f2
  p2     7db764a [origin/p2] ff1

$ git log --oneline --graph
* 74ee335 (HEAD -> p1) f2
* feaef67 (origin/p1) f1
* 2de1ad2 (origin/master, origin/HEAD, master) init commit


$ git push


### push p1 第二版後
$ git branch -av
  master                2de1ad2 init commit
* p1                    74ee335 f2
  p2                    7db764a ff1
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     74ee335 f2
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     74ee335 f2
  origin/p2     7db764a ff1

$ git branch -vv
  master 2de1ad2 [origin/master] init commit
* p1     74ee335 [origin/p1] f2
  p2     7db764a [origin/p2] ff1

$ git log --oneline --graph
* 74ee335 (HEAD -> p1, origin/p1) f2
* feaef67 f1
* 2de1ad2 (origin/master, origin/HEAD, master) init commit

```


## 5. vm1 - A客戶端 (test21540125) -> 更新版本

```sh
$ gir branch 
* master


### git pull 前
$ ls
README.md   f1

$ git branch -av
* master                feaef67 [ahead 1] f1        ## 領先一個 commit
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     feaef67 f1                  ## 
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     feaef67 f1                          ## 
  origin/p2     7db764a ff1

$ git branch -vv
* master feaef67 [origin/master: ahead 1] f1

$ git log --oneline --graph
* feaef67 (HEAD -> master, origin/p1) f1            ## 注意這邊
* 2de1ad2 (origin/master, origin/HEAD) init commit


$ git pull
remote: Counting objects: 2, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 2 (delta 0), reused 2 (delta 0), pack-reused 0
Unpacking objects: 100% (2/2), done.
From github.com:cool21540125/qq
   feaef67..74ee335  p1         -> origin/p1        ## 別被這個騙了!!
Already up-to-date.                                 ## 早就已經是最新的了


### git pull 後
$ ls
README.md   f1                                      ## 沒更新

$ git branch -av
* master                feaef67 [ahead 1] f1        ## 依然領先一個 commit
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     74ee335 f2                  ## changed
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     74ee335 f2                          ## changed
  origin/p2     7db764a ff1

$ git branch -vv
* master feaef67 [origin/master: ahead 1] f1

$ git log --oneline --graph
* feaef67 (HEAD -> master) f1                       ## 預料外的改變!
* 2de1ad2 (origin/master, origin/HEAD) init commit


## git pull origin p1 後
$ ls
README.md  f1  f2

$ git branch -av
* master                74ee335 [ahead 2] f2
  remotes/origin/HEAD   -> origin/master
  remotes/origin/master 2de1ad2 init commit
  remotes/origin/p1     74ee335 f2
  remotes/origin/p2     7db764a ff1

$ git branch -rv
  origin/HEAD   -> origin/master
  origin/master 2de1ad2 init commit
  origin/p1     74ee335 f2
  origin/p2     7db764a ff1

$ git branch -vv
* master 74ee335 [origin/master: ahead 2] f2

$ git log --oneline --graph
* 74ee335 (HEAD -> master, origin/p1) f2
* feaef67 f1
* 2de1ad2 (origin/master, origin/HEAD) init commit
```

# Result

### A客戶
```sh
$ git log --oneline --graph
* 74ee335 (HEAD -> master, origin/p1) f2
|
* feaef67 f1
|
* 2de1ad2 (origin/master, origin/HEAD) init commit
```

### B客戶
```sh
$ git log --oneline --graph
* 7db764a (HEAD -> master, origin/p2) ff1
|
* 2de1ad2 (origin/master, origin/HEAD) init commit
```
