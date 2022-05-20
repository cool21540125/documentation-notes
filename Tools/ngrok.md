# ngrok

- 2022/04/22
- [Setup](https://dashboard.ngrok.com/get-started/setup)

下載 & 解壓縮完 ngrok 以後, 丟入 `~HOME/bin`

```bash
### Version
$# ngrok --version
ngrok version 3.0.2

### 配置(如果使用 anonymous, 最多九只能使用 6 hrs)
$# ngrok config add-authtoken <Ngrok 的 authtoken>

### 使用
$# ngrok http 80
```

### Container

```bash
docker pull wernight/ngrok

docker run -itd \
    --name ngrok
    wernight/ngrok
    ngrok http 8889
```