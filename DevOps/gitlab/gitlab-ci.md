

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

## Environment Variables

- `$CI_BUILD_REF` : 
- `$CI_PROJECT_DIR` : Runner 將目前執行 CI Job 的 Code 存放位置. ex: */home/gitlab-runner/builds/project_name*
- `$CI_PROJECT_NAME` : 