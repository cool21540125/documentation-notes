
```bash
### 列出 ansible tower 可使用的 Host Groups
ansible localhost -m debug -a 'var=groups'

### 
```


```sh
### 檢查所有主機, 是否以 tony 建立了 Ansible 管理主機可存取的環境
$ ansible all -m ping -u tony

### 所有主機, 與目前 bash 相同使用者, 在遠端主機執行 'echo hi~'
$ ansible all -a "/bin/echo hi~"

### 複製 /etc/hosts 到 db 這台的 /home/tony/hosts
$ ansible db -m copy -a "src=/etc/hosts dest=/home/tony/hosts"

### app 這台, 安裝套件
$ ansible app -m yum -a "name=acme state=present"

### 所有主機建立使用者
$ ansible all -m user -a "name=cool21540125 password=<加密後密碼>"

### web 這台, 下載 Git repo
$ ansible web -m git -a "repo=git@github.com:cool21540125/documentation-notes.git dest=/tmp/illu version=HEAD"

### app2 這台, 啟動服務
$ ansible app2 -m service -a "name=httpd state=started"

### lb 這台, 並存 10 個重啟
$ ansible lb -a "/sbin/reboot" -f 10

### 檢查所有主機, 全部系統資訊
$ ansible all -m setup
```