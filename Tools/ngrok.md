# ngrok

- 2023/04/15
- [Setup](https://dashboard.ngrok.com/get-started/setup)

下載 & 解壓縮完 ngrok 以後, 丟入 `~HOME/bin`

```bash
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
```

### Container

```bash
docker pull ngrok/ngrok

docker run --net=host -it ngrok/ngrok http 80
```
