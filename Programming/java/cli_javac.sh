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

### -------------------------------------- Compile time 的疑難雜症 --------------------------------------
javac FixedCapacityStack.java
#Note: FixedCapacityStack.java uses unchecked or unsafe operations.
#Note: Recompile with -Xlint:unchecked for details.
# 由於使用了 Generics, 但沒有指定具體的類型, 所以會有 unchecked warning

## 加入提示...
javac -Xlint:unchecked FixedCapacityStack.java
#FixedCapacityStack.java:26: warning: [unchecked] unchecked cast
#found : java.lang.Object[]
#required: Item[]
#        a = (Item[]) new Object[capacity];
#                     ^
#1 warning

### =========================================
