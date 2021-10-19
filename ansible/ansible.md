
Ansible

- 2019/01/12
- 這東西可以快速部署一群遠端主機(透過 ssh, 使用 PKI 認證)


## Terms

- Ansible Tower  : 針對企業用戶的收費軟體.
- Playbook       : Ansible 指令搞的名稱 (YAML) ; 可被 Ansible 執行的 YAML file.
- Host Inventory : 主機目錄, 主機清單, 此為設定檔
- YAML           : YAML Ain't a Markup Language

```yml
### playbook example
---
- hosts: web
  remote_user: root
  tasks:
  - name: install httpd
    yum: pkg=httpd state=latest
```




`主機目錄` 依照用途可分為: `DB Nodes`, `Service Nodes`, ...

### 主機目錄

> /etc/ansible/hosts

```sh
### 簡單寫法 ----------
192.168.124.101
www.tony.com
mail.tony.com

### 分組寫法 ----------
[webservers]
app.tony.com
www.tony.com

[dbservers]
mysql.tony.com
ms.tony.com
mongo.tony.com

[test]
node2

[prod]
node3
node4

[webservers:children]
prod
# 上頭的寫法表示, node3, node4 隸屬於 prod 群組, 而 prod 群組屬於 webservers 群組

### 建議寫法 ----------
# 與其寫這樣
w14301.example.com
w17802.example.com

# 不如寫像下面這樣
web1 ansible_host=w14301.example.com
web2 ansible_host=w17802.example.com
# ansible_host 也可用 ip
# web1, web2 為到時候使用的簡稱
```


## Ansible 指令

### 1. Ansible CLI

Ansible 的指令工具, 又稱為 `Ad-Hoc Commands`

```sh
### 指令格式
ansible <host-pattern> [options]

ansible -m <模組名稱>
ansible -a <模組的參數>
```


### 2. Ansible Playbook

#### 關鍵字

- hosts       : 遠端主機 IP
- remote_user : 執行身分
- vars        : 變數
- tasks       : Playbook 核心 ; `循序執行的 Action`, 每個 Action 呼叫一個 `Ansible Module(Ansible 的指令啦)`
    - action 語法: `module:module_params=module_value`
    - 常用 module : cd, ls, yum, copy, template, ...
- handlers    : Playbook 的 事件處理方式(多次觸發只執行一次, ex: 重開機後...)

#### Playbook 格式

```sh
### 執行方式
ansible-playbook deploy.yml

### Playbook 內:
模組名稱: 模組的參數
```

#### Example:

```yaml
### deploy.yaml
# 安裝 Apache && 改設定檔 && 寫 index.html && 啟動 Apache
---
- hosts: web

  vars:
    http_port: 80
    max_clients: 800

  remote_user: root

  tasks:
  # taks1
  - name: install apache in the newest version
    yum: pkg=httpd state=latest

  # task2
  - name: config file
    template: src=templates/httpd.conf.j2 dest=/etc/httpd/conf/httpd.conf
    notify:
    - restart apache
    # notify 這裡是 [] 的概念, 看下面 json 就可懂了

  # task3
  - name: index file
    template: src=templates/index.html.j2 dest=/var/www/html/index.html

  # task4
  - name: start apache
    service: name=httpd state=started

handlers:
  - name: restart apache
    service: name=httpd state=restarted
```

```js
// deploy.yaml -> deploy.json
// 上面那包, 也可改成 json
[
    {
        "hosts": "web",
        "vars": {
            "http_port": 80,
            "max_clients": 800
        },
        "remote_user": "root",
        "tasks": [
            {
                "name": "install apache in the newest version",
                "yum": "pkg=httpd state=latest"
            }, {
                "name": "config file",
                "template": "src=templates/httpd.conf.j2 dest=/etc/httpd/conf/httpd.conf",
                "notify": [             // 這邊也可了解上面為啥 yaml 要分兩行...
                    "restart apache"
                ]
            }, {
                "name": "index file",
                "template": "src=templates/index.html.j2 dest=/var/www/html/index.html"
            }, {
                "name": "start apache",
                "service": "name=httpd state=started"
            }
        ],
        "handlers": [
            {
                "name": "restart apache",
                "service": "name=httpd state=restarted"
            }
        ]
    },
]
```

## 常用模組(Ansible 基本功)

### 1. ping
### 2. debug
### 3. copy
### 4. template
### 5. file
### 6. user
### 7. yum
### 8. service
### 9. firewalld
### 10. shell
### 11. command




## Example

- 2019/01/12
- 安裝 httpd 的 yml 寫法

由 Ansible Tower 使用此腳本, 在遠端 (95) 安裝 httpd

```yml
- hosts: 192.168.124.95
  remote_user: root
  tasks:
  - name: install httpd
    yum: pkg=httpd state=latest

  - name: start
    service: name=httpd state=started
```

