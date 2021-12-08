# Ubuntu 使用 MongoDB

- 2018/06/23

```sh
# 安裝:
# 版本可能會改變...(到官方網站看最新版本)
$ wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.2.tgz

# 執行解壓縮
$ tar -xf mongodb-linux-x86_64-ubuntu1604-3.4.2.tgz

# 建立資料庫儲存的目錄
$ sudo mkdir /data

# 進入解壓縮後的monboDB資料夾
$ cd /data
$ cd mongodb-linux-x86_64-ubuntu1604-3.4.2

# (無安裝)啟動MongoDB
$ sudo ./mongod
# 如果看到... 
# 2017-03-20T19:28:31.684+0800 I NETWORK  [thread1] waiting for connections on port 27017
# 表示已經成功啟動MongoDB

# 安裝檔案 (目前位於:MongoDB的安裝資料夾裡頭的bin)
$ cd bin
$ sudo ./mongod --logpath=/data/mongo.log --fork
# (出現下列，表示啟用成功)
sudo: unable to resolve host tony
about to fork child process, waiting until server is ready for connections.
forked process: 2822
child process started successfully, parent exiting

# 查看是否有MongoDB在背執行
$ ps -aux | grep mongo
$ netstat -nao | grep 27017
```


## MongoDB設定檔修改

parameter | default
--------- | -------------------
dbpath    | /data/db
logpath   | (Null)
bind_ip   | 0.0.0.0
port      | 27017


### mongo.cfg範例

```cfg
bind_ip = 127.0.0.1
port = 10000
dbpath = data/db
logpath = data/mongod.log
logappend = true
journal = true
```
