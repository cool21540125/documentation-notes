



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


## [Collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html#collections)

- 包含 playbooks, roles, modules, plugins
- 其中一種使用方式, 可藉由 [Ansible Galaxy](https://galaxy.ansible.com/?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW) 來安裝



## Tasks

- action 的單位, 即為 task
- 可使用 ad hoc command 來執行一個 task


## [Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#about-playbooks)



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
    - 


# Ansible 替代品 (但都沒 ansible 來得容易)

- Puppet
- Chef
- Salt