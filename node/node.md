
# 套件管理

關於版本號相關, 參考 Versioning.md

- `npm update` - 更新到最新的 *.*.*
- `npm i`      - 更新到最新的 x.*.*
- `npm ci`     - 更新到最新的 x.y.*


# Expo

- tool chain
- 可透過 React Native 簡化 iOS 和 Android 專案的啟動和開發
- `npm i -g expo-cli`


# Nodemon

- 用來作 node 的 live debug (auto-reload)


# 模組化

STUDY: 06/03 - https://blog.logrocket.com/commonjs-vs-es-modules-node-js/

- Browser 環境使用 js 模組時, 使用 `import` 及 `export` 操作 `ECMAScript modules` (or `ES modules`)
    - ES modules 為 Official, 並支援大多數 Browser
- Commonjs 是在早期 (Nodejs v8.X) 搞出來的東西, 使用 `require` 及 `module.exports` 操作 `CommonJS modules`
    - 當時還得使用 `--expreimental-modules` 不過後來在 (Nodejs v13.2) 原生支援了 ES Modules
- ES modules 為 standard for Javascript; 而 CommonJS 為 default in Node.js
- 選擇使用 `ES modules` 的方式之一
    - Library Authors 有時也會使用 `.mjs` 來 simply enable ES modules in a Node.js package
        - 可直接參考 https://blog.logrocket.com/commonjs-vs-es-modules-node-js/ 的使用方式
    - 直接在 package.json 聲明 `"type": "module"` (如果這樣做的話, 就可以不需要使用 `.mjs` 操作了)
- module 選擇: "commonjs" 或 "esXXXX"
    - es2020 | es2018 | es2016
        - 


# GraphQL

- GraphQL Api 的主要 2 個構件為: 
    - 結構描述
        - 包含 5 種內建純量: String / Boolean / Int / Float / ID
    - 解析程式: **Query** 及 **Mutation**
