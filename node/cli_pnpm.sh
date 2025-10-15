#!/bin/bash
exit 0
# -----------------------------------

### 2025/03/13 目前的版本
pnpm --version
#10.6.2

### ======================================== 安裝套件 ========================================

### -------------------------------- CICD 可能遇到的問題 --------------------------------
# 錯誤訊息:
#    Cannot install with "frozen-lockfile" because pnpm-lock.yaml is not up to date with
#
# 問題重現:
#   在 ci 系統裡面, 如果純粹使用
#      $ pnpm install
#
#   ci 系統會自動視為並執行 (可使用下面指令, 可在本地端重現)
#      $ pnpm install --frozen-lockfile
#      指令說明:
#        Don't generate a lockfile and fail if an update is needed.
#        This setting is on by default in CI environments, so use --no-frozen-lockfile if you need to disable it for some reason
#
# 問題說明
#    我們先忽略掉 lock 不 lock 的部分
#      $ pnpm install
#    旨在告知 pnpm, 安裝的時候, 請依照 package.json 的指定版本, 然後去「更新」 pnpm-lock.yaml 的套件版本
#    最後再依照 pnpm-lock.yaml 上頭所說的版本來做安裝依賴
#    然而因為加上了 `--frozen-lockfile`, 導致了「不能去更新 pnpm-lock.yaml 」因而引發錯誤
#

pnpm install --frozen-lockfile  # 不要更新 pnpm-lock.yaml
# 等同於
pnpm install --no-frozen-lockfile
#

### (目前想不到用途)
pnpm i --lockfile-only
# --lockfile-only : 預設為 false, 若有此參數, 表示只更新 pnpm-lock.yaml & package.json, 不去異動到 node_modules/


### -------------------------------- CICD 可能遇到的問題 --------------------------------

### 適合在未上線新專案使用? (林北就是啥都要用最新的就是了)
pnpm update
# 等同於 npm update
# 等同於 yarn upgrade

### 安裝依賴套件 - 適合用來在 Development 環境使用? (我要的東西不要給我改版本, 至於間接依賴的東西的版本你自己看著辦)
pnpm install
# (非常可能會異動到 pnpm-lock.yaml)

# ### 依照 pnpm-lock.yaml 安裝依賴套件
# pnpm install --frozen-lockfile
# # 適用於 CI 環境

# pnpm install --frozen-lockfile --ignore-scripts

# 等同於 npm ci
