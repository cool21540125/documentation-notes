### Use ConfigMap Example

```yaml
### ConfigMap Example
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  APP_COLOR: blue
  APP_MODE: prd
```

```yaml
### Use ConfigMap
# ...
spec:
  containers:
    - env:
        - name: ENV_NAME_FOR_POD_USAGE
          valueFrom:
            configMapKeyRef:
              name: nginx-config
              key: special.how
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: env-config
              key: log_level
```

```yaml
### 各種 ConfigMaps 使用方式
---
spec:
  containers:
    - image: xxx
      envFrom:
        - configMapRef:
            name: app-config
      # ...
---
spec:
  containers:
    - image: xxx
      env:
        - name: APP_COLOR
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_COLOR
      # ...
---
spec:
  containers:
    - image: xxx
      volumes:
        - name: app-config-volume
          configMap:
            name: app-config
```

# Metrics API

需要安裝好 Metrics Server: `kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`

```bash
###
NODE_NAME=
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes/${NODE_NAME} | jq


###
NAMESPACE=
POD_NAME=
kubectl get --raw /apis/metrics.k8s.io/v1beta1/namespaces/${NAMESPACE}/pods/${POD_NAME} | jq


###
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes/${POD_NAME} | jq
#{
#  "kind": "NodeMetrics",
#  "apiVersion": "metrics.k8s.io/v1beta1",
#  "metadata": {
#    "name": "gke-john-m-research-default-pool-15c38181-m4xw",
#    "selfLink": "/apis/metrics.k8s.io/v1beta1/nodes/gke-john-m-research-default-pool-15c38181-m4xw",
#    "creationTimestamp": "2019-12-10T18:34:01Z"
#  },
#  "timestamp": "2019-12-10T18:33:41Z",
#  "window": "30s",
#  "usage": {
#    "cpu": "62789706n",
#    "memory": "641Mi"
#  }
#}
```

### Use Secret Example

```bash
### 產出 base64 以後的 Secret
echo -n 'localhost' | base64  # bG9jYWxob3N0
echo -n 'root' | base64       # cm9vdA==
echo -n 'password1' | base64  # cGFzc3dvcmQx

echo -n 'bG9jYWxob3N0' | base64 --decode  # localhost
echo -n 'cm9vdA==' | base64 --decode      # root
echo -n 'cGFzc3dvcmQx' | base64 --decode  # password1
```

```yaml
### Secret Example
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_HOST: bG9jYWxob3N0
  DB_USER: cm9vdA==
  DB_PASSWORD: cGFzc3dvcmQx
  # 會被 Encoded
```

```yaml
### 各種 Secrets 使用方式
---
spec:
  containers:
    - image: xxx
      envFrom:
        - secretRef:
            name: app-config
  # ...
---
spec:
  containers:
    - image: xxx
      env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secret
              key: DB_PASSWORD
  # ...
---
spec:
  containers:
    - image: xxx
      volumes:
        - name: app-secret-volume
          secret:
            secretName: app-secret
      # ...
```

## ConfigMap 及 Secret

- IMPORTANT: Secrets 並非 Encrypted, 僅 encoded
  - k8s 的 Secret 真的是誤導!! 一點都不 Secret
  - 不要將 Secrets 推到 Git Repo
