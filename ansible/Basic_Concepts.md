
# Ansible Automation Platform

## The Ansible project

- 由 RedHat open source community 貢獻


## Ansible Engine

- 由 Ansible community project 發展而來


## Ansible Tower

- 企業級框架, 可透過 UI & RESTful API 做 controlling, securing, managing, extending...
- 也有 community 版本


# Ansible concepts

## Control node

- 在安裝好 ansible 的機器上面, 運行 `ansible` / `ansible-playbook`, 操作所有已安裝 python 的節點.
- Windows 無法作為 control node


## Managed nodes

- 被操作的 受控節點/網路設備, 也稱之為 `hosts`
- 這些機器上面只需要有 python 即可. 不需要安裝 ansible


## [Inventory](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#intro-inventory)

- 受控節點 的清單, 該清單稱之為 `hostfile`
- 可在此清單上面, 定義 hosts IP.
- 可有多份的 hostfile, 用來分組控制 hosts


## [Collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html#collections)

- 包含 playbooks, roles, modules, plugins
- 其中一種使用方式, 可藉由 [Ansible Galaxy](https://galaxy.ansible.com/?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW) 來安裝


## Modules

- Ansible 執行 code 的單位


## Tasks

- action 的單位, 即為 task
- 可使用 ad hoc command 來執行一個 task


## [Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#about-playbooks)

- 可用來彙整 tasks, 可用來管理重複執行的任務
- 裡頭也可像是 task 一樣, 定義變數
- YAML file



# Ansible 替代品 (但都沒 ansible 來得容易)

- Puppet
- Chef
- Salt