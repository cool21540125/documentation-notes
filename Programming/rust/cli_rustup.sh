#!/bin/bash
exit 0
#
# 似乎是 rust 的版本控管?
#
# ------------------------------------------------------------------


### (若原本使用 rustup 安裝的話) 日後的 rust 升級 & 刪除
rustup update
rustup self uninstall


### (沒有網路的話) 查看 local 說明文件
rustup docs --book


### rust 升級
rustup update 