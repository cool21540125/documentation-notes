



# Install ansible

```bash
### 直接這樣就可以安裝了...
$# ansible
bash: ansible: command not found...
Install package 'ansible-core' to provide command 'ansible'? [N/y] y


 * Waiting in queue...
The following packages have to be installed:
 ansible-core-2.12.2-3.1.el8.x86_64     SSH-based configuration management, deployment, and task execution system
Proceed with changes? [N/y] y

 * Waiting in queue...
 * Waiting for authentication...
 * Waiting in queue...
 * Downloading packages...
 * Requesting data...
 * Testing changes...
 * Installing packages...
# 略...

$# ansible --version
ansible [core 2.12.2]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.8/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /bin/ansible
  python version = 3.8.12 (default, May 10 2022, 23:46:40) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]
  jinja version = 2.10.3
  libyaml = True

### 由 python3.8 pip 安裝 ansible
$# python3.8 -m pip freeze | grep ansible
ansible-core==2.12.2

$# ansible -m setup localhost | grep python_version
        "ansible_python_version": "3.8.12",
# 會對於 localhost 這個 managed node 安裝所需的 modules.
# 相當於底下指令
# yum install platform-python python36 python3-libselinux python3-dnf

```