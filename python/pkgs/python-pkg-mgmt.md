
- 2023/12/21
- [最佳 Python 套件管理器——Poetry 完全入門指南](https://blog.kyomind.tw/python-poetry/)


# 套件管理

- [Podcast - 和 PyPA 的成员聊聊 Python 开发工作流](https://pythonhunter.org/episodes/ep15)
- pip
    - 算得上是 Python 裡頭最古老的套件管理 CLI
    - 最一開始的任務, 就是幫忙安裝套件
        - 還沒有它以前, 安裝 pkg 需要先去抓 wheel 或 src.tar.gz, `python setup.py install` (要進到下載下來的套件裡頭)
        - 有了它以後, `pip install XXX`, 則會到 https://pypi.org/simple/XXX/ 去抓取套件
- easy_install
    - 對他不熟, 希望一輩子都沒機會認識
- pipenv
    - 比 pip 還要更加完善的套件管理工具
    - 可以解析 dependency tree
        - 處理 deps 的 deps, pip 則無此功能
- 2023 年的現在, 社群上似乎風向大家推薦使用 poetry
    - npm    使用 `package.json`
    - pipenv 使用 `Pipfile`
    - poetry 使用 `pyproject.toml`
- python 虛擬環境工具
    - virtualvenv       : 由 PyPA 孵化
    - venv              : 忘了哪個版本開始, 內建到 Python Standard
- python 其他環境工具
    - pyenv             : 用來建立不同的 python version (等同於 Nodejs 的 nvm 及 Ruby 的 rvenv)
    - pyenv-virtualvenv : 就只是把上面提到的 pyenv 及 virtualvenv 再包一層
    - tox               : 多版本測試工具(沒用過)
    - conda             : 基本上可以理解曾系統層級的虛擬環境包... (別用就是了)


# poetry

- 都快要 2024 了, 不要再用 pip 了, 改用 poetry 吧
- 如果已經改用 poetry 了以後, 可能不再需要 requirements.txt 了
    - 不過, 建議還是讓 requirements.txt 與 poetry.lock 同步
    - 如果包成 Docker, 會發現他還是很好用的....

```bash
### 系統層級安裝 poetry
poetry --version
#Poetry (version 1.7.1)


### 查看 poetry 的配置
poetry config --list


### 如果希望讓 venv 建立在專案內, 改用這樣的配置
poetry config virtualenvs.in-project true
# 否則, 預設會把 venv 建立到 $HOME/Library/Caches/pypoetry/virtualenvs/${DIR_NAME}-HASH-py3.X


### 關閉調升成像是 poetry export (pip freeze) 的 warning
poetry config warnings.export false


### 專案內必須要先有 pyproject.toml
poetry init
# 互動式方式填入一些必要資訊


### 建立 虛擬環境 (必須要先有 pyproject.toml)
poetry env use python3.11


### 移除 $HOME/Library/Caches/pypoetry/virtualenvs/ 底下的 venv
poetry env remove python3
# (如果在當前目錄, 自己 rm -rf 就好)
# 如果已經配置了 virtualenvs.in-project=true 的話, 那就用不到這 CLI 了


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

### (Poetry < 1.2.0) 僅安裝依賴到 dev-dependencies
poetry add XXX --dev
poetry add XXX -D



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
poetry export --without-hashes --format=requirements.txt       > requirements.txt
poetry export --without-hashes --format=requirements.txt --dev > requirements.txt


### 
```


# 未整理

- requirements.in  類似於 package.json
- requirements.txt 類似於 pakage-lock.json
