#!/bin/bash
exit 0
# WARNING: 使用時會燃燒自己的 API token
# --------------------------------------------------------

### 環境變數認證
export OPENAI_API_KEY="abcdefg"


### 進入 Codex CLI
codex # 預設使用 o4‑mini
codex -m o3 # 改用 o3 model


### 