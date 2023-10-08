#!/usr/bin/env bash
exit 0
# ------------------------------

# `Go routine` 是個輕量版的 thread, Golang 用它來 enable `concurrency`


### go module 出來以前
go env -w GOPATH=$(pwd)
# go env -w GOPATH=/Users/$(whoami)/go

### 
go mod init PackageName


### 自動下載相依檔, 並更新到 go.mod
go mod tidy


### 有點類似 python 的 venv , 自動下載到 local 的 vendor/ (裡面會有相依檔)
go mod vendor


### Change go version in go.mod
go mod edit -go 1.21


### 