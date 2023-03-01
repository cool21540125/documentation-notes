
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


# Ansible concepts

- Control node
    - Windows 無法作為 control node
    - 藉由 受控節點的清單(inventory), 也稱之為 hostfile 來控制
- Managed nodes
    - 被操作的 受控節點/網路設備, 也稱之為 `hosts`
    - 這些機器上面只需要有 python 即可. 不需要安裝 ansible
- Ansible Tower
    - 企業級框架(也有 community 版本)
    - 可透過 UI & RESTful API 做 controlling, securing, managing, extending...


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


#### Example:

```yaml
### deploy.yaml
# 安裝 Apache && 改設定檔 && 寫 index.html && 啟動 Apache
---
- hosts: web
  remote_user: root
  vars:
    http_port: 80
    max_clients: 800
  tasks:
  - name: install apache in the newest version
    yum: pkg=httpd state=latest
  - name: config file
    template: src=templates/httpd.conf.j2 dest=/etc/httpd/conf/httpd.conf
    notify:
    - restart apache
  - name: index file
    template: src=templates/index.html.j2 dest=/var/www/html/index.html
  - name: start apache
    service: name=httpd state=started

# 事件處理方式(多次觸發只執行一次, ex: 重開機後...)
handlers:
  - name: restart apache
    service: name=httpd state=restarted
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
        - tasks     : 裡頭存放 role 會執行的 task list
            ```yml
              # tasks/main.yml
            - name: xxx
              import_tasks: abc.yml
              when: ooo
            - name: yyy
              ansible.builtin.yum:
                name: httpd
                state: present
            ```
        - templates : 此 role deploy 的 templates
        - vars      : other variables of the role
        - (也可使用客製化的 modules / module_utils / plugins)
    - ansible 會在底下的這些 locations 來尋找 roles:
        - collections (如果有使用的話)
        - roles/ 資料夾內
        - `roles_path` 變數定義的位置
            - 預設搜尋路徑為: `~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles`
        - playbook 所在的位置
        - 或是甚至在要執行的 yml 裡頭定義:
            ```yml
            - hosts: webservers
              roles:
                - role: '/path/to/roles'
            ```


# Ansible 替代品 (但都沒 ansible 來得容易)

- Puppet
- Chef
- Salt


# Other

```bash
### Udemy 課程, 講師製作的 Docker Lab (模擬 ansible hosts)
$# docker run -it -d --name ansible-lab-1 -p 2223:22 mmumshad/ubuntu-ssh-enabled
$# ssh -p 2223 root@localhost
# 密碼為「Passw0rd」


$# docker inspect ansible-lab-1 | grep '^ *"IPAddress": ' | head -n 1
# 找出 IP, ex: 「172.17.0.2」


### 
$# 
```
