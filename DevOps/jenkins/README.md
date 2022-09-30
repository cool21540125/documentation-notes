- [Learning Jenkins](https://docs.cloudbees.com/docs/admin-resources/latest/)
- [Getting started with Pipeline](https://www.jenkins.io/doc/book/pipeline/getting-started/)
- [Complete Jenkins Pipeline Tutorial | Jenkinsfile explained](https://www.youtube.com/watch?v=7KCS70sCoK0&ab_channel=TechWorldwithNana)


# Pipeline project types

- Declarative Pipeline
- Scripted Pipeline
- Freestyle projects
- Multibranch pipelines


# Web Page

- 內建的 "Snippet Generator"
    - `${YOUR_JENKINS_URL}/directive-generator`
    - `${YOUR_JENKINS_URL}/pipeline-syntax/` (此頁面會隨著相關套件更新而變更)
- Pipeline 可取得的內建全域變數 `${YOUR_JENKINS_URL}/pipeline-syntax/globals#env`
- Credential Scopes
    - System scope
        - available only for Jenkins server
        - 只能用做 Jenkins 系統配置 OR Jenkins admin 做一些 commmunication 方面操作的使用 
        - JenkinsJob 裡頭無法讀取這個喔!!
    - Global scope
        - Jenkins Web Console > Credentials
        - 可給所有 JenkinsJobs 使用 
    - Project scope
        - Jenkins Web Console > 特定 JenkinsJob > Credentials
            - 僅限於 JenkinsJob type 為 *multibranch pipeline* 才會出現
        - Jenkins Web Console > 特定 JenkinsJob > Credentials > Folder
            - 此 folder plugin, 用來組織管理 build jobs
            - 可用來做 JenkinsJob 層級的 Credential
