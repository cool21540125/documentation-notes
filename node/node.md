
# node

- eslint
    - Code 風格檢查工具
- webpack
    - 模組打包程式(bundler), 內有特殊的載入器設計, 可提供開發時的 熱模組替代(Hot Module Replacement, HMR) 功能
    - 產出打包整個 App 檔案的功能
- flow
    - 靜態類型檢查工具
    - coding 時, 加入靜態類型標記(方便 dev 階段檢查), 最後 comiple 時, 由 babel 相對的擴充去除這些標記


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


# babel

- 主要用來編譯 ES6+ Code, 產出為 ES5 Code, 用來支援大多數瀏覽器.
- 相較於 ES6/ES7/ES8/..., ES6 與 ES5 有較大的變革, 因而 ES6 以後, 可稱為 ES6

```js
// ------------- JSX 寫法 -------------
const HelloWorld = (props) => (
    <div>
        <h1>{props.text}</h1>
    </div>
)
// ===========================================

// ------------- 經過 babel 編譯後 -------------
"use strict";

var HelloWorld = function HelloWorld(props) {
    return React.createElement(
        "div",
        null,
        React.createElement(
            "h1",
            null,
            props.text
        )
    );
};
// ===========================================
```


## misc

```js
// 展開運算符(Spread Operator)
const arr1 = ["hello", true, 7]  // 不被影響
const arr2 = [1, 2, ...arr1]  // [1, 2, "hello", true, 7]
// 做了 陣列的淺拷貝

// 
```


## Promise

- promise 通常與 future, delay, deferred 等名詞意思相近, 代表 因為計算尚未完成時, 此時結果懸而未決的代理物件
- promise 狀態: pending / fulfilled / rejected
    - pending promise
        - fulfilled 狀態, 得到 value
        - rejected 狀態, 得到 reason

```js
const pro = new Promise(function(resolve, reject) {
    // ...
})

pro.then(function(value) {
    // on fulfillment
}, function(reason) {
    // on rejection
})

fetch(url, httpOption)
    .then(function(response) {
        // process data
        if (!response.ok) throw new Error(response.statusText)
        return response.json()
    })
    .catch(function(err) {
        // process error
})
```
