# Helm

```yaml
mychart/       # 資料夾名稱(Helm Chart 名稱)
  Chart.yaml   # chart 的 meta info (name, version, dependencies, ...)
  values.yaml  # template files 的 values (通常為 default values)
  charts/      # Chart dependencies (ex: 依賴其他 Charts, ...)
  templates/   # template files (裡頭的變數會來自 values.yaml)
```
