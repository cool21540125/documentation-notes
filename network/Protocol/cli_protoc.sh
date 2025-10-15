#!/bin/bash
exit 0
# ------------------------------------------------------------------------------------------------------------------------







### ========================================== golang ==========================================


### 由 .proto 產生 protobuf
protoc --go_out=. xxx.proto


### Golang 如果要玩 protobuf, 一定要安裝 protoc-gen-go, 且這東西一定要在 PATH 底下
# https://grpc.io/docs/languages/go/quickstart/
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
export PATH="$(go env GOPATH)/bin:${PATH}"
# 會在 $GOPATH/bin 底下安裝好 protoc-gen-go (此為 binary)

GOBIN=$HOME/bin go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
# protoc-gen-go 是 protoc(這個 Compiler) 的 plugin


### ========================================== python ==========================================


### 由 .proto 產生 protobuf
protoc --python_out=$DST_DIR -I=$SRC_DIR $SRC_DIR/${PROTO_FILE}.proto
protoc --python_out=. xxx.proto
# -I 等同於 --proto_path
# SRC_DIR 為 .proto 放置的位置


### ========================================== nodejs ==========================================
### ========================================== java ==========================================


### 由 .proto 產生 protobuf
protoc --java_out=. xxx.proto


