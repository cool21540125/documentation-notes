

```bash
### ----------------- ansible-playbook command -----------------
### playbook 語法檢查
$# ansible-playbook $PLAYBOOK.yml --syntax-check -i $ANSIBLE_HOSTS_FILE

### DRY-RUN (不直接執行, 但列出測試執行的結果)
$# ansible-playbook -C $PLAYBOOK.yml -i $ANSIBLE_HOSTS_FILE

### 執行 Ansible playbook
$# ansible-playbook xxx -vvvv
# -vvvv : 顯示更多資訊

### 平行 10 個 thread 執行
$# ansible-playbook $PLAYBOOK.yml -f 10

### 列出影響的主機
$# ansible-playbook $PLAYBOOK.yml --list-hosts

### 
```


```bash

```