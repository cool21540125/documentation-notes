#!/bin/bash
exit 0
# -------------------------------------------------------------

### ============================================= 基礎使用 ============================================

PIPELINE_NAME=

### 查看 CodePipeline 細節
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/get-pipeline.html
aws codepipeline get-pipeline --name $PIPELINE_NAME --output json | jq
# 如果希望將此產出, 交給 update 來做修改套用的話, 需要移除: metadata 這一包

### 建立 CodePipeline
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/create-pipeline.html#examples
aws codepipeline create-pipeline --cli-input-json file://MySecondPipeline.json

### 運行 CodePipeline (等同於 Console 上頭的 Release Change)
# https://awscli.amazonaws.com/v2/documentation/api/latest/reference/codepipeline/start-pipeline-execution.html
aws codepipeline start-pipeline-execution --name $PIPELINE_NAME
