#!/bin/bash
exit 0
#
# 社群弄出來的較高階的 ctr CLI wrapper
# 直接與 containerd 互動. 指令本身基本上等同於 docker
#
# 不過比起 docker CLI, 多了一層 Namespace 的概念, default NS 為 'default'
#
# -----------------------------------------------------------------
