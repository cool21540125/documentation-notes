
# Install protoc

- protocol buffer compiler, `protoc`, 用來 compile `.proto` files
- 安裝方式分為 2 種:
    - Install using pkg manager
        - ex: brew install ...
    - Install pre-compiled binaries
        - 直接抓 binary && 設 PATH


# gRPC

- gRPC 可定義 4 種 methods:
    - `rpc UnaryGRPC(SimpleRequest) returns (SimpleResponse);`
        - 流程:
            1. client call a stub method, server 接收到 RPC 被 client 調用(伴隨著 method name, metadata, deadline, ...)
            2. server 可立即 send back initial metadata 或是 等待 client request message
            3. server 接收到 client request message, 開始著手處理 && return response(伴隨著 status code, optional status message, optional trailing metadata)
            4. if response status = OK, 則 client 成功接收 response. 最終於 client side 完成整個 RPC call.
    - `rpc StreamingReply(SimpleRequest) returns (stream StreamResponse);`
        - 流程:
            - 大多等同於 UnaryGRPC call
            - server return stream of messages(而非單一 Response)
            - 直到 Server 完成發送所有的 messages, 才發送 server's status code, optional status message, optional trailing metadata 給 client
            - client 於接收完所有 messages 時完成 RPC call.
            - 整個 RPC call 於 server side 完成.
    - `rpc StreamingRequest(stream StreamRequest) returns (SimpleResponse);`
        - 流程:
            - 大多等同於 UnaryGRPC call
            - client sends stream of messages(而非單一 Request)
            - server 基本上(但並非) 會在接收完所有 client 發送的 messages 時, responds with a single message(伴隨著 status details, optional trailing metadata)
    - `rpc BidirectionalTalk(stream StreamRequest) returns (StreamResponse);`
        - 流程:
            - Server 可等待 Client 發送完所有 messages 再給 response 或 read a message then write a message (等同於 ping-pong 方式溝通) 或 其他讀寫排列組合...
- RPC termination
    - gRPC 的 client 及 server 雙方都可自行定義何謂 success RPC call(因此, 結果可能會不相同(一方說成功, 一方說失敗))
    - gRPC client 可聲明: 在 RPC terminate 之前, RPC client 願意等候 RPC to complete 的時間(TTL 啦!), 並伴隨著 `DEADLINE_EXCEEDED` error.
    - 定義 deadline 或 timeout 會因為各種程式語言而異
        - 有些語言定義 timeouts (duration of time)
        - 有些語言定義 deadline(a fixed point in time)
    - RPC 雙方可在任何時候 cancel an RPC call.
        - 一旦發起了 cancel, 則 RPC 即刻 terminated(無後續作業).
        - IMPORTANT: 發起 cancel 以後, 前面所做的動作無法 rollback
- Channels
    - gRPC channel 提供了 connection to *gRPC Server* (給 client stub 使用)
    - Client 可聲明 channel arguments 來改變 gRPC 的 default behavior
        - ex: switching message compression on or off.
    - channel 具備 state 屬性: `connected` 及 `idle`
    - 如何結束 channel 因語言而異
        - ex: 某些語言可查詢 channel state
- 底下是 gRPC API 的定義:
    - On the server side, the server implements the methods declared by the service and runs a gRPC server to handle client calls. The gRPC infrastructure decodes incoming requests, executes service methods, and encodes service responses.
    - On the client side, the client has a local object known as stub (for some languages, the preferred term is client) that implements the same methods as the service. The client can then just call those methods on the local object, and the methods wrap the parameters for the call in the appropriate protocol buffer message type, send the requests to the server, and return the server’s protocol buffer responses.
- gRPC 也有區分成 async 及 sync:
    - synchronous  : 最接近 RPC call 的抽象概念, call RPC 時會 block, 並等待回應後, 再做後續處理
    - asynchronous : 網路傳輸本質上屬於 async, 因此也可在 current thread 實踐 async RPC


# Programming Languages

## python

```bash
### install
$# pip install grpcio
$# pip install grpcio-tools

### gen code && gRPC
$# python -m grpc_tools.protoc \
    -I ${PATH_TO_PROTOS}/protos \
    --python_out=. \
    --pyi_out=. \
    --grpc_python_out=. \
    ../../protos/helloworld.proto
# -I xxx            : (若無指定, 預設為當前目錄) 聲明要用來 import 的路徑
# --python_out      : python source file 產出路徑, 此為 proto buffer 使用
# --grpc_python_out : 「interface type(或 stub)」 及 「interface type 的 server 實作」, 此為 gRPC 使用
# --pyi_out         : Python pyi stub 產出路徑
```


## golang

```bash

### 
$# export PATH="$HOME/go/bin:$PATH"
# PATH 底下必須要找得到 protoc 及 protoc-gen-go 及 protoc-gen-go-grpc
# protoc             : 用來產生 protocol buffer files 的 binary 
# protoc-gen-go      : protoc 用來產生 protocol buffer files 的 go plugin binary
# protoc-gen-go-grpc : protoc 用來產生 gRPC implementation 的 go plugin binary


### gen code && gRPC
$# protoc \
    --go_out=. \
    --go_opt=paths=source_relative \
    --go-grpc_out=. \
    --go-grpc_opt=paths=source_relative \
    routeguide/route_guide.proto
# --go_out      : 產生 protocol buffer code, 此為 proto buffer 使用
# --go-grpc_out : 「interface type(或 stub)」 及 「interface type 的 server 實作」, 此為 gRPC 使用
# --go_opt      : 「--go_opt=paths=source_relative」 告知 --go_out 輸出路徑位置, 相對於 --go_out 的路徑
# --go-grpc_opt : 同 --go_opt
```
