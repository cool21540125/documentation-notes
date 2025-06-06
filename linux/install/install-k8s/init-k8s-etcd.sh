#!/bin/bash
exit 0
# -----------------------------------------------------------------------------------------------------------------------
# NOTE: etcd 3.4 版以後, 會去偵測 ETCD_NAME 這個環境變數, 如果又同時使用 --name xxx 的話, 會產生錯誤

export _ETCD_NAME=infra1
export INTERNAL_IP=10.200.0.11
export INTERNAL_IP0=10.200.0.10
export INTERNAL_IP1=10.200.0.11
export INTERNAL_IP2=10.200.0.12
export ETCD_INITIAL_CLUSTER="infra0=https://${INTERNAL_IP0}:2380,infra1=https://${INTERNAL_IP1}:2380,infra2=https://${INTERNAL_IP2}:2380"

### etcd Service
envsubst <etcd.service.tmpl >/usr/lib/systemd/system/etcd.service
systemctl daemon-reload
systemctl stop etcd
systemctl start etcd
systemctl status etcd

###
etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.crt --cert=/etc/etcd/etcd.crt \
  --key=/etc/etcd/etcd.key

###
