# 早期(2017/03) 學 Ubuntu的筆記

dpkg為Debian-based系統管理增刪建立套件的相關指令

```sh
# 顯示所有已安裝套件
$ dpkg -l

# 安裝了哪些相關套件, ex: python
$ dpkg -l | grep python

# 特定套件所安裝的所有檔案, ex: python
$ dpkg -L python

# 某資料夾底下有多少個 installed package
$ dpkg -S /usr

# 更改預設 desktop, music等資料夾
$ gedit ~/.config/user-dirs.dirs
```


## JDBC Driver
- [安裝 MySQL JDBC](http://stackoverflow.com/questions/18128966/where-is-the-mysql-jdbc-jar-file-in-ubuntu)

```sh
$ sudo apt-get install libmysql-java

# 如此一來, /usr/share/java/mysql.jar
# 就會出現了!
```