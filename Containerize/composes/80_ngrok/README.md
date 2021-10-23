# ngrok

- 2020/11/15



### login to ngrok

1. 網頁端登入 ngrok
2. 下載 && 安裝 ngrok
3. `ngrok authtoken <網頁端提供的token>`



### docker run ngrok

```bash
docker pull wernight/ngrok

docker run -itd \
    --name ngrok
    wernight/ngrok
    ngrok http 6789
```