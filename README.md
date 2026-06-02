# 自學筆記 - 資料夾分類

- Start from 2017/07

```bash
tree -I 'node_modules|venv|.git|bin|obj|*.png|*.svg|resources/config|*.drawio'

find . -name '*' \
    ! -path "**/node_modules/*" \
    ! -path "**/venv/*" \
    ! -path "./.git/*" \
    ! -path "**/bin/*" \
    ! -path "**/obj/*" \
    ! -path "**/*.png" \
    ! -path "**/*.svg" \
    ! -path "**/resources/config/*" \
    ! -path "**/*.drawio" \
    | wc -l
```

## 代碼依賴視覺化

```
## Globally install
npm i -g gitnexus

## Project Analyze
gitnexus analyze

## Project Server
gitnexus serve

## Frontend UI
git clone https://github.com/abhigyanpatwari/gitnexus.git
cd gitnexus/gitnexus-shared && npm install && npm run build
cd ../gitnexus-web && npm install
npm run dev
# Then in another terminal, start the backend the frontend connects to:
npx gitnexus@latest serve
# 訪問 http://localhost:5173/
```

## Interesting URLs

- [隨機用戶產生器](https://randomuser.me/api/)
- [Dog Api](https://dog.ceo/dog-api/)
- [產生人像](https://generated.photos/)
- [假 API](https://reqres.in/)
- [MyIP](https://api.my-ip.io/ip)
- [隨機 User](https://jsonplaceholder.typicode.com/users)
- [Live Webhook](https://webhook.site)

## Open Data

- [Registry of Open Data on AWS](https://registry.opendata.aws/)

by TonyCC

- https://blog.tonychoucc.com
