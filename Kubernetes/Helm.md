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
- Helm Charts
  - 一大包東西, 包含了:
    - Chart.yaml: Chart 的 meta 資訊 (name, version, dependencies, ...)
    - values.yaml: Chart 的預設值 (template files 的 values)
    - templates/: Chart 的 template files (裡頭的變數會來自 values.yaml)
    - charts/: Chart 的 dependencies (ex: 依賴其他 Charts, ...)
- Helm Release :
  - Helm Release 是 Chart 的實例化, 是 Chart 在 Kubernetes 上的部署
  - Helm Release 每次更新後, 就會產生一個 版本(Revision)
    - 版本號 是由 Chart 的版本號和 Release 的版本號組

```yaml
mychart/       # 資料夾名稱(Helm Chart 名稱)
  Chart.yaml   # chart 的 meta info (name, version, dependencies, ..., 說穿了就是 package.json 啦)
    # - apiVersion: 是 Helm Chart 的版本, 不是 k8s 的 apiVersion (apiVersion: v2 表示為 helm3, 表示 helm2 不認識這東西...) 
    # - type: [application|library], application 表示這個 Chart 是一個應用程式, library 表示這個 Chart 是一個函式庫 
    # - keywords: 是 Helm Chart 的關鍵字, 用來搜尋 Chart (也就是方便人家在 artifacthub.io 上搜尋啦) 
  values.yaml  # template files 的 values (通常為 default values)
  charts/      # Chart dependencies (ex: 依賴其他 Charts, ...)
  templates/   # template files (裡頭的變數會來自 values.yaml)
```
