
# Bazel

load http_archive rule in WORKSPACE

Bazel calls your top-level source file a workspace, which contains other source files in a nested fashion. Your workspace is what builds your entire software by taking a set of inputs and generating the desired output.

---

bazel 為 build / test tool

基本上有 3 個動作: build / test / run

build / test 必須對於 outside world 沒有 side effect (為了能有效率的 cache)

因此像是 integration tests 的話, 則必須使用 run step 或是 在 bazel 以外完成

由更高層次的分類來說, bazel 屬於 artifact-based build system

---

基本配置:

專案根目錄配置 WORKSPACE, 作為 bazel 尋找東西的 root

在 workspace 裡頭, bazel 會尋找 BUILD

BUILD file 由 `Starlank / Skylark` Language 撰寫 (此語言很像 python3)

---

Workspace / packages / targets

Workspace 裡頭的所有 subdir 只要裡頭有 BUILD (以及裡頭的 source files), 就是個 package

WORKSPACE 裡面可以是空的

WORKSPACE 裡面可能定義了 build 出 outputs 所需的 external dependencies 的 references

WORKSPACE 所在的目錄, 便是 root of the main repository, 也稱之為 '@'

定義在 WORKSPACE 的 external repositories 要馬是 

WORKSPACE 裡頭藉由 workspace rules 引用的

或者

Bzlmod 系統中的 modules 及 extensions 產生

---

BUILD 定義了 how to build

BUILD 定義了 what to build (targets)

* build target 需要餵入 input artifacts, 而這些 inputs 包含了: source files / dependencies / options

* build rule 會定義 bazel 需要用的 build tools, 像是: compilers / linkers / configurations

---

bazel 的 build process

1. **Loads** BUILD
2. **Analyzes** inputs / dependencies && apply build rules && 生成 action graph
3. **Executes** 由 build inputs 開始執行 build actions 直到 build outputs 產出

---

bazel 讀取 `foo.bzl` 的時候, 便會建立 `var`

如果 `bar.bzl` 要使用 `foo.bzl` 的變數, 聲明方式: `load(":foo.bzl", "var1", "var2", "var3")`

此時, 這些載入的 variables 為 immutable

---

`BUILD` 與 `.bzl` 的差異

`BUILD` 藉由 call rules 來 register targets

`.bzl` 則提供了 constants / rules / macros / functions

`BUILD` 裡頭可任意使用 native functions / native rules (他們都是 global symbols)

`.bzl` 需要使用 native module 來載入他們

`BUILD` 裡頭無法:

- 定義 functions
- 使用 arguments

---

```
src/app/BUILD
src/app/core/input.txt
src/app/tests/BUILD

# (放了 BUILD 的資料夾, 就會被視為是個 package) (同 python 的 __init__.py)
# 包含了 2 個 packages
#   app
#   app/tests

# package 裡頭的 elements 稱之為 target, 可區分為
#   files
#   rules
```
