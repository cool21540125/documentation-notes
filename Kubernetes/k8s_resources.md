# k8s Resources 的各種寫法


## k8s 團隊操作相關權限操作 - Role / RBAC

```yaml
### deve.loper-role.yaml
#$ kubectl get roles
#$ kubectl describe role developer
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "create", "update", "delete","watch"]
  resourceNames: ["pod-1", "pod-2"]
- apiGroups: [""]
  resources: ["ConfigMap"]
  verbs: ["get", "list", "create"]
```

```yaml
### devuser-developer-binding.yaml
#$ kubectl get rolebinding
#$ kubectl describe rolebinding devuser-developer-binding
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: devuser-developer-binding
  namespace: default
subjects:
- kind: User
  name: devuser
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```

```yaml
### cluster-admin-role.yaml
#$ kubectl get clusterroles
#$ kubectl describe clusterrole cluster-admin
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-admin
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list", "watch", "create", "delete"]
```

```yaml
### devuser-cluster-admin-binding.yaml
#$ kubectl get clusterrolebinding
#$ kubectl describe clusterrolebinding devuser-cluster-admin-binding
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: devuser-cluster-admin-binding
subjects:
- kind: User
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
```

## 