# node.js
- 可預見的幾個月內, 這邊應該不會有什麼變動...
- 2018/04/08

## Script

```sh
### 建立 package.json
$ npm init
```

## Dir


> package.json : 專案所用到的套件版本, 專案版本, npm 指令

> package-lock.json : 用來記錄 package.json 更加細節的內容, dependency... (通常不會理他) (npm5 新增的東西)


```sh
### production bundle
$ npm install --save

### development purpose, ex: linter, testing, libraries, ...
$ npm install --save-dev
```

```bash
# 會把 express 儲存到 package.json 當作 dependencies, 將來可直接 `npm install`
$ npm install --save express

```


# packages

- babel : 用來做 web 開發, 可將擴展後的 js (ex: jsx) 編譯回(瀏覽器可是別的) javascript. 用來作為無限擴展 js 的工具
