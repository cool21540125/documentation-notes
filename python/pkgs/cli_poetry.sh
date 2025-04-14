#!/bin/bash
exit 0
#- 都快要 2024 了, 不要再用 pip 了, 改用 poetry 吧
#- 如果已經改用 poetry 了以後, 可能不再需要 requirements.txt 了
#    - 不過, 建議還是讓 requirements.txt 與 poetry.lock 同步
#    - 如果包成 Docker, 會發現他還是很好用的....
# ------------------------------------------------------------------------------------------------------------

### 系統層級安裝 poetry
poetry --version
#Poetry (version 2.1.2)

### ================================ 指令相關配置 ================================

### 關閉掉像是 poetry export (pip freeze) 的 warning
poetry config warnings.export false

### 查看 poetry 的配置
poetry config --list | grep virtualenvs

### ================================ 建立虛擬環境 ================================

### 如果從 SourceCode 拉下來以後, 裡頭已有 pyproject.toml, 由此開始建立虛擬環境 && 安裝依賴
poetry config virtualenvs.in-project true
poetry install

### 專案內必須要先有 pyproject.toml
poetry init
# 互動式方式填入一些必要資訊

### 建立 虛擬環境 (必須要先有 pyproject.toml)
poetry env use python3.12

### 進入虛擬環境
poetry shell

### 安裝套件
poetry add XXX
# 等同於 pip install XXX
# 1. 把所需安裝的套件, 記錄到 pyproject.toml
# 2. 依照 pyproject.toml, 更新 poetry.lock
# 3. 依照 poetry.lock, 更新 .venv

### (Poetry >= 1.2.0) 僅安裝依賴到 dev-dependencies
poetry add XXX --group dev
poetry add XXX -G dev
# 等同於 npm i xxx -D

### (Poetry < 1.2.0) (Legacy) 僅安裝依賴到 dev-dependencies
#poetry add XXX --dev
#poetry add XXX -D

### 同步版本依賴
poetry lock
# 如果手動編輯了 pyproject.toml, 使用此方式可讓以脫鉤的 poetry.lock 同步
# 像是由 flask 2 升級到 flask 3, 後續的依賴都需要做一次 update
# 但是這動作只會更新 poetry.lock, 並不會更新 .venv

### 安裝依賴 (等同於 npm install)
poetry install
# 依照 pyproject.toml && poetry.lock 做套件安裝

### 更新指定套件
poetry update XXX YYY

### 更新所有可能可以更新的套件
poetry update

### 列出已安裝套件
poetry show
# 列出的套件來自於 poetry.lock 而非 .venv

### 列出結構依賴
poetry show --tree

### 移除套件
poetry remove XXX
poetry remove -D XXX

### 生成 requirements.txt
poetry export --without-hashes --format=requirements.txt >requirements.txt
poetry export --without-hashes --format=requirements.txt --dev >requirements.txt

### ================================ 移除 虛擬環境 ================================

### 如果希望讓 venv 建立在專案內, 改用這樣的配置
poetry config virtualenvs.in-project true
# 此指令等同於 POETRY_VIRTUALENVS_IN_PROJECT=true
# 否則, 預設會把 venv 建立到 $HOME/Library/Caches/pypoetry/virtualenvs/${DIR_NAME}-HASH-py3.X

### 移除 $HOME/Library/Caches/pypoetry/virtualenvs/ 底下的 venv
poetry env remove python3
# (如果在當前目錄, 自己 rm -rf 就好)
# 如果已經配置了 virtualenvs.in-project=true 的話, 那就用不到這 CLI 了

###
