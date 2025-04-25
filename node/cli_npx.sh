#!/bin/bash
exit 0
#
# npx 用來把套件安裝完後, 就把它扔了
# npm v5.2.0 以後就已內建 `npx`
#
# ---------------------------------------------------------------------------------

### 初始化 nuxt App 的方式
npm i -g create-nuxt-app
create-nuxt-app demo-app
# 等同於
npx create-nuxt-app demo-app
# 好處之一是, 避免 global 被污染 (使用完 create-nuxt-app 就立馬給我丟掉)

### 可直接在 local 執行 Github Repository 和 gist
npx https://gist.github.com/itsems/ed6cebf796a470059c7eb25fdfcaa085
# 會去掃上面的 package.json 做安裝 & 執行

###
