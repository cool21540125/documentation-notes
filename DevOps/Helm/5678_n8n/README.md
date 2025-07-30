# 🚀 n8n + PostgreSQL Helm 部署指南

本專案使用 Helm 部署 n8n 工作流程自動化平台與獨立的 PostgreSQL 資料庫。所有資源將部署在 `n8n` 命名空間下，並採用安全的密碼管理機制。

## 📋 部署概覽

- **PostgreSQL**: 使用 Bitnami Helm Chart 部署獨立資料庫
- **n8n**: 使用官方 Helm Chart 部署，連接到外部 PostgreSQL
- **安全性**: 使用 Kubernetes Secrets 管理所有敏感資訊

## 🔐 安全密碼管理

**重要**: 在開始部署前，必須先設置安全的密碼管理機制。

### 步驟 1: 生成安全密碼
```bash
# 使用提供的腳本生成強密碼
./setup-secrets.sh
```

此腳本會：
- 自動生成 24 字符的強密碼
- 創建 `postgresql-secret.yaml` 文件
- 顯示生成的密碼供您記錄

### 步驟 2: 保存密碼
**⚠️ 重要**: 請將生成的密碼保存到您的密碼管理器中！

### 步驟 3: 應用 Secret 到 Kubernetes
```bash
kubectl apply -f postgresql-secret.yaml
```

## 🚀 部署流程

### Phase 1: 環境準備

#### 1.1 建立 Namespace
```bash
kubectl create namespace n8n
```

#### 1.2 新增 Helm Repository
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

### Phase 2: 準備 n8n Chart

#### 2.1 獲取 n8n Chart 預設配置
```bash
# 下載預設 values 文件作為參考
helm show values oci://8gears.container-registry.com/library/n8n --version 1.0.0 > default-values.yaml

# 複製並修改配置文件
cp default-values.yaml values-n8n.yaml
vim values-n8n.yaml
```

#### 2.2 下載 n8n Chart 到本地
```bash
# 下載並解壓 n8n Chart 到本地
helm pull oci://8gears.container-registry.com/library/n8n --version 1.0.0 --untar --untardir .
```

這樣做的好處：
- 避免每次都要輸入長的 OCI 網址
- 可以離線使用
- 方便查看和修改 Chart 內容

### Phase 3: 部署 PostgreSQL

#### 3.1 部署 PostgreSQL
```bash
helm install n8n-db bitnami/postgresql -n n8n -f values-postgresql.yaml
```

#### 3.2 驗證 PostgreSQL 部署
```bash
kubectl get pods -n n8n
kubectl logs -f deployment/n8n-db-postgresql -n n8n
```

### Phase 4: 部署 n8n

#### 4.1 部署 n8n
```bash
helm install poc-n8n ./n8n --version 1.0.0 -n n8n -f values-n8n.yaml
```

#### 4.2 驗證 n8n 部署
```bash
kubectl get pods -n n8n
kubectl logs -f deployment/poc-n8n -n n8n
```

### Phase 5: 驗證整體部署

```bash
# 查看所有 Helm releases (應該看到 n8n-db 和 poc-n8n)
helm list -n n8n

# 查看所有資源
kubectl get all -n n8n

# 查看 secrets
kubectl get secrets -n n8n
```

## 📁 配置文件說明

### 核心配置文件
- `values-postgresql.yaml`: PostgreSQL 配置，使用 `existingSecret` 引用密碼
- `values-n8n.yaml`: n8n 配置，連接到外部 PostgreSQL
- `postgresql-secret.yaml`: 包含資料庫密碼的 Kubernetes Secret
- `./n8n/`: 本地下載的 n8n Helm Chart 目錄

### 安全相關文件
- `postgresql-secret.yaml.template`: 密碼模板文件（可安全提交）
- `setup-secrets.sh`: 密碼生成腳本
- `.gitignore`: 排除包含敏感資訊的文件

### Chart 相關文件
- `./n8n/`: 本地 n8n Helm Chart（通過 `helm pull` 下載）

## 🔧 重要配置說明

### PostgreSQL 配置重點
```yaml
# values-postgresql.yaml
auth:
  existingSecret: "postgresql-secret"  # 使用外部 secret
  secretKeys:
    adminPasswordKey: "postgres-password"
    userPasswordKey: "password"
  database: "n8n"
  username: "n8n_user"
```

### n8n 配置重點
```yaml
# values-n8n.yaml
postgresql:
  enabled: false  # 不使用內建 PostgreSQL

externalDatabase:
  host: "n8n-db-postgresql.n8n.svc.cluster.local"
  database: "n8n"
  user: "n8n_user"
  existingSecret: "postgresql-secret"
  existingSecretPasswordKey: "password"
```

## 🔄 更新與維護

### 更新 PostgreSQL
```bash
# 修改 values-postgresql.yaml 後執行
helm upgrade n8n-db bitnami/postgresql -n n8n -f values-postgresql.yaml
```

### 更新 n8n
```bash
# 修改 values-n8n.yaml 後執行
helm upgrade poc-n8n ./n8n --version 1.0.0 -n n8n -f values-n8n.yaml
```

### 重新生成密碼
```bash
# 刪除現有 secrets
kubectl delete secret postgresql-secret -n n8n

# 重新生成密碼
./setup-secrets.sh

# 重新應用
kubectl apply -f postgresql-secret.yaml

# 重啟相關 pods 以使用新密碼
kubectl rollout restart deployment/n8n-db-postgresql -n n8n
kubectl rollout restart deployment/poc-n8n -n n8n
```

## 🔗 本地訪問與測試

### 訪問 n8n Web 介面
```bash
# 方法 1: 使用 Pod 名稱進行 port-forward
kubectl --namespace n8n port-forward pod/poc-n8n-<pod-hash> 8080:5678

# 方法 2: 使用 Service 進行 port-forward (推薦)
kubectl port-forward svc/poc-n8n 8080:80 -n n8n
```

然後在瀏覽器中訪問：`http://localhost:8080`

### 直接訪問 PostgreSQL (除錯用)
```bash
# Port-forward PostgreSQL 服務
kubectl port-forward svc/n8n-db-postgresql 5432:5432 -n n8n
```

然後可以使用本地 PostgreSQL 客戶端連接：
- Host: `localhost`
- Port: `5432`
- Database: `n8n_production`
- Username: `n8n_user`
- Password: (從 secret 中獲取)

## 🛠️ 故障排除

### 查看日誌
```bash
# PostgreSQL 日誌
kubectl logs -f deployment/n8n-db-postgresql -n n8n

# n8n 日誌
kubectl logs -f deployment/poc-n8n -n n8n
```

### 檢查連接
```bash
# 檢查所有 services
kubectl get svc -n n8n

# 檢查 secrets
kubectl describe secret postgresql-secret -n n8n

# 檢查 pods 狀態
kubectl get pods -n n8n -o wide
```

### 獲取實際的 Pod 名稱
```bash
# 獲取 n8n pod 名稱
kubectl get pods -n n8n -l app.kubernetes.io/name=n8n

# 獲取 PostgreSQL pod 名稱
kubectl get pods -n n8n -l app.kubernetes.io/name=postgresql
```

### 常見問題
1. **連接失敗**: 檢查 PostgreSQL service 名稱和端口
2. **認證失敗**: 確認 secret 中的密碼正確
3. **Pod 無法啟動**: 檢查資源限制和 namespace
4. **Port-forward 失敗**: 確認 Pod 名稱正確，使用 `kubectl get pods -n n8n` 獲取實際名稱

## 📚 相關文檔

- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [n8n 官方文檔](https://docs.n8n.io/)
- [PostgreSQL Helm Chart](https://artifacthub.io/packages/helm/bitnami/postgresql)
- [n8n Helm Chart](https://artifacthub.io/packages/oci/8gears/n8n)

## ⚠️ 安全注意事項

1. **密碼管理**: 絕不將明文密碼提交到版本控制
2. **訪問控制**: 限制對 Kubernetes secrets 的訪問權限
3. **定期輪換**: 建議定期更換資料庫密碼
4. **備份**: 確保密碼已安全備份到密碼管理器
5. **監控**: 監控對 secrets 的訪問和使用