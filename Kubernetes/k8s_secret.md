# Kubernetes Ssecret


## 從 Private Registry 拉取 Image 的 Secrets 設定方式

1. 建立 Secret
```bash
### 建立 dockerhub login secret
kubectl create secret docker-registry $REG_KEY_NAME \
  --docker-server=$REG_SERVER \
  --docker-username=$REG_USER_NAME \
  --docker-password=$REG_USER_PASSWORD \
  --docker-email=$REG_USER_EMAIL
```

2. 在 Pod 的 spec 裡頭指定 Secret
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mycontainer
    image: myimage
  imagePullSecrets:        # 加入這個
  - name: $REG_KEY_NAME    # 加入這個
# (後略)
```
