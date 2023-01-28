
- 2023/01/26
- [Github-protobuf src](https://github.com/protocolbuffers/protobuf)


# 摘要

- protobuf 通訊協定緩衝區
    - 在 `.proto` 裡頭定義 message formats
- `Protocol Buffers, a.k.a., protobuf` 是個用來作 `serializing structured data` 的機制
- 如果要安裝 protobuf, 則需安裝:
    - protocol compiler (此為 `protoc(protocol buffer compiler)`, C++ 寫出來的)
        - 要馬從 C++ src code 做編譯... 不然就直接抓各種語言 compile 出來的 binary, [Github-protobuf](https://github.com/protocolbuffers/protobuf/releases)
            - pre-built binary packages: `protoc-${VERSION}-${PLATFORM}.zip`(ex: `protoc-21.12-osx-x86_64.zip`), 裡頭包含了:
                - bin/protoc
                - 一堆 使用 protobuf 分發出來的 .proto 檔案
        - 對於 golang, 除了電腦上安裝好了 `protoc` 以外, 還需要安裝以下 2 個 protocol compiler plugins for golang:
            ```bash
            # 2023/01
            # https://grpc.io/docs/languages/go/quickstart/
            go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
            go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

            ### 並設定好路徑~
            export PATH="$(go env GOPATH)/bin:${PATH}"
            ```
    - protobuf runtime
- type
    - int32, int64, sint63, sint64
    - uint32, uint64
    - fixed32, fixed64, sfixed32, sfixed64
    - float, double 

```bash
### install
$# go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
# 會在 $GOPATH/bin 底下安裝好 protoc-gen-go (此為 binary)

### 由 .proto 產生 protobuf
$# protoc -I=$SRC_DIR --python_out=$DST_DIR $SRC_DIR/${PROTO_FILE}.proto
```
