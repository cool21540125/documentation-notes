# Ch13 - Installing and Updating Software Packages

1. rpm
2. yum

CentOS 的世界, 並沒有 xxx.yum 這東西, 所有套件都是 `xxx.rpm`, 然後你可以透過 `rpm xxx.rpm` 來作安裝, 但因為套件之間有相依性, 所以都可以透過 `yum install xxx(其實 xxx 就是 xxx.rpm)` 來作安裝, 而 yum 會額外幫你安裝其他必備的 rpm 而已.

## 1. rpm

命名方式大概長這樣 : `name-version-release.architecture`

```
httpd-tools-2.4.6-7.el7.x86_64.rpm
___________ _____ _____ ______
     1        2     3     4
1.Name : 套件名稱
2.Version : 原始軟體版本
3.Release : 套件打包版本
4.Arch : (不知道怎麼解釋), 有 i386, i686, x86_64, noarch, ...
```

CentOS 的所有套件, 都是 `xxx.rpm`, 但如果單獨安裝 `xxx.rpm` 時, 時常會失敗, 因為它會跟你說因為缺少了 ooo 還有 ooo 所以無法安裝...

```sh
# 查詢`系統內`, 已經安裝的套件
rpm -qa | grep '套件名稱'
```


## 2. yum (rpm 的管理員)

### 2-1. yum 基本使用

yum 自己幫你作 `套件相依性的管理`, 所以常安裝某個東西的時候, 會發現它怎麼常幫你裝一大包的東西...

```sh
yum install httpd
yum update httpd
yum remove httpd

yum repolist        # Repo 設定檔有變動過, 務必執行確認是有無誤(檢查 /etc/yum.repo.d/*.repo 的設定)
yum clean all       # 清除 /var/cache/.../*.rpm (所有 yum 所下載下來的暫存目錄)
```

### 2-2. Repository

- /etc/yum.conf
- /etc/yum.repos.d/*

```sh
### root
vim /etc/yum.repos.d/CentOS-Base.repo

[base]
name=httpd
baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/      ← http://mirror.centos.org/centos/7/os/x86_64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# 格式
[Repo_ID]       # (Necessary)
name=...        # (Necessary)
baseurl=...     # http://... (Necessary)
enabled=1       # 是否查找此 Repository (沒給預設=1)
gpgcheck=1      # 使否作 GPG 安全性檢查 (沒給預設=1)
gpgkey=...      # https://... (gpgcheck=1 則須給此欄位)
```

其它比較有名的遠端儲存庫

- RHEL: Red Hat Enterprise Linux (CentOS沒辦法用它)
- EPEL: Extra Packages for Enterprise Linux (Red Hat 贊助開發的 beta 版測試套件, 不保證穩定!)

#### 2-2-1. Example 安裝 Google Chrome

```sh
### root
# 1.編輯 Repo
vim /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub

# 2.安裝
yum -y install google-chrome-stable
```

#### 2-2-2. Example 安裝 Docker

```sh
### root
# 1.相依套件安裝
yum install -y yum-utils device-mapper-persistent-data lvm2

# 2. 下載 Repo (透過 yum-config-manager 把下載下來的 Repo 檔放到  /etc/yum.repos.d/docker-ce.repo )
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 3. 安裝
yum install -y docker-ce
```


#### 2-2-3. More Example

- [Install xxx on CentOS7](https://github.com/cool21540125/documentation-notes/blob/master/linux/install/installCentOS7.md)


### 2-3. 補充

```sh
yum list 'http*'                    # 查線上關於 http* 的套件

yum search all 'web server'         # 可以給關鍵字, 會到線上查詢相關套件(連套件的說明都會找)

yum info httpd                      # 查線上關於套件的說明

yum provides /var/www/html          # 可以給特定資料夾, yum 會幫你到線上去查這資料夾應該是安裝啥套件

yum provides httpd                  # 也可以像這樣, 幫你查套件完整名稱

yum update kernel                   # 可升級新版 Kernel(CentOS可以一次裝很多個核心版本)

yum grouplist                       # 查詢群組套件

yum groups install "Web Server"     # 安裝群組套件
```
