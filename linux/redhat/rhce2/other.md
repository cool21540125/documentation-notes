# 下面都還很亂  還沒整理

```sh
$ grep cat /usr/share/dict/linux.words

# ''內, shell 視為純文字 ; grep 對於 '' 內, 有 Regex 功能
$# grep '^cat' /usr/share/dict/linux.words

# 從 f1 檔案內, 找出 字開頭=「t」 && 字結尾=「e」
$ grep '\<the\>' f1

# 尋找 /etc 底下所有檔案, 內含 'example.com' 的所有文字 (超強大!)
$ grep -rn 'example\.com' /etc
# -r : recursive
# -n : Line Number

$ 

$ ps afx | grep -B1 ssh-agent
# f : forest 樹狀結構
# B1 : 可看上一層
```


## grep + regex

Option | Function
------ | ------------------------
-i     | Case insensitive
-v     | 找到的不 show ; 只 show 沒找到的
-r     | 尋找目標資料夾底下所有與 pattern match 的所有檔名
-A     | 與 pattern match 之後的幾行
-B     | 與 pattern match 之前的幾行
-e     | 



# 2018/08/29

## Ch4 - Scheduling future linux Tasks

工作排程區分為:

- [一次行排程 at](#at)
- [週期性排程 cron](#cron)

### at

atd.service - 一次行排程服務

```sh
$# ll /usr/bin/at
-rwsr-xr-x. 1 root root 52952  1月 25  2018 /usr/bin/at
```

- `at + 一堆option` : 製作一次行排程工作
- `atq` : 可以查看 at 的 queue
- `atrm <number>`: 移除已掛但未執行的一次行排程

at 會把 `Standard Output` && `Standard Error` 都用 mail 寄信給 root

```sh
$ echo "date > ~/myjobGG" | at now +3min
job 6 at Wed Aug 29 20:42:00 2018

$ atq
6       Wed Aug 29 20:42:00 2018 a tony
# 
```




```sh
# pipe line 來寄信
$ mail -s test1 root < /etc/hosts
$ cat /etc/hosts | mail -s test2 root
```


### cron

- `crond.service` - 週期性排程服務

```sh
$# ll /usr/bin/crontab
-rwsr-xr-x. 1 root root 57576  8月  3  2017 /usr/bin/crontab

# 列出目前使用者的 所有 週期性工作
$ crontab -l

# 移除目前使用者的 所有 週期性工作
$ crontab -r

# 以現有使用者, 來編輯 週期性工作
$ crontab -e

# root 去編輯別人的 週期性工作
$# crontab -u <username> -e xxx
```

```sh
0       9       2       2       *       xxx     # 每年 2/2 9:00
*/7     9-16    *       Jul     5       xxx     # 
1-59/2  16-21   *       *       1-5     xxx     # 16-21點, 每2分鐘
```


### 





# review2

```sh
rht-vmctl reset server
rht-vmctl reset desktop
```


## Server

```sh
lab sa2-review setup
```


## Server
