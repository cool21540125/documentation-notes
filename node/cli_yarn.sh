#!/bin/bash
exit 0
#
# [What is the closest to `npm ci` in yarn](https://stackoverflow.com/questions/58482655/what-is-the-closest-to-npm-ci-in-yarn)
#
# ---------------------------------------------------------------------------------

### ======================================== 安裝套件 ========================================

yarn --frozen-lockfile
# 不要產生 lockfile
# 如果需要 update, 則自動 fail
# ---> 優點: 版本可鎖住
# ---> 缺點: CI/CD pipeline 使用此方式, 可能會有失敗的風險

yarn --pure-lockfile
# 不要產生 lockfile
# ---> 優點: 版本可鎖住
# ---> 缺點: CI/CD pipeline 使用此方式, 可能會有失敗的風險

yarn --no-lockfile

### 適合在未上線新專案使用? (林北就是啥都要用最新的就是了)
yarn upgrade
# 等同於 npm update
# 等同於 pnpm update

### 安裝依賴套件 - 適合用來在 Development 環境使用? (我要的東西不要給我改版本, 至於間接依賴的東西的版本你自己看著辦)
yarn install
# 等同於 yarn
# 等同於 npm install
# 等同於 pnpm install
