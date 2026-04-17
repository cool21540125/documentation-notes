#!/bin/bash
exit 0
# --------------------------------------------------------


## ======================== 安裝 lms ========================
curl -fsSL https://lmstudio.ai/install.sh | bash
export PATH="$HOME/.lmstudio/bin:$PATH"

lms --version
#CLI commit: 0b2a176


## ======================== 取得 Model ========================
# 可以到這邊查看有哪些 Models 可以下載: https://huggingface.co/models?sort=trending
lms get google/gemma-4-e4b


## ======================== 啟動/關閉 LLM Api Server ========================
## Run server
lms server start --port 22345
#Success! Server is now running on port 22345

## Stop server
lms server stop
#Stopped the server on port 22345.

lms status                                                                                                                                                   16:23:55
#Server: ON (port: 22345)


## ======================== 查看/卸載/加載 LLM (會吃大量 Memory) ========================

## 查看 lms 已加載 Models
lms ps
#IDENTIFIER            MODEL                 STATUS    SIZE       CONTEXT    PARALLEL    DEVICE    TTL
#google/gemma-4-e4b    google/gemma-4-e4b    IDLE      6.33 GB    40960      4           Local 
# IMPORTANT: 留意 memory 用量, 以及 Model 允許的 Context

## 卸載/加載 LLM
lms unload google/gemma-4-e4b

lms load google/gemma-4-e4b --context-length 40960  # 加載 Model (會吃大量記憶體, 並且手動配置 Context length)


## ======================== Example: 配置一個 Claude Code compatible ========================
export ANTHROPIC_BASE_URL=http://localhost:22345
export ANTHROPIC_API_KEY=abcd1234

## 本地跑 Claude, 並且指向到 local model
claude --model google/gemma-4-e4b --system-prompt ""
# 我使用 M1 Pro 16GB.
# 打個 ping
# 結果 2m 42s 以後才給我回覆給了一堆廢話.......
