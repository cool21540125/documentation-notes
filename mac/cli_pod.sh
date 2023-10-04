#!/usr/bin/env bash
exit 0
# ---------------------

### version
pod --version
#1.12.1
# 2023Q3


### 等同於 npm install
pod install
# 會先做 install Pods, 並將這些 Pods 的版本號寫入 podfile.lock (鎖住版本)
# pod install 只會解析「不存在於 lock file」的 pod, 並安裝最新版本


### 僅用來更新 podfile.lock && 特定 pod
pod update [PODNAME]


### 
pod outdated


### 