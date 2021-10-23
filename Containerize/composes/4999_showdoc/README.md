# 透過 Docker 安裝 showdoc

- 2020/03/26
- [Docker安裝方式](https://www.showdoc.cc/help?page_id=65610)

```bash
docker pull star7th/showdoc


### 測試用
docker run --rm \
    -p 4999:80 \
    --name myshowdoc \
    star7th/showdoc


### 用久執行用 (無有 SELinux 問題的話, 再把底下的 「:Z」拿掉)
mkdir -p ./showdoc_data/html
chmod -R 777 ./showdoc_data
docker run -d \
    -p 4999:80 \
    -v ./showdoc_data/html:/var/www/html:Z \
    --name myshowdoc \
    star7th/showdoc
```
