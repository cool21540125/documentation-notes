
# gazelle

- gazelle 為 Golang 的 BUILD file generator
- 會偵測 `go.mod` 找出 external dependencies, 並生成 `xx.bzl`
    - 藉由使用 `gazelle update-repo`