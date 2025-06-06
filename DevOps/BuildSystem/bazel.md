# Bazel

- Bazel can solve large monorepo build problems very well, but it has a steep adoption curve
- bazel 是個 build / test tool
- Bazel 主要目的是用來將 `source code` build 成 `executable`
- Bazel 基本上都需要整合了一系列的 tools/libs, 才能有效進行 build 及 deploy
  - 這些 tools 可能包含了: 各種程式語言的 pkg manager, runtime, sdk, …
- 基本上有 3 個動作:
  - `bazel build`, `bazel test`, `bazel run`
  - 對於 `bazel build` 及 `bazel test` 需要是 no side-effect (為了有效 cache)
- 對於 Bazel 的 Support:
  - `bazelbuild` : Google Support
  - `bazel-contrib` : Community Support
- bazel 的 build process(Phase Model)
  - Loading
    - Reading 及 executing BUILD file (非全部, 僅必要部分)
    - list files 可使用 `glob()`
  - Analysis
    - 每個 Rule 都可以用來生成 files 及 生成 rule 自身的 action
    - inputs / dependencies && apply build rules && 生成 action graph
    - rules 可以 create actions
    - (執行細節)Starlark 分析 dependencies 採用 button-up 的方式來進行
      - 先找出 無依賴 or 依賴於產出檔, 再向上建構出依賴樹
  - Execution
    - 由 build inputs 開始執行 build actions 直到 build outputs 產出
- 截至 2022, Starlark 可以寫 Loading 及 Analysis, 但無法用來寫 Execution (不知道這在講啥..)

- [build golang gazelle](https://earthly.dev/blog/build-golang-bazel-gazelle/)
- [graphviz](http://www.webgraphviz.com/)

## Workspace

- WORKSPACE.bazel 所在目錄, 即為 root of the main repository, 簡寫為 '@'
- WORKSPACE.bazel 裡頭的東西:
  - 構建環境
  - 為了做 build 所需的 外部依賴
- 定義在 WORKSPACE.bazel 的 external repositories 用途:
  - 給 WORKSPACE.bazel 裡頭的 workspace rules 引用
  - Bzlmod 系統中的 modules 及 extensions 產生

## Package

- 資料夾裡如果有 BUILD, 則此資料夾稱之為 Package
  - BUILD 又稱之為 build file
  - BUILD 裡頭, 可任意使用 native functions / native rules (他們都是 global symbols)
- Package 裡頭的 Elements(元素組成), 稱之為 Target
- Package 裡頭的 BUILD 這檔案, 定義了 2 個重要的事情:
  - How to build
  - What to build
    - 產出目標則是 Targets
- packaging rule:
  - http_archive
  - git_archive

## Target

- BUILD 裡頭定義了一堆 Targets
- BUILD file 裡頭無法:
  - 不能定義 functions
  - 不能使用 arguments
- Target 會是下列這些:
  - Files 實體存在的檔案, 又分為下列 2 種:
    - source files
    - generated files / derived files / output files
  - Rules
    - 定義 input 與 output 的關聯
      - input 可以是 source files 或 generated files
    - 定義 bazel 需要用的 build tools, 像是: compilers / linkers / configurations
      - 絕大多數情況下, 不需要自行實作 `build rules` (或稱之為 `Language rules`) (此外還有 `android rule` / `ios rule`)
  - 其他 (應該是很進階的議題了, 先忽略)
- Target 裡頭可以加上 `tags` 屬性 (通常是為了做測試)

## Label

- Target Name 稱之為 Label
- Label 的完整名稱(Fully-qualified package name) 長這樣: `@my_repo//my/app/main:app_binary`
- 如果是相同 Repository 裡頭自行相互引用, 則可寫成: `//my/app/main:app_binary`
- 如果是相同 Package 裡頭自行相互引用, 則可寫成: `:app_binary` 或 `app_binary`
- 需要注意的是, 關於 Target 的引用
  - 對於 files, 可以省略 ':', 可直接寫 `app_binary`
  - 對於 rules, 無法省略 ':', 只能寫成 `:app_binary`
- 如果 Package 與 Label 同名, 可進行縮寫, ex: `//my/app:app` 可寫成 `//my/app`
- 使用 sub-package 的引入時, 無法使用 relative labels, 必須聲明 fullpath, ex:
  - 應該使用 `//my/app/sub-package/data.txt`
  - 無法使用 `sub-package/data.txt`

## Visibility

- Bazel's 2 visibility systems:
  - target visibility
  - load visibility
-

## Extension

- Bazel 的 extension files 都必須是 `.bzl` 結尾
- 如果要使用 extension files, 則需要用 `load("//foo/bar:file.bzl", "some_library")`
- Extensions 提供了: constants / rules / macros / functions
- Bazel 使用 Extensions 的細節:
  - bazel 讀取 `.bzl` 的時候, 便會建立 `var`
  - 如果 `bar.bzl` 要使用 `foo.bzl` 的變數, 聲明方式: `load(":foo.bzl", "var1", "var2", "var3")`
  - 此時, 這些載入的 variables 為 immutable

# .bazelrc

- 順序(後者會覆蓋前者)
  1. `/etc/bazel.bazelrc`
  2. workspace 的 `.bazelrc` (如果 cmd option 沒有 `--noworkspace_rc` 的話)
  3. `$HOME/.bazelrc` (如果 cmd option 沒有 `--nohome_rc` 的話)
  4. cmd line 明確指定 `--bazelrc=file`
- 好像可以有不同名字(不確定)
  - `tools/bazel.rc`
  - `/.bazel.rc`

## Additional Bazel tools

- buildifier
  - formatting + linting
- Starlark Lauguage & Build API
  - 可用來建立 custom rules
- Build Event Stream
  - 用來 monitor build events 及 identify bottlenecks

# bazel 演進

- rules_python
- rules_go
- rules_nodejs -> rules_js
- rules_docker -> rules_oci
- 早期使用名為 `skylark` 來撰寫 rules, 但因為這名字已經有其他代表作了, 因而改成 `starlark`

# bazel 故事

- bazel 誕生以前, google 使用了大量的 monorepo, 並且使用 makefile 來做 build 方面的管控
- 當 code base 逐漸龐大以後, Makefile 變得非常難以維護
- 在 google
  - 後端 使用 Go/Java
  - 前端 使用 React/JS
  - 資料 使用 Python/Scala
  - infra 使用 Go/Rust/C/C++/Lua
- 即使使用了不同的 build system, 也很難讓開發人員具備 "具有凝聚力" 的開發者體驗 (大家都用各自的方法)
