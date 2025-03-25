#!/usr/bin/env bash
exit 0
# ------------------------------

### 檢查是否有 race condition 存在
go run -race xx.go

### 列出 golang 支援的所有平台標籤
go tool dist list

### ========================================== go env ==========================================

### 列出 go Env
go env

### go module 出來以前, 修改 GOPATH 的用法
go env -w GOPATH=$(pwd)
# go env -w GOPATH=/Users/$(whoami)/go

### ========================================== go install / go get / go download ==========================================

### go install gomplate -- golang 模板解析工具
# https://docs.gomplate.ca/installing/
go install github.com/hairyhenderson/gomplate/v4/cmd/gomplate@latest
gomplate --help

### go install swagger
GOBIN=~/bin go install github.com/swaggo/swag/cmd/swag
# 會優先將  放到 $GOBIN 底下, 如果沒有設定 GOBIN, 則會放到 $GOPATH/bin 底下 (也就是 $HOME/go/bin 底下)
# 使用時, 記得再做:
export PATH="$HOME/go/bin:$PATH"
# 才可正常使用 cmd

### 下載 src 放到 $GOPATH/src 底下
go get                           # 更新現有依賴, 但排除所依賴的其他模組
go get -u xxx                    # 更新現有依賴, 會強制更新它所依賴的其他全部模組, 但不包含本身
go get -u -t xxx                 # 更新所有直接 & 間接依賴 (包含 unittest 用到的)
go get -u -v xxx                 # -v, verbose
go get github.com/xxx/xxx@v1.0.0 # 指定版本

### 依照 go.mod && go.sum 下載相關依賴
go mod download

### ========================================== go mod ==========================================

### 初始化套件 (建立 go.mod)
go mod init PackageName

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

### ========================================== go test ==========================================

### 由於每次 go test 都會將結果快取(用於 Code 及 data 為變動時加速運行), 此方式可以強迫不使用快取
go test -count=1

### 測試當前目錄下的 *_test.go
go test

### 測試當前目錄下的所有 subdirs 底下的 *_test.go
go test ./...

### 覆蓋率 coverage
go test -cover

### 生成測試報告 && 查看測試的覆蓋範圍
go test -v -cover -coverprofile=c.out
go tool cover -html=c.out

### Benchmark 測試 (我不懂)
go test -bench=. -bench

# ========================================== go build ==========================================

### go build Terraform
go build -ldflags "-w -s -X 'github.com/hashicorp/terraform/version.dev=no'" -o ~/bin/
