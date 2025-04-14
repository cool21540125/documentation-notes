#!/bin/bash
exit 0
# 似乎是個比 pip 更快的 package manager
# uv 和 poetry 相比的話, 差異在: uv 是一個 CLI 工具, 而 poetry 是一個完整的 Python package 管理器
# ------------------------------------------------------------------------

### 使用 uv 起始一個專案
uv init $PROJECT_NAME
uv init $PROJECT_NAME --no-git # 不使用 git

### 快速建立虛擬環境
uv venv

# 此時專案底下便有了: README.md / pyproject.toml / .python-version / uv.lock

### 依照 pyproject.toml 安裝套件
uv pip install -r pyproject.toml
# 上下兩者差異, 在於
uv pip install -r pyproject.toml --all-extras

### 安裝套件
uv add $PKG
uv add "mcp[cli]" httpx # 範例
