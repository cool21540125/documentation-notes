# GitLab CI/CD

- 2019/05/18
- [GitLab CI/CD](https://docs.gitlab.com/ee/ci/introduction/)
- [GitLab Runner](https://docs.gitlab.com/runner/) (還不是很熟)
- [Pipeline 排程](https://docs.gitlab.com/ee/user/project/pipelines/schedules.html)
- [.gitlab-ci.yml 基本教學](https://docs.gitlab.com/ee/user/project/pages/getting_started_part_four.html)


## 基本概念

- Continous Integration : 自動化測試
- Continous Delivery : 手動遞交程式碼
- Continous Deploy : 遞交的程式碼經自動化測試完成後, 自動部署
- variable 可用於:
  - 控制 pipeline
  - `.gitlab-ci.yaml`
  - project/group/instance CICD variable


### 使用方式簡述

在 Git proj 內放置一個 [.gitlab-ci.yml](https://docs.gitlab.com/ee/ci/yaml/README.html)

> 關於 `.gitlab-ci.yml` , 裏頭可以定義像是 : running scripts, includes && cache dependcies, commands in order, parallel commands, Deploy path, run scripts automatically or trigger by manual.....

> GitLab 會偵測 `.gitlab-ci.yml`, 並使用 `GitLab Runner` 這支工具, 來運行裡投定義好的 **腳本**. **腳本** 都被分組成 `jobs`, `jobs` 再組成 `pipeline`

```yaml
### .gitlab-ci.yml 範例1
before_script:      # 定義 dependencies
  - apt-get install rubygems ruby-dev -y

run-test:
  script:
    - ruby --version

# push 後, 觸發 2 支 jobs, 並 compose 出一個 pipeline
```

```yaml
### .gitlab-ci.yml 範例2
# 4 jobs
stages:     # 僅告知後續有 3 個階段
  - test
  - build
  - deploy

test:
  stage: test           # test
  script: echo "Running tests"

build:
  stage: build          # build
  script: echo "Building the app"

deploy_staging: # job name
  stage: deploy         # deploy
  script:               # run scripts
    - echo "Deploy to staging server"
  environment:          # path
    name: staging
    url: https://staging.example.com
  only:
  - master              # master branch
```


### CI/CD workflow

![GitLab workflow](../img/gitlab_workflow_20190518.png)
