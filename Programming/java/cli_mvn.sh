#!/bin/bash
exit 0
# ----------------------------------------------------------------------------

mvn -v
#3.9.3

### 安裝 maven wrapper
mvn wrapper:wrapper
# 必須要有 pom.xml
# 等同於在 local project 裏頭, 放了一包 gradlew
# 安裝完以後就有 ./mvnw 可以用了

### 驗證是否為合格的 maven project
mvn validate
# 其實是在檢查 pom.xml

### 清空 target/
mvn clean

### Test
mvn test         # only test compiled packages
mvn compile test # Compile + Test

### 對 src/main/java 底下的 packages 做編譯
mvn compile
# 將結果輸出到 target/

### 打包
mvn package
# Compile + Test + 打包成 jar

### 安裝 package 到 Repository
mvn install
# 基本上等同於 package + 安裝到 $MAVEN_HOME/repository
