
```bash
### 使用 galaxy 初始化
$# mkdir -p my_playbook/roles
$# touch my_playbook/my_playbook.yaml

### 使用 galaxy 建立 role
$# ansible-galaxy init my_playbook/roles/my_custom_role
- Role my_playbook/roles/my_custom_role was created successfully

$# tree my_playbook 
my_playbook
├── my_playbook.yaml
└── roles
    └── my_custom_role
        ├── README.md
        ├── defaults
        │   └── main.yml
        ├── files
        ├── handlers
        │   └── main.yml
        ├── meta
        │   └── main.yml
        ├── tasks
        │   └── main.yml
        ├── templates
        ├── tests
        │   ├── inventory
        │   └── test.yml
        └── vars
            └── main.yml


### 使用 CLI 尋找是否有相關的 roles
$# ansible-galaxy search mysql
 geerlingguy.gogs        Gogs: Go Git Service
 geerlingguy.homebrew    Homebrew for macOS
 geerlingguy.mysql       MySQL server for RHEL/CentOS and Debian/Ubuntu.
 geerlingguy.php         PHP for RedHat/CentOS/Fedora/Debian/Ubuntu.
 # (僅節錄部分)

### 
$# ansible-galaxy install geerlingguy.mysql -p /tmp
ansible-galaxy install geerlingguy.mysql
Starting galaxy role install process
- downloading role 'mysql', owned by geerlingguy
- downloading role from https://github.com/geerlingguy/ansible-role-mysql/archive/4.3.2.tar.gz
- extracting geerlingguy.mysql to /private/tmp/geerlingguy.mysql
- geerlingguy.mysql (4.3.2) was installed successfully
# -p xxx : 可自行指定安裝路徑, 否則會依照配置來放


### 列出 galaxy 安裝多少 roles 了
$# ansible-galaxy list
# 但 Mac 這個好像有點...智障


### 依照 ansible config 找出相關配置
$$# ansible-config dump | grep ROLE
DEFAULT_ROLES_PATH(default) = ['/Users/tony/.ansible/roles', '/usr/share/ansible/roles', '/etc/ansible/roles']
# 僅節錄部分
```
