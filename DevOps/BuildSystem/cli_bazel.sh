#!/bin/bash
exit 0
# -----------------------------------------------------------------------------------------------

###
bazel build //...

### 列出 Target 的 依賴結構
bazel query --notool_deps --noimplicit_deps --output graph "deps(//...) > graph.in"
# 可以看到 Target 依賴了哪些東西
# --noimplicit_deps 'Target'

### 將 graph.in 的依賴圖, 會出成 png
dot -Tpng <graph.in >graph.png

### 列出 Target 的 反向依賴
bazel query "rdeps(//..., //Target)"
# 可以看到哪些東西依賴了 Target

### 列出 rule 的 output path
bazel cquery --output=files //:rule
