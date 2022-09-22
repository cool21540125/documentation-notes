# Jumpserver

- [docs](https://docs.jumpserver.org/zh/master/)
- [source](https://github.com/jumpserver/jumpserver)

- Lina : JumpServer Web UI

- CORE : Django API backend


- Jumpserver : 管理後台
    - 管理員 : 資產管理, 用戶管理, 資產授權等操作
    - 用戶 : 透過 Web 登入資產, 進行檔案管理的操作
- CoCo/KoKo : SSH Server && Web Terminal Server && Character protocaol Connector
    - CoCo: OLD, python base
    - KoKo: NEW, golang base
        - `/koko`
- Luna : 純靜態文件. JumpServer Web Terminal 的 front-page. 用戶使用 Web Terminal 需要此元件
    - `/luna`
- Lina : 純靜態文件.
    - `/ui`
- Core : JumpServer 核心. Django 開發, 內建 Gunicorn Celery Beat Flower Daphne
    - `/core`
- Lion : 
    - `/lion`
- Guacamole : RDP && VNC Protocol 資產套件