

# argocd - lab

- 2023/09/02
- https://www.youtube.com/watch?v=zGndgdGa1Tc&ab_channel=AntonPutra

```bash
### 
helm repo add argo https://argoproj.github.io/argo-helm


### 
helm repo list
# 應該可以看到:
# NAME      URL            
# argo      https://argoproj.github.io/argo-helm


### 
helm search repo argocd


### 2023/09/02 目前的最新版本
helm show values argo/argo-cd --version 3.35.4 > argocd-defaults.yaml


### 
helm list -A
#NAME    NAMESPACE  REVISION  UPDATED           STATUS    CHART           APP VERSION
#argocd  argocd     1         2023-09-02 20:39  deployed  argo-cd-3.35.4  v2.2.5


### 
kubectl get pods -n argocd
#NAME                               READY  STATUS   RESTARTS  AGE
#argocd-application-controller-xxx  1/1    Running  0         3m20s
#argocd-dex-server-xxx              1/1    Running  0         3m20s
#argocd-redis-xxx                   1/1    Running  0         3m20s
#argocd-repo-server-xxx             1/1    Running  0         3m20s
#argocd-server-xxx                  1/1    Running  0         3m20s


### Get Secrets
kubectl get secrets -n argocd
kubectl get secrets argocd-initial-admin-secret -n argocd -o yaml
# 針對上面的 data.password 做 base64 decode
echo "{data.password}" | base64 -d
# 得到的那串, 用來登入 argocd admin


###
kubectl port-forward svc/argocd-server -n argocd 8080:80

```
