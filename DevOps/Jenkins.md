

# Configure




# Useful Plugins

- [Git Parameter](https://plugins.jenkins.io/git-parameter/)
    - JenkinsJob build 做 git pull 的時候可選擇 branch/tag
- [Markdown Formatter](https://plugins.jenkins.io/markdown-formatter/)
    - 可在 Jenkins 裡頭的許多地方寫 Markdown
    - Manage Jenkins -> Configure Global Security > Markup Formatter > Markdown Formatter > Save
- [Parameterized Trigger](https://plugins.jenkins.io/parameterized-trigger/)
    - JenkinsJob build 結束後, 觸發下游專案可帶參數
- [build user vars](https://plugins.jenkins.io/build-user-vars-plugin/)
    - 可在 JenkinsJob 使用 user 相關的環境變數, ex: BUILD_USER
    - JenkinsJob 裡面要勾選 *Set jenkins user build variables*
- [Build Timeout](https://plugins.jenkins.io/build-timeout/)
    - 可在 JenkinsJob build 的時候, 設定 timeout, 避免某些 Job 真的跑壞了, 然後一直 hang 在那邊...
- [AnsiColor](https://plugins.jenkins.io/ansicolor/)
    - Jenkins execute shell 的時候, 可以使用不同的 Console output 來做不同顏色的輸出
- [Locale](https://plugins.jenkins.io/locale/)
    - 不知為啥... 工作環境上, iMac Server 上頭的 Jenkins, 大家訪問後都變成亂碼
    - Jenkins > Manage Jenkins > Configuration System > Locale > Default Language > en-us
- [Multiselect parameter](https://plugins.jenkins.io/multiselect-parameter/)
    - (還沒使用過)
    - JenkinsJob 可使用 (多階層)條件化下拉式選單
- [Active Choices](https://plugins.jenkins.io/uno-choice/)
    - JenkinsJob 可使用 很豐富的參數選單
- [Custom Checkbox Parameter](https://plugins.jenkins.io/custom-checkbox-parameter/)
    - JenkinsJob 可依賴外部 file/URL 來動態變更 構建參數
        - ex: 可以隨時變更 yaml file 來動態增減 JenkinsJob 帶入的參數
    - 似乎有漏洞, 目前(2022Q4) 尚未修補
