

# Configure





# Useful Plugins

- [Git Parameter](https://plugins.jenkins.io/git-parameter/)
    - JenkinsJob build 做 git pull 的時候可選擇 branch/tag
- [Markdown Formatter](https://plugins.jenkins.io/markdown-formatter/)
    - 可在 Jenkins 裡頭的許多地方寫 Markdown
    - Manage Jenkins -> Configure Global Security > Markup Formatter > Markdown Formatter > Save
- [Parameterized Trigger](https://plugins.jenkins.io/parameterized-trigger/)
    - JenkinsJob build 結束後, 觸發下游專案可帶參數
- [Custom Checkbox Parameter](https://plugins.jenkins.io/custom-checkbox-parameter/)
    - 可在 JenkinsJob 執行時, 帶入的參數可以藉由勾選某些選項. 而這些選項, 來自於解析某個 yaml file
    - a.k.a. 可以隨時變更 yaml file 來動態增減 JenkinsJob 帶入的參數
- [build user vars](https://plugins.jenkins.io/build-user-vars-plugin/)
    - 可在 JenkinsJob 使用 user 相關的環境變數, ex: BUILD_USER
    - JenkinsJob 裡面要勾選 *Set jenkins user build variables*