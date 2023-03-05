
# Structure

```sh
### -------- Structure in system --------
/etc/
    /ansible/       # ansible 組態目錄
        /ansible.cfg  # ansible 設定主檔
        /hosts        # ansible 自己管理的 主機清單(Host Inventory)
        /roles/       # 配置檔 roles_path 的最後搜尋 roles 的路徑
/usr/
    /share/           # 模組位置
$HOME/
    /.ansible/
    /ansible.cfg
        /tmp/         # remote_tmp 及 local_tmp

### 設定檔順序
# Ansible 預設組態主檔 /etc/ansible/ansible.cfg
# 設定檔參考順序為(先找到先適用):
# 1. ANSIBLE_CONFIG (環境變數)
# 2. ansible.cfg (current dir)
# 3. .ansible.cfg (home dir)
# 4. /etc/ansible/ansible.cfg (最後才參考設定主檔)

### -------- Structure in ansible project --------
/project_root
    /role
        /tasks
        /vars
        /defaults
        /handlers
        /templates
```


# ansible.cfg

```ini
[defaults]
inventory = hosts

remote_user = vagrant
#private_key_file = ~/.ssh/id_rsa

# host_key_checking
host_key_checking = False

### 如果 playbook directory structure 找不到 roles, 則會來這邊找 role
roles_path = /etc/ansible/roles
# (不知能否這樣寫... 但他如同 PATH)
# ex: ~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
```


# inventory hosts

```sh
# ex: /etc/ansible/hosts

[all_groups:children]
group1
group2

web1 ansible_host=w14301.example.com
web2 ansible_host=w17802.example.com
```

## 拆分 inventory

```sh
### ------ Inventory file ------
servers_g1
servers_g2
# 避免在 inventory 裡面寫一堆雜亂的 host, user, password, ...


### ------ Sample variable file - host_vars/servers_g1.yaml ------
ansible_ssh_pass: Passw0rd
ansible_host: 192.168.94.87
# 總之這檔案, 要放在 inventory file 同層的 「host_vars」 資料夾底下就對了
# 檔名要同 inventory file 裡面的 host

### 同理, 也會有 「group_vars/」
```


# [Collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html#collections)

- 包含 playbooks, roles, modules, plugins
- 其中一種使用方式, 可藉由 [Ansible Galaxy](https://galaxy.ansible.com/?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW) 來安裝
- [Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
    - Ansible role 有個已預先定義好的資料夾結構, 包含底下 7 個 dirs, role 裡頭至少須包含其中一個:
        - defaults  : role 裡頭的 default variables(優先性最低)
        - files     : 此 role deploy 的 files (也可以是 deploy 後執行的腳本)
        - handlers  : 也可被此 role 外部使用
        - meta      : role metadata; 包含 role dependencies
        - tasks     : 裡頭存放 role 會執行的 task list. ex: 'tasks/main.yaml'
        - templates : 此 role deploy 的 templates
        - vars      : other variables of the role
        - (也可使用客製化的 modules / module_utils / plugins)
    - ansible 會在底下的這些 locations 來尋找 roles:
        - collections (如果有使用的話)
        - roles/ 資料夾內
        - `roles_path` 變數定義的位置
        - playbook 所在的位置
