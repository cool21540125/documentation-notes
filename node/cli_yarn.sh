#!/bin/bash
exit 0
#
# [What is the closest to `npm ci` in yarn](https://stackoverflow.com/questions/58482655/what-is-the-closest-to-npm-ci-in-yarn)
#
# ---------------------------------------------------------------------------------

### -------------------------------- CICD 可能遇到的問題 --------------------------------
#
# yarn 有 v1 (Classic) 與 v2+ (Berry, 指 v2, v3, v4...), CI 行為不同:
#
# ### yarn v1 (1.x.x) -- 例如目前常見的 1.22.22
# 問題重現:
#   在 CI 系統裡面, 如果純粹使用
#      $ yarn install
#
#   CI 系統「不會」自動套用任何額外旗標, 行為與本地端完全相同
#   也就是說, yarn install 可能會悄悄更新 yarn.lock, 導致 CI 環境使用了非預期的版本
#
# 建議在 CI 明確使用:
#      $ yarn --frozen-lockfile
#      指令說明:
#        依照 yarn.lock 安裝套件, 若 yarn.lock 需要更新則直接報錯退出
#        v1 不會自動偵測 CI 環境, 需手動加上此旗標, 這樣才能確保環境安裝的就跟 yarn.lock 一模一樣
#
# ### yarn v2+ (Berry, 包含 v2 / v3 / v4)
# 問題重現:
#   在 CI 系統裡面, 如果純粹使用
#      $ yarn install
#
#   CI 系統會自動視為並執行 (偵測到 CI=true 或 TEAMCITY_VERSION 環境變數時)
#      $ yarn install --immutable
#      指令說明:
#        --immutable 為 v2+ 版本中 --frozen-lockfile 的改名版本, --frozen-lockfile 在 v2+ 仍作為 alias 存在. WARNING: 未來會移除
#        若 yarn.lock 需要更新則直接報錯退出
#        This setting is on by default in CI environments
#        若需要關閉此行為, 可設定環境變數: YARN_ENABLE_IMMUTABLE_INSTALLS=false
#
# 結論:
#  yarn v1,  於 CI 系統當中, 統一使用 `yarn --frozen-lockfile`   (不同於 `yarn install`)
#  yarn v2+, 於 CI 系統當中, 統一使用 `yarn install --immutable` (等同於 `yarn install`)
#
# -------------------------------- CICD 可能遇到的問題 --------------------------------

### ======================================== 安裝套件 ========================================

### 適合用來做 CI/CD (yarn v1 手動指定 / v2+ 本地端模擬 CI 行為)
yarn --frozen-lockfile
# 依照 yarn.lock 安裝套件, lockfile 若需要更新則報錯
# 等同於 npm ci
# 注意: v2+ 改名為 --immutable, --frozen-lockfile 在 v2+ 為 alias, 未來可能移除

yarn --pure-lockfile
# 不要產生 lockfile, 但若 lockfile 需要更新不會報錯 (不適合 CI/CD)

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
