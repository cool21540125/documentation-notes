# Terms


- pipeline
    - 早期稱之為 workflow
    - 系統上, processes 所組成, 用來完成 compile, build, deploy
    - 流程上, 由多個 stage 組成, ex: `checkout out using scm`, `Build`, `Test`, `Deploy`
        - stage 可能由 1~N 個 step 組成
    - 基於 Apache Groovy 開發, Java 語法相容
    - 始於 2016/04
    - 可被靜態編譯, 也可被動態執行
- executor
    - 可區分為:
        - controller: Jenkins Master
        - Agent: Jenkins Worker
    - executor 可以是任何一個, 但建議都用 agent
    - executor 的任務, 是可以被 parallelized
- node
    - 通常是 agent
- step
    - single task. 像是執行單一指令
    - 假如 plugin 擴增了 `Pipeline DSL`, 意味著 plugin 已經實作了一個新的 step
- stage
    - 用來概念上定義 pipeline 上頭, 不同的子集的步驟. ex: build, test...