#!/bin/bash
exit 0
# -----------------------------------

### 2025/03/13 目前的版本
pnpm --version
#10.6.2

### ============================================== pnpm 安裝套件 ==============================================

### 等同於 npm install
pnpm install
# 會生成

### 依照 pnpm-lock.yaml 安裝依賴套件
pnpm install --frozen-lockfile
# 適用於 CI 環境

pnpm install --frozen-lockfile --ignore-scripts

# 等同於 npm ci
