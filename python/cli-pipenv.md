
# pipenv

- 預設會把 `虛擬環境` 放到 `$HOME/.local/share/virtualenvs/ProjectName_Hash`
- 如果希望自訂 虛擬環境 位置, 擇一使用下列的環境變數 
    - `export PIPENV_VENV_IN_PROJECT=1` 
        - 固定虛擬環境在 **專案根目錄的 .venv**
    - `export WORKON_HOME="~/.venv`
        - 這種方式只是設定, 虛擬環境的 家目錄 放在這, by 專案會在建立 ProjectName_Hash 作為 各別專案的虛擬環境目錄


```bash
### 在 global 層級先安裝 pipenv
python3 -m pip install pipenv


### 使用 pipenv 建立 python 3.x 的虛擬環境
pipenv --python 3.9


### 安裝套件
pipenv install xxx
# (僅擷取部分)
# Virtualenv location: $HOME/.local/share/virtualenvs/Proj_venv  # 預設
# 除非有額外設定 PIPENV_VENV_IN_PROJECT 及 WORKON_HOME


# ============================ 查詢環境相關 ============================

### 列出目前 pipenv 所控管的專案位置
pipenv --where


### 列出目前 pipenv 虛擬環境位置
pipenv --venv


### 目前 虛擬環境 python 直譯器位置
pipenv run which python


# ============================  ============================

### 移除 pipenv 的虛擬環境
pipenv --rm


### 依照 Pipfile.lock 安裝依賴
pipenv install --ignore-pipfile  # 由 Pipfile.lock 安裝依賴 (完全忽略 Pipfile)
pipenv sync                      # 由 Pipfile.lock 安裝依賴 (且不修改它)


### (等同於 npm install) 依照 Pipfile 來更新 Pipfile.lock
pipenv lock


### (等同於 pip freeze)
pipenv requirements


### 

```
