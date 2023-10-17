
# ansible CLI

```bash
### Version
ansible --version
#ansible [core 2.14.2]
#  config file = None
#  configured module search path = ['/Users/tony/.ansible/plugins/modules', '/usr/share/#ansible/plugins/modules']
#  ansible python module location = /usr/local/lib/python3.10/site-packages/ansible
#  ansible collection location = /Users/tony/.ansible/collections:/usr/share/ansible/#collections
#  executable location = /usr/local/bin/ansible
#  python version = 3.10.9 (main, Dec 15 2022, 18:25:35) [Clang 14.0.0 (clang-1400.0.29.#202)] (/usr/local/opt/python@3.10/bin/python3.10)
#  jinja version = 3.1.2
#  libyaml = True


### ansible CLI
ansible ${Target} \
    -m ${ModuleName} \
    -a ${ModuleOptions} \
    -f ${N} \
    -i ${Path_To_PlanBook} \
    -u ${User} \
    --become \
    -K

# -f : 指定 parallel forks 的數量. ansible 預設高併發 5 個程序. 可用這個調高並行處理的程序數量.
# -u : 指定遠端執行的用戶
# -K, --ask-become-pass : 可加上這個, 來互動式詢問 privilege escalation 的密碼
# --become : 若為 poweruser, 加上這個不指定用戶, 則會使用 root 運行. 但也可指定使用特定用戶


### ansible ping
ansible host03 -m ping
#host03 | SUCCESS => {
#    "ansible_facts": {
#        "discovered_interpreter_python": "/usr/libexec/platform-python"
#    },
#    "changed": false,
#    "ping": "pong"
#}


### 使用 shell module 執行 指令字串(變數要用雙引號)
ansible hosts \
    -m ansible.builtin.shell \
    -a "echo 最常用的方式"


### 查看有哪幾台主機沒被分類到群組
ansible ungrouped --list-hosts
# hosts (4):
#   gitclient
#   gitclient01.ksu
#   gitclient02.ksu
#   gitclient03.ksu
# /etc/ansible/hosts 有上述 hosts 沒有被分類到 group


### ---------------------- 管理檔案 ----------------------
# 複製本地檔案到遠端 
ansible hosts -m ansible.builtin.copy -a "src=/etc/hosts dest=/etc/hosts"

# 改變遠端檔案/資料夾, 等同於做 chown & chmod
ansible app_server -m ansible.builtin.file -a "dest=/data/a.txt mode=755"

# (承上)加上 state=directory, 可用來建立 Dir
ansible app_server -m ansible.builtin.file -a "dest=/data/app_dir mode=755 owner=mdehaan group=mdehaan state=directory"

# state=directory, 清除遠端特定資料夾 (用來清 Nginx cache)
ansible nginx_proxy -m ansible.builtin.file -a "dest=/data/nginx_cache state=absent"

# 將本地 tar file 解壓縮到遠端(目錄必須事先存在)
ansible nginx_proxy -m unarchive -a "src=foo.tar.gz dest=/tmp/abc"


### ---------------------- 管理套件 ----------------------
# 使用 yum 安裝套件
ansible hosts -m ansible.builtin.yum -a "name=acme state=present"

# (承上)還可以指定版本
ansible hosts -m ansible.builtin.yum -a "name=acme-1.5 state=present"

# (承上)確保安裝到最新版
ansible hosts -m ansible.builtin.yum -a "name=acme-1.5 state=latest"

# 移除套件 
ansible webservers -m ansible.builtin.yum -a "name=acme state=absent"


### ---------------------- 管理用戶 ----------------------
### 建立用戶
ansible all -m ansible.builtin.user -a "name=foo password=這是密碼"

### 砍人
ansible all -m ansible.builtin.user -a "name=foo state=absent"


### ---------------------- 管理服務 ----------------------
# 讓遠端 Nginx start
ansible nginx -m ansible.builtin.service -a "name=nginx state=started"

# 讓遠端 Nginx stop
ansible nginx -m ansible.builtin.service -a "name=nginx state=stopped"

# 讓遠端 Nginx reload
ansible nginx -m ansible.builtin.service -a "name=nginx state=reloaded"


### ---------------------- 未整理 ----------------------
# 列出 ansible tower 可使用的 Host Groups
ansible localhost -m debug -a 'var=groups'

# 叫 web 下載 Git repo
ansible web -m git -a "repo=git@github.com:cool21540125/documentation-notes.git dest=/tmp/illu version=HEAD"

# 檢查系統資訊
ansible hosts -m setups

# 功能相當於 sed -i, 只是是用來改遠端檔案
ansible all -m lineinfile -a 'dest=/etc/zabbix/zabbix_agentd.conf line="Server=112.121.164.2" regexp="^Server=" ' -f 50
# -f 50, 使用高併發來做處理
```


# Study - [How to install docker on RHEL using Ansible role](https://medium.com/@knoldus/how-to-install-docker-on-rhel-using-ansible-role-62728c098351)

- 2022/09/08 (尚未完成)
- 摘要記錄
    - 這篇使用 ansible role 來安裝 docker
    - role 是用來簡化 playbook, 將之拆分成 files, tasks, templates, variables, ... 以達模組化, 重複利用

```bash
ansible --version
#ansible 2.9.23
#  config file = /etc/ansible/ansible.cfg
#  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
#  ansible python module location = /usr/lib/python2.7/site-packages/ansible
#  executable location = /bin/ansible
#  python version = 2.7.18 (default, May 25 2022, 14:30:51) [GCC 7.3.1 20180712 (Red Hat 7.3.1-15)]


### 建立 ansible role
ansible-galaxy init install_docker
tree install_docker
#install_docker
#├── defaults
#│   └── main.yml
#├── files
#├── handlers
#│   └── main.yml
#├── meta
#│   └── main.yml
#├── README.md
#├── tasks
#│   └── main.yml
#├── templates
#├── tests
#│   ├── inventory
#│   └── test.yml
#└── vars
#    └── main.yml
#
#8 directories, 8 files


### 

```
