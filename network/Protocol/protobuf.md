# Protocol Buffers

- .proto 定義檔內容
  - 如果某些欄位要棄用, 則將這些標記為 reserved (避免 Client 依然使用導致異常)
  - 欄位序號, 19000 ~ 19999 為預設保留段 (勿使用), 定義了以後不能夠再變更
  - Field Types [scalar type](https://protobuf.dev/programming-guides/proto3/#scalar)
- 如果要安裝 protobuf, 則需安裝:
  - protobuf runtime
  - protocol compiler (此為 `protoc(protocol buffer compiler)`, C++ 寫出來的)
    - 要馬從 C++ src code 做編譯... 不然就直接抓各種語言 compile 出來的 binary, [Github-protobuf](https://github.com/protocolbuffers/protobuf/releases)
      - pre-built binary packages: `protoc-${VERSION}-${PLATFORM}.zip`(ex: `protoc-21.12-osx-x86_64.zip`), 裡頭包含了:
        - bin/protoc
        - 一堆 使用 protobuf 分發出來的 .proto 檔案

```bash
### This is for gRPC for Golang
# https://grpc.io/docs/languages/go/quickstart/
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
export PATH="$(go env GOPATH)/bin:${PATH}"
# 會在 $GOPATH/bin 底下安裝好 protoc-gen-go (此為 binary)


### 由 .proto 產生 protobuf
protoc --python_out=$DST_DIR -I=$SRC_DIR $SRC_DIR/${PROTO_FILE}.proto
# -I 等同於 --proto_path
# SRC_DIR 為 .proto 放置的位置


### Golang 如果要玩 protobuf, 一定要安裝 protoc-gen-go, 且這東西一定要在 PATH 底下
GOBIN=$HOME/bin go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
# protoc-gen-go 是 protoc(這個 Compiler) 的 plugin
```


# Proto compiler

### Protoc Compiler

```bash
### 各種語言的 Protoc Compiler
protoc --java_out=. xxx.proto
protoc --go_out=. xxx.proto
protoc --python_out=. xxx.proto
# 支援的語言可查看 protoc --help


### 
```