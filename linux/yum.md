

## 個別套件

- yum list 'httpd*' :
- `yum search '用關鍵字查'` : 用來前往 yum server 尋找有沒有關鍵字描述的軟體
- yum search search all 'key words' : 同上, 但會額外找 軟體備註欄位有描述到的關鍵字的軟體
- yum info httpd : info 後面的東西, 名字得完全符合
- `yum provides /var/www/html` : 不管電腦內有沒有, 只要 `/etc/yum.repos.d/*.repo` 查得到東西, 就可以查到相關資訊
- yum install XXX


## 群組套件

- yum groups list
- yum groups info
- yum history
- yum history info
- yum history undo
- yum groups install XXX
- yum remove
- yum groups remove


```sh
# 設定光碟為 Repository
# Repository內一定要有 xxxxdata
vim /etc/yum.repo.d/dvd.repo
#[DVD]
#name=CentOS7 DVD
#baseurl=file:///run/media/disk/CentOS\ 7\ x86_64/
#enabled=1
#gpgcheck=1
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

yum repolist
```


```sh
rpm -qa | grep httpd

rpm -ql httpd

rpm -qpc xxx
# -c : 路徑


# 本地 rpm 安裝
rpm -ivh XXX


### 建議用 localinstall
yum localinstall --nogpgcheck XXX
# 可自動幫忙解決相依性
# 也可留下 Log
# yum history info <number>
```