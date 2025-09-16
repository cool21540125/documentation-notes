#!/bin/bash
exit 0
# ----------------------------------------------------------------------------

gradle -v
# 8.2.1

### 安裝 gradle wrapper
gradle wrapper
# 必須要有 settings.gradle

### 驗證是否為合格的 gradle project (有這東西?)

### 清空 build/
gradle clean

###
gradle test
gradle test -p $SUBMODULE

### 
gradle build

### 更新 gradle 的依賴
gradle --refresh-dependencies

### 列出 app 這個 subproject 的 transitive dependency(傳遞依賴)
gradle :app:dependencies

### 使用 Build Scan 做依賴性及專案掃描 (可找出專案的深度分析)
gradle build --scan
# CLI 首次使用需要敲 yes 授權同意, 造訪網頁時, 還需要做 email 認證

### dru run
gradle build --dry-run
# 或
gradle build -m
