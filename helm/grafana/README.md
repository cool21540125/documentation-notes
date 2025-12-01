- https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/

```bash
## 取得 grafana chart 部署後的 admin 密碼
kubectl get secret --namespace monitoring my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
