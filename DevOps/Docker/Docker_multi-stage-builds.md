# [Use multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)

## Before multi-stage builds

還沒有 multi-stage build 以前, 人們會透過 3 個檔案來整合他們:

- Dockerfile.build
- Dockerfile
- build.sh

透過 `./build.sh` 來 Compile && output executable && Build Prod-Image

這種方式, 被稱之為 docker 的 builder pattern

但自從支援了 multi-stage build 以後, 只需要維護一份 Dockerfile 即可


## Use multi-stage builds

```dockerfile
### unnamed multi-sage build
FROM golang:1.7.3
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
### building stage 從 0 開始起算
COPY --from=0 /go/src/github.com/alexellis/href-counter/app .
CMD ["./app"]  
```


## Name your build stages

```dockerfile
### named building stage
FROM golang:1.7.3 AS builder
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go    .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
### 使用的時候, 就算有多個 stage, 也不怕順序改動而壞掉
COPY --from=builder /go/src/github.com/alexellis/href-counter/app .
CMD ["./app"]  
```


## Stop at a specific build stage

build 的時候, 未必需要 build entire Dockerfile, 可指定 「僅執行特定 stage」 (透過 `--target STAGE_NAME`) 來完成

```bash
### 只執行名為 builder 的 stage
docker build \
    --target builder \
    -t xxx .
```

UNKNOWN: `--target xxx` 究竟是「只執行特定階段」還是「執行到特定階段」還沒辦法100%確定, 但直覺是前者


## Use an external image as a "stage"

`COPY --from=xxx` 也可指定此份 Dockerfile 以外的範圍, 甚至是其他 Registry 的 Image


## Use a previous stage as a new stage

不好說明, 範例簡單明瞭~

```dockerfile
FROM alpine:latest as builder
RUN apk --no-cache add build-base

FROM builder as build1
COPY source1.cpp source.cpp
RUN g++ -o /binary source.cpp

FROM builder as build2
COPY source2.cpp source.cpp
RUN g++ -o /binary source.cpp
```