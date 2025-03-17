#!/bin/bash
exit 0
# ----------------------------------------------------------------------------

# 配置 JAVA_HOME 用這個吧
export JAVA_HOME="$(dirname $(dirname $(realpath $(which javac))))"

### ========================================= 編譯 =========================================

### 指定要去哪裡找 src (也就是 xx.java 啦)
javac -sourcepath SRC.java
# -source-path 等同於 -sourcepath

### 指定 class file 的產出路徑
javac -d $PATH_TO_CLASS_OUTPUT_DIR

### ========================================= 輔助查詢功能 =========================================
