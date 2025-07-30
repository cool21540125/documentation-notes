#!/bin/bash
exit 0
# ----------------------------------------------------------------------------

### 指定搜尋 zip/jar 的路徑
java -classpath PATH_TO_CLASS_SEARCH_DIR
# -classpath 等同於 -cp


### ==================================== java agent ====================================

### (使用 OTEL 來示範 java agent 的範例) 沒使用時, API Service 的運行方式:
# java -jar api-service.jar

### 使用時, API Service 的運行方式:
# java -javaagent:PATH/TO/opentelemetry-javaagent.jar \
  -Dotel.service.name=my-api \
  -Dotel.exporter.otlp.endpoint=http://localhost:4317 \
  -jar api-service.jar
# opentelemetry-javaagent.jar 本身是個實現了 Java Agent 的 jar. 用來代理我們的 App, 實現與 OTEL Collector 的通訊.
#    為何說它是個 Java Agent? 因為它實作了 JVM 提供的 premain(). 此為 Java instrumentation 的標準 entrypoint.
# 可藉由 JVM 參數指定的 exporter 設定. ex: `-Dotel.exporter.otlp.endpoint=http://localhost:4317`


### ====================================  ====================================
