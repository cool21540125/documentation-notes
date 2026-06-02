#!/bin/bash
exit 0
#
# tsc 是 TypeScript 的 CLI 工具, 用來編譯 TypeScript 程式碼
#
# -------------------------------------------------------------

tsc --version
#Version 6.0.3


## 編譯 TypeScript 程式碼, 會根據 tsconfig.json 的設定來編譯 (並產生 js)
tsc

## 編譯 TypeScript 程式碼, 會根據 tsconfig.json 的設定做型別檢查 (但不產生 js)
tsc --noEmit