#!/bin/bash
exit 0
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/index.html
# ----------------------------------------------------------------------------------------------------------------

### 列出 DB Clusters | 查看 DeletionProtection 狀況
aws rds describe-db-clusters --output yaml | yq ".DBClusters[].DeletionProtection"
aws rds describe-db-instances --output yaml | yq ".DBInstances[].DeletionProtection"

### 查看 RDS DB instance
aws rds describe-db-instances --db-instance-identifier $INSTANCE_IDENTIFIER
aws rds describe-db-instances --output yaml | yq ".DBInstances[].DBInstanceIdentifier"
aws rds describe-db-instances --output yaml | yq ".DBInstances[].DBInstanceClass"
aws rds describe-db-instances --output yaml | yq ".DBInstances[].DeletionProtection"
aws rds describe-db-instances --output yaml | yq ".DBInstances[].PubliclyAccessible"
aws rds describe-db-instances --output yaml | yq ".DBInstances[].BackupRetentionPeriod"
aws rds describe-db-instances --output yaml | yq ".DBInstances[].MultiAZ"

### 目前各個 DB instance 做 Backup & Maintenance Window
aws rds describe-db-instances --output yaml | yq ".DBInstances[].PreferredBackupWindow"
aws rds describe-db-instances --output yaml | yq ".DBInstances[].PreferredMaintenanceWindow"

### Security
aws rds describe-db-instances --query "DBInstances[].{db: DBInstanceIdentifier, encrypt: StorageEncrypted, enhanceMonitor: MonitoringInterval}" --output json

### Monitoring
aws rds describe-db-instances --query "DBInstances[].{db: DBInstanceIdentifier, class: DBInstanceClass, insight: PerformanceInsightsEnabled}" --output json

### Spec
aws rds describe-db-instances --query "DBInstances[].{db: DBInstanceIdentifier, StorageNow: AllocatedStorage, StorageMax: MaxAllocatedStorage}" --output json
aws rds describe-db-instances --query "DBInstances[].{db: DBInstanceIdentifier, Storage: StorageType}" --output json

### RDS 配了多大的儲存空間
aws rds describe-db-instances --output yaml | yq ".DBInstances[].MaxAllocatedStorage"

aws rds describe-db-instances --query 'DBInstances[].{Db: DBInstanceIdentifier, username: MasterUsername}'
aws rds describe-db-instances --query "DBInstances[].{Db: DBInstanceIdentifier, logs: EnabledCloudwatchLogsExports}" --output json

### 列出 RDS snapshots
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/describe-db-snapshots.html
aws rds describe-db-snapshots --query "DBSnapshots[].{size: AllocatedStorage, name: DBSnapshotIdentifier, Engine: Engine}" --snapshot-type manual --output yaml | yq
aws rds describe-db-snapshots --query "DBSnapshots[].{size: AllocatedStorage, name: DBSnapshotIdentifier}" --output yaml | yq

### ============================================= RDS IAM authentication =============================================
RDS_IAM_TOKEN=$(aws rds generate-db-auth-token --hostname $RDS_ENDPOINT --port $PORT --region $REGION --username $USERNAME)
#(可以拿到很長一串 Token)

# 前往Certificate bundles by AWS Region 下載該地區的 certificate bundles
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.CertificatesAllRegions
# 假設檔名為 us-west-2-bundle.pem

mysql -h$RDS_ENDPOINT -P$PORT --ssl-ca=$HOME/us-west-2-bundle.pem --user=$USER -p$RDS_IAM_TOKEN

### =============================================  =============================================
