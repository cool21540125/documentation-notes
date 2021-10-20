

```bash
### ----------------- ansible-playbook command -----------------
### playbook 語法檢查
$# ansible-playbook $PLAYBOOK.yml --syntax-check -i $ANSIBLE_HOSTS_FILE

### DRY-RUN (不直接執行, 但列出測試執行的結果)
$# ansible-playbook -C $PLAYBOOK.yml -i $ANSIBLE_HOSTS_FILE

### 執行 Ansible playbook
$# ansible-playbook xxx -vvv
# -vvv : 顯示更多資訊
```