#!/bin/bash
exit 0
# ---------------------------------------------------------------------------------

### 1. 先去找最新版的 OTel JavaAgent - https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases

wget https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v2.18.1/opentelemetry-javaagent.jar

### 2. Run App with OTel JavaAgent
java -javaagent:./opentelemetry-javaagent.jar -jar target/YOUR_APP-0.0.1-SNAPSHOT.jar



# ======================================== by using OTel java agent ========================================
# 設定 OTel JavaAgent 專屬的環境變數
### 如果打算使用 auto(而非去改 Code 加上 annotation), 可用此種方式聲明後再來啟動 (便可用非侵入式的配置來實踐 OTel)
## Example 說明:
#     io.novatec.todobackend.TodobackendApplication 來自於 src/main/java 底下的路徑及檔名
#     [someInternalMethod] 則是該 TodobackendApplication.java 內的 method

## 使用不侵入 Code 的方式, 直接聲明哪個檔案的哪個 method 要被 OTel 監控
export OTEL_INSTRUMENTATION_METHODS_INCLUDE=io.novatec.todobackend.TodobackendApplication[someInternalMethod]

## 直接抑制 特定方法先排除在 OTel 監控之外 (縱使已有 OTel annotation)
export OTEL_INSTRUMENTATION_OPENTELEMETRY_INSTRUMENTATION_ANNOTATIONS_EXCLUDE_METHODS=io.novatec.todobackend.TodobackendApplication[someInternalMethod]
