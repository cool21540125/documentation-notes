
# gazelle

- gazelle 為 Golang 的 BUILD file generator
    - 使用 gazelle 的話, `WORKSPACE.bazel` 所在根目錄也同時需要一份 `BUILD.bazel`
- 會偵測 `go.mod` 找出 external dependencies, 並生成 `xx.bzl`
    - 藉由使用 `gazelle update-repo`