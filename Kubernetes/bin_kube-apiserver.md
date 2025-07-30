# kube-apiserver 啟動命令

```bash
kube-apiserver \
  --authorization-mode=${ALLOW_MODE}


```


### ALLOW_MODE

- 可用選項
  - AlwaysAllow (default)
  - NODE
  - ABAC
  - RBAC
  - Webhook - 可以使用 3rd 的權限管理工具. ex: Open Policy Agent (OPA)
  - AlwaysDeny
- 複選方式範例:
  - `--authorization-mode=AlwaysAllow,RBAC`
  - `--authorization-mode=AlwaysAllow,ABAC,RBAC`