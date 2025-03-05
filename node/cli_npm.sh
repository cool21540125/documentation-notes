#!/bin/bash
exit 0
# - What is the difference between "npm install" and "npm ci"?
#     https://stackoverflow.com/questions/52499617/what-is-the-difference-between-npm-install-and-npm-ci
#     https://stackoverflow.com/questions/19578796/what-is-the-save-option-for-npm-install
#
# ----------------------------------------------------------------------------------------------------------------

### ======================================== npm 安裝套件 ========================================

### 第 1 招 -- 適合在為上線新專案使用?
npm update
# 1. 更新 package.json && package-lock.json
# 2. 依照 package-lock.json 安裝套件

### 第 2 招 -- 適合用來在 Development 環境使用?
npm install
# 1. 更新 package-lock.json
# 2. 依照 package-lock.json 安裝套件

### 第 3 招 -- 適合用來做 CI/CD, testing 等等
npm ci
# 1. 依照 package-lock.json 安裝套件

### ======================================== npm 安裝套件 - 其他細節 ========================================

### npm v5.0.0 以後
npm install xxx
# 等同於 npm install -S xxx
# 等同於 npm install -P xxx
# 等同於 npm install --save xxx
# 等同於 npm install --save-prod xxx
# npm v5.0.0 以前長怎樣, 不重要了

### 安裝 development 套件, 放入 package.json 裡頭的 devDependencies (不需要在 Production 環境使用的東西)
npm install --save-dev xxx
# 等同於 npm install -D xxx
# ex: 發時使用的套件 / UI 輔助工具 / 測試套件 / 等等與 Production 無關的套件

### (用途不清楚) 會把套件更新到 package.json 的 optionalDependencies
npm install --save-optional xxx
# 等同於 npm install -O xxx

### 或許適合測試套件 -- 安裝套件, 然而並不會把此套件加入到 package.json
npm install --no-save xxx

### 僅會嘗試從 cache 做安裝依賴套件 (或 cache 找不到會噴錯)
npm install --offline xxx

### ======================================== npm cache ========================================

### 查看 npm cache 放在什麼地方
npm config get cache
# 預設為 $HOME/.npm

### 指定 npm cache dir -- 適用於不同專案之間的 cache 共享
npm config set cache /path/to/my/custom/cache

### 清除快取
npm cache clean         # 不使用 --force 的話, 則會做互動式詢問
npm cache clean --force # 不要問, 直接砍

### (用途不確定)
npm cache verify

### ======================================== misc ========================================

### 免 log 運行
npm run --silent xx.js
# 等同於
npm_config_loglevel=silent npm run xx.js
