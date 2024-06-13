#!/bin/bash
exit 0
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/index.html
# ----------------------------

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


### 目前各個 DB instance 做 Backup & Maintenance Window
aws rds describe-db-instances --output yaml | yq ".DBInstances[].PreferredBackupWindow"
aws rds describe-db-instances --output yaml | yq ".DBInstances[].PreferredMaintenanceWindow"

### Security
aws rds describe-db-instances --query "DBInstances[].{db: DBInstanceIdentifier, encrypt: StorageEncrypted, enhanceMonitor: MonitoringInterval}" --output json


### Monitoring
aws rds describe-db-instances --query "DBInstances[].{db: DBInstanceIdentifier, class: DBInstanceClass, insight: PerformanceInsightsEnabled}" --output json


aws rds describe-db-instances --query "DBInstances[].{db: DBInstanceIdentifier, StorageNow: AllocatedStorage, StorageMax: MaxAllocatedStorage}" --output json


### RDS 配了多大的儲存空間
aws rds describe-db-instances --output yaml | yq ".DBInstances[].MaxAllocatedStorage"


aws rds describe-db-instances --query 'DBInstances[].{Db: DBInstanceIdentifier, username: MasterUsername}'
aws rds describe-db-instances --query "DBInstances[].{Db: DBInstanceIdentifier, logs: EnabledCloudwatchLogsExports}" --output json