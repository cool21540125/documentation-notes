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
#   在 CI 系統裡面, 如果純粹使用
#      $ pnpm install
#
#   CI 系統會自動視為並執行 (偵測到 CI=true 環境變數時)
#      $ pnpm install --frozen-lockfile
#      指令說明:
#        Don't generate a lockfile and fail if an update is needed.
#        This setting is on by default in CI environments, so use --no-frozen-lockfile if you need to disable it for some reason
#
# 問題說明:
#    我們先忽略掉 lock 不 lock 的部分
#      $ pnpm install
#    旨在告知 pnpm, 安裝的時候, 請依照 package.json 的指定版本, 然後去「更新」 pnpm-lock.yaml 的套件版本
#    最後再依照 pnpm-lock.yaml 上頭所說的版本來做安裝依賴
#    然而因為加上了 `--frozen-lockfile`, 導致了「不能去更新 pnpm-lock.yaml 」因而引發錯誤
#
# 結論:
#    於 CI 系統當中, `pnpm install` 等同於 `pnpm install --frozen-lockfile`
#    若需要關閉此行為, 可加上旗標: --no-frozen-lockfile
#
# -------------------------------- CICD 可能遇到的問題 --------------------------------

### 適合在未上線新專案使用? (林北就是啥都要用最新的就是了)
pnpm update
# 等同於 npm update
# 等同於 yarn upgrade

### 安裝依賴套件 - 適合用來在 Development 環境使用? (我要的東西不要給我改版本, 至於間接依賴的東西的版本你自己看著辦)
pnpm install
# (非常可能會異動到 pnpm-lock.yaml)

### 只更新 pnpm-lock.yaml, 不安裝套件到 node_modules
pnpm i --lockfile-only
# 執行後只會異動 pnpm-lock.yaml, node_modules/ 完全不動
# 適合情境: 修改了 package.json 之後, 想先單獨更新並 commit lockfile 供 reviewer 審查, 再另行執行安裝
