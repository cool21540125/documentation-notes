#!/bin/bash
exit 0
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/rds/index.html
# ----------------------------


### MultiAZ
aws elasticache describe-replication-groups --query "ReplicationGroups[].{name: ReplicationGroupId, multiAZ: MultiAZ}" --output json
aws elasticache describe-cache-clusters --query "CacheClusters[].{name: CacheClusterId, multiAZ: MultiAZ}" --output json

