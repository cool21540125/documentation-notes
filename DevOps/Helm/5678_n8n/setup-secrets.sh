#!/bin/bash

# 設置 secrets 的腳本
# 這個腳本會幫助您安全地設置 PostgreSQL secrets

echo "🔐 PostgreSQL Secrets 設置工具"
echo "================================"

# 檢查是否存在 postgresql-secret.yaml
if [ -f "postgresql-secret.yaml" ]; then
    echo "⚠️  警告: postgresql-secret.yaml 已存在"
    echo "   如果您要重新設置密碼，請先備份現有的密碼"
    read -p "是否要繼續? (y/N): " confirm
    if [[ $confirm != [yY] ]]; then
        echo "操作已取消"
        exit 0
    fi
fi

# 生成隨機密碼的函數
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-24
}

echo ""
echo "正在生成強密碼..."

# 生成密碼
POSTGRES_ADMIN_PASSWORD=$(generate_password)
N8N_DB_PASSWORD=$(generate_password)

echo "✅ 密碼已生成"
echo ""
echo "🔑 生成的密碼 (請妥善保存):"
echo "PostgreSQL Admin 密碼: $POSTGRES_ADMIN_PASSWORD"
echo "N8N 資料庫密碼: $N8N_DB_PASSWORD"
echo ""

# 創建 secret 文件
cp postgresql-secret.yaml.template postgresql-secret.yaml

# 替換密碼
sed -i "s/YOUR_POSTGRES_ADMIN_PASSWORD_HERE/$POSTGRES_ADMIN_PASSWORD/g" postgresql-secret.yaml
sed -i "s/YOUR_N8N_DB_PASSWORD_HERE/$N8N_DB_PASSWORD/g" postgresql-secret.yaml

echo "✅ postgresql-secret.yaml 已創建"
echo ""
echo "⚠️  重要提醒:"
echo "1. 請將上述密碼保存到您的密碼管理器中"
echo "2. postgresql-secret.yaml 已被 .gitignore 排除，不會被提交到版本控制"
echo "3. 請確保只在安全的環境中運行此腳本"
echo ""
echo "🚀 下一步:"
echo "   kubectl apply -f postgresql-secret.yaml"