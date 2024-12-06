#!/bin/bash
exit 0
# -------------------------------------------------------------

### ============================================= 基礎使用 ============================================

### 列出 CodeBuild Projects
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-projects.html
aws codebuild list-projects --sort-by NAME --sort-order ASCENDING --output json | jq

### 列出 CodeBuild Project 的 Build Histories (只能看到一堆 ids, 感覺意義不大)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-builds-for-project.html
PROJECT_NAME=
aws codebuild list-builds-for-project --project-name $PROJECT_NAME # 列出單一 CodeBuild Project 的 all Build Histories
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/list-builds.html
aws codebuild list-builds # 列出全部 CodeBuild Project 的 all Build Histories

###
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codebuild/batch-get-projects.html
aws codebuild batch-get-projects --names $PROJECT_NAME --output json | jq
