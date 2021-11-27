# CentOS8.0


# Ansible

- 2020/03/10
- https://www.theurbanpenguin.com/ansible-rhce-the-new-system-administration-3/

```bash
### (RedHat Only) 列出 repo names
$# subscription-manager repos
$# subscription-manager repos --enable ansible-2-for-rhel-8-x86_64-rpms

### CentOS8 作
$# yum install -y epel-release
$# yum install -y ansible

$# ansible --version
ansible 2.9.5
  config file = /etc/ansible/ansible.cfg  # 預設會吃這裡
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.6/site-packages/ansible
  executable location = /bin/ansible
  python version = 3.6.8 (default, Nov 21 2019, 19:31:34) [GCC 8.3.1 20190507 (Red Hat 8.3.1-4)]

# 如果本地端, 多了個 ./ansible.cfg
# 則 ansible --version 會指向本地端的 ./ansible.cfg
```
