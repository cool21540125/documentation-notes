#!/bin/bash
exit 0
# -------------------------------------------------------------

### 取得 pipeline 細節
aws codepipeline get-pipeline --name $PIPELINE --output json | jq
# 如果希望將此產出, 交給 update 來做修改套用的話, 需要移除:
# metadata 這一包




### 運行 pipeline (等同於 Console 上頭的 Release Change)
aws codepipeline start-pipeline-execution --name $PIPELINE
