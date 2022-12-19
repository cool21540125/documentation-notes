

```yml
### .gitlab-ci.yml
stages:
    - build
    - deploy
    - test
    - stage_name

anonymous-name:
    stage: stage_name
    tags:
        - "build"
    script:
        - echo "Start building on stage_name stage"
        - echo 'building...'
        - sleep 2
        - echo 'DONE'
    artifacts:
        paths:
            - ./             # script 的產出物放置的位置
        expire_in: 1 week    # Build 出來的東西, 一週後移除

```


## [Predefined variables reference](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)

- CI_COMMIT_TAG
    - Commit tag name
    - Available only in pipelines for tags
- CI_ENVIRONMENT_NAME
    - if 設定了 `environment: name`, 此即為 name of the environment for this job
- CI_ENVIRONMENT_URL
    - if 設定了 `environment: url`, 此即為 URL of the environment for this job
- CI_JOB_NAME
    - job name
- CI_REGISTRY_IMAGE
    - if 專案的 Container Registry = enabled, 此即為 該專案的 Container Registry
- CI_PROJECT_DIR
    - Runner 將目前執行 CI Job 的 Code 存放位置. ex: */home/gitlab-runner/builds/project_name*
    - 如果 Gitlab Runner 設定了 `builds_dir`, 則此變數即為 該變數的 相對值
- CI_PROJECT_NAME
    - Project URL 為 gitlab.example.com/group-name/AAAA, 此變數即為 AAAA
