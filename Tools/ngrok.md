# ngrok

- 2023/04/15
- [Setup](https://dashboard.ngrok.com/get-started/setup)
- 神奇的 ngrok
    - 本地安裝好 `ngrok agent` 並啟用後, 會與 `Ngrok Service` 建立連線, 啟用 `ngrok Secure Tunnels`, 此為安全連線加密通道
        - 外界可藉由此 `public ngrok endpoint` 來訪問


```bash
### 下載 & 解壓縮完 ngrok 以後, 丟入 `~HOME/bin`

### Version
ngrok --version
#ngrok version 3.2.2


### 配置(如果使用 anonymous, 最多九只能使用 6 hrs)
ngrok config add-authtoken ${網頁上看到的Token}
#Authtoken saved to configuration file: $HOME/.ngrok2/ngrok.yml


### Ngrok Agent
ngrok http 80

### Ngrok Agent + Basic Authentication
ngrok http 8000 --basic-auth '帳號:密碼'

### Ngrok Agent + Google OAuth 2.0
ngrok http 8000 --oauth google


### 診斷 Ngrok 狀況
ngrok diagnose
# --------- output --------
#Testing ngrok connectivity...
#
#Internet Connectivity
#  Name Resolution                           [ OK ]
#  TCP                                       [ OK ]
#  TLS                                       [ OK ]
#Ngrok Connectivity - Region: United States
#  Name Resolution                           [ OK ]
#  TCP                                       [ OK ]
#  TLS                                       [ OK ]
#  Tunnel Protocol                           [ OK ]
#Successfully established ngrok connection! (region: 'us', latency: 202.285637ms)
# --------- output --------


### 
```


### Container

```bash
docker pull ngrok/ngrok

docker run --net=host -it ngrok/ngrok http 80
```
