# Helm

- Package Manager for Kubernetes - Helm
- template Engine
  - Template 定義在 `values.yaml`; 使用 `{{ .values.xxx.yyy }}` 取值
- Helm Public Repository
  - Helm Hub
  - Helm Charts Pages
- Helm 將 k8s 的 App (Depoyments, Services, Secret, ConfigMap) 配置打包到 Charts 當中
- Release Management
  - Helm Client:
    - helm CLI
  - Helm Server: Tiller
    - Helm v2 版有這東西. 但由於 Helm Server 能夠去對 k8s 做 Create/Update/Delete, 權限太大有安全疑慮, v3 就沒有 Tiller 了~
    - Helm v3 只剩下 helm binary (無 Tiller)
- Helm Charts  : 
- Helm Release : 

```yaml
mychart/       # 資料夾名稱(Helm Chart 名稱)
  Chart.yaml   # chart 的 meta info (name, version, dependencies, ...)
  values.yaml  # template files 的 values (通常為 default values)
  charts/      # Chart dependencies (ex: 依賴其他 Charts, ...)
  templates/   # template files (裡頭的變數會來自 values.yaml)
```
