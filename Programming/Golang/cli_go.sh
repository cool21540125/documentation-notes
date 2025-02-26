#!/usr/bin/env bash
exit 0
# ------------------------------

### 檢查是否有 race condition 存在
go run -race xx.go

### 下載 src 放到 $GOPATH/src 底下
go get
go get -u xxx                    # -u, update
go get -u -v xxx                 # -v, verbose
go get github.com/xxx/xxx@v1.0.0 # 指定版本

### 列出 golang 支援的所有平台標籤
go tool dist list

###
go install
# 會優先將 binary 放到 $GOBIN 底下, 如果沒有設定 GOBIN, 則會放到 $GOPATH/bin 底下

# `Go routine` 是個輕量版的 thread, Golang 用它來 enable `concurrency`

### go module 出來以前, 修改 GOPATH 的用法
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

### golang 模板解析工具
# https://docs.gomplate.ca/installing/
go install github.com/hairyhenderson/gomplate/v4/cmd/gomplate@latest
gomplate --help

###

# ========================================== Other ==========================================
### go build Terraform
go build -ldflags "-w -s -X 'github.com/hashicorp/terraform/version.dev=no'" -o ~/bin/
