
# Ansible - Environment Variables

```bash
### 指定後續使用 ansible CLI 的時候套用的 config
export ANSIBLE_CONFIG=~/ansible/ansible.cfg


### ??
export ANSIBLE_GATHERING=explicit
export ANSIBLE_GATHERING=implicit


### 
export ANSIBLE_NOCOWS=1
# 我覺得有點蝦的東西XD 目前還不懂它作用是啥就是了


### 

```


# Magic Variables / Special Variables

- `{{ hostvars['web1'].ansible_host }}` - 可得知 hostfile 其他 host 的 attributes
- `{{ groups['xx'] }}`                  - 可得知 xx groups 有哪些 hosts
- `{{ group_names }}`
- `{{ inventory_hostname }}`