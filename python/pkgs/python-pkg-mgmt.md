
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


# 未整理

- requirements.in  類似於 package.json
- requirements.txt 類似於 pakage-lock.json
