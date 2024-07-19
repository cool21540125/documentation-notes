#!/bin/bash
exit 0
# -------------------------

### 
vagrant -v
#Vagrant 2.3.7


### 依照 Vagrantfile 啟動 VM
vagrant up


### (需要在 Vagrantfile 同位置)
vagrant status
#Current machine states:
#
#master-1                  running (virtualbox)
#master-2                  running (virtualbox)
#loadbalancer              running (virtualbox)
#worker-1                  running (virtualbox)
#worker-2                  running (virtualbox)


### 逐一列出 vagrant servers 的 ssh_config 設定 (用途不是很大)
vagrant ssh-config


### 等同於 ssh
vagrant ssh $HOST


### 強制摧毀 VMs
vagrant destroy -f


### 
