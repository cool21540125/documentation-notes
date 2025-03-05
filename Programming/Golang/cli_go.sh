#!/usr/bin/env bash
exit 0
# ------------------------------

### 檢查是否有 race condition 存在
go run -race xx.go

### 下載 src 放到 $GOPATH/src 底下
go get                           # 更新現有依賴, 但排除所依賴的其他模組
go get -u xxx                    # 更新現有依賴, 會強制更新它所依賴的其他全部模組, 但不包含本身
go get -u -t xxx                 # 更新所有直接 & 間接依賴 (包含 unittest 用到的)
go get -u -v xxx                 # -v, verbose
go get github.com/xxx/xxx@v1.0.0 # 指定版本

### 列出 golang 支援的所有平台標籤
go tool dist list

###
go install github.com/swaggo/swag/cmd/swag
# 會優先將  放到 $GOBIN 底下, 如果沒有設定 GOBIN, 則會放到 $GOPATH/bin 底下 (也就是 $HOME/go/bin 底下)
# 使用時, 記得再做:
export PATH="$HOME/go/bin:$PATH"
# 才可正常使用 cmd

# `Go routine` 是個輕量版的 thread, Golang 用它來 enable `concurrency`

### 列出 go Env
go env

### go module 出來以前, 修改 GOPATH 的用法
go env -w GOPATH=$(pwd)
# go env -w GOPATH=/Users/$(whoami)/go

###
go mod init PackageName

### 下載 go.mod 所指名的所有依賴
go mod download

### 列出現有的依賴結構
go mod graph

### 檢視模組是否被篡改過
go mod verify

### 顯示依賴的原因
go mod why

### 自動下載相依檔, 並更新到 go.mod (整理 Dependencies)
go mod tidy

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
