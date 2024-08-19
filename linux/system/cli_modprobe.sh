#!/bin/bash
exit 0
#
# Linux 會藉由 modprobe 載入 kernel modules, 這些 modules 位於 /lib/modules/$(uname -r)/*.ki*  (是嗎@@?)
#
#
# SYNOPSIS
# -q : quiet
# -V : version
# -v : verbose
#   https://unix.stackexchange.com/questions/184877/how-to-list-all-loadable-kernel-modules  - 2015/02 (可能過時了)
# ----------------------------------------------------------------------

### 啟用 系統模組
modprobe $MODULE_NAME
modprobe br_netfilter
modprobe overlay
modprobe br_netfilter
modprobe bonding
