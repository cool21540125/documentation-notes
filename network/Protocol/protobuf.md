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


# protobuf 與 gRPC

Service 是 protobuf 更加通用的概念, 並非用來做序列化, 而是用來作為通訊使用. Service 是用來定義 API 的集合.

protobuf 在設計的時候, 並非被設計成可用來做網路傳輸, 因此若要網路傳輸 protobuf 的話, 主要會依賴於 gRPC framework (當然還有其他的 framework 可用來傳輸 protobuf).

```proto
message GetSomethingRequest {}
message GetSomethingResponse {}
message ListSomethingRequest {}
message ListSomethingResponse {}

service FooService {
  rpc GetSomething(GetSomethingRequest) returns (GetSomethingResponse);
  rpc ListSomething(ListSomethingRequest) returns (ListSomethingResponse);
}
```