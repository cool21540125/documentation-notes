
- [Using xcodebuild to Build from the Command Line](https://www.waldo.com/blog/use-xcodebuild-command-line)


# Build Terms

- Target 是 xcode 流程裡頭的 最小可編譯單元
    - 每個 target 都會對應一個 編譯輸出, 可能是個 link, executable, package
    - Target 定義了 編譯輸出 的 **Build Settings** 及 **Build Phases** 的所有細節
- Scheme 預設的 workflows (對於 Target 的 action): Build / Run / Test / Profile / Analyze / Archive
    - 定義了每個 Target 的操作該如何被執行 (how the operations are performed on each target)
    - Scheme Name 與 Target Name 通常長一樣, 但其實兩者不同, 常被混淆
        - 每個 Target 都必須要有至少一個 Scheme
            - Scheme 裡頭需要提供 App 要 run 的 destination
                - destination 可以是 Physical Device / Simulator
        - Scheme 裡頭最重要的配置為 target 的 **build configuration**
            - 預設有 `Debug` 及 `Release`
- Certificate, identifier, and profile
    - coding 完後, 需要做 archive. archive 檔的用途:
        - 用來給 QA Team 測試用
        - 用來 publish 到 App Store
    - **Signing Certificate**
        - App 要交付到 `App Store` 的話, 需要有 `signing certificate`, 用途:
            - 用來識別 developers
            - 用來識別 the content hasn't been updated after signing
    - **Identifiers**
        - developer 提供, 用來識別 App 的 ID
    - **Provisioning Profile**
        - ('signing certificate' + 'identifier' + 'the device on which the app will run') 的組合
        - 例如 App 需要跑在 iPhone 及 iPad 的話, 則需要有 2 組 profision profiles


# xcodebuild CLI

```zsh
### 列出 xcode app workspace 底下的 schemes
xcodebuild -list -workspace $YOUR_XCODE_PROJECT_PATH.xcworkspace
# 可能需要先進到裡頭去做 pod install (產出 pod project) 再來 list
# 


### 指定 Scheme 並執行 action(此範例為 build)
xcodebuild -workspace $YOUR_XCODE_PROJECT_PATH.xcworkspace -scheme $scheme build


### 
```
