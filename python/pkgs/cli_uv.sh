#!/bin/bash
exit 0
# 似乎是個比 pip 更快的 package manager
# uv 和 poetry 相比的話, 差異在: uv 是一個 CLI 工具, 而 poetry 是一個完整的 Python package 管理器
# ------------------------------------------------------------------------

### 使用 uv 起始一個專案
uv init $PROJECT_NAME
uv init $PROJECT_NAME --no-git # 不使用 git
uv init $PROJECT_NAME --app
uv init $PROJECT_NAME --lib

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
# 等同於 pip install $PKG (但會同時同步 dependencies 到 pyproject.yaml)
# 並且會生成 uv.lock
uv remove $PKG

### 查看整個專案的依賴結構
uv tree

### 進入 uv project dir 以後, 可以免除再做去 source python (直接執行, 直接使用虛擬環境)
uv run main.py

### (不是很懂)
uv sync

### ==================================== (從 OLD pip project 遷移到 uv project) ====================================
uv init
uv add -r requirements.txt
cat pyproject.yaml
rm -f requirements.txt

### ==================================== uv tool (處理 python based global CLI 啦) ====================================
### 在 PATH 底下安裝 Global CLI tools
uv tool install ruff # 安裝 global inting for python
# $HOME/.local/bin/ruff
uv tool uninstall ruff

### 等同於 npx
uv tool run ruff check
#可簡寫為
uvx ruff check

uv tool list

uv tool upgrade --all

### ====================================
