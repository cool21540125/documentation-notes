
# Pipeline 分類

## Declarative Pipeline

- 此為 `Scripted Pipeline` 的下一代產物, 更加簡單...

```groovy
pipeline {
    agent {  // 必須定義在 pipeline 底下第一個 section
        label ''  // 這個 pipeline 可運行在所有的 agent
    }
    stages {
        // logical group of tasks, 裏頭幾乎都會涵蓋 steps section. 可依序、平行、或用 parallel matrix 的方式進行
        // 底下一定要有 >=1 個 stage
        stage('Build') {  // 應該用較具有描述性的名稱. UI 會用此名稱來呈現 & logging
            steps {  // 包含一系列的 commands
                sh 'mvn install'  // 每個 command 執行特定 action, 並且逐一執行
            }
        }
    }
}
```


## Scripted Pipeline

- Scripted Pipeline is a Domain Specific Language (DSL) based on Apache Groovy.
- 很難學, 所以別鳥它


## Freestyle projects

- Freestyle projects are used to implement, develop, or run simple jobs. They can span multiple operations like building and running scripts.
- CloudBees 建議使用 `Declarative Pipeline`, 參考 [Converting a Freestyle project to a Declarative Pipeline](https://docs.cloudbees.com/docs/admin-resources/latest/pipelines/declarative-pipeline-migration-assistant)


## Multibranch pipelines

- 依照 branches 及 pull request 來自動化建立多條 pipeline.
    - 因為用不到, 所以不想鳥它


# 補充

[Pipeline: Nodes and Processes](https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step/), 定義了許多種類的 step:
    - bat : (不想鳥它)
    - powershell : (不想鳥它)
    - node : 安排一個 allocator on a node(通常在 agent 上)
    - sh
        - script(必要) : 系統預設使用 `DefaultShell -xe` (可能是 bash, 可能是 sh)
        - returnStatus & returnStdout
            - 看不懂... https://www.jenkins.io/doc/pipeline/steps/workflow-durable-task-step/
    - ws
        - node step 安排的 workspace