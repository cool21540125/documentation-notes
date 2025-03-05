# ngrok

- 2023/04/15
- [Setup](https://dashboard.ngrok.com/get-started/setup)
- 神奇的 ngrok
  - 本地安裝好 `ngrok agent` 並啟用後, 會與 `Ngrok Service` 建立連線, 啟用 `ngrok Secure Tunnels`, 此為安全連線加密通道
    - 外界可藉由此 `public ngrok endpoint` 來訪問

### Container

```bash
docker pull ngrok/ngrok

docker run --net=host -it ngrok/ngrok http 80
```
