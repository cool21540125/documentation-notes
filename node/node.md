
# Node.js 基礎與模組化

## 模組化系統

### CommonJS (CJS) vs ES Modules (ESM)

- Node.js 支援 2 種模組系統, 建議優先使用標準化的 ES Modules
    - AWS Lambda 也建議優先使用 ES Modules, 因為他支援 top-level await
        - 因為可在執行 環境初始化期間 完成非同步任務

*   **CommonJS (CJS)**
    *   **地位**：Node.js 傳統的預設模組系統 (如果命名為 `.js`, 則 Nodejs 預設會將他識別為 CJS)
    *   **語法**：使用 `require()` 匯入, `module.exports` 匯出
    *   **特性**：同步載入, 主要用於伺服器端環境
*   **ES Modules (ESM)**
    *   **地位**：JavaScript 的官方標準（ECMAScript 規範）, 瀏覽器只讀得懂這種 ESM
    *   **語法**：使用 `import` 匯入, `export` 匯出
    *   **特性**：非同步載入, 支援靜態分析與 Tree-shaking

### 如何在 Node.js 中啟用 ESM

1.  **副檔名區隔**：使用 `.mjs` 檔案, Node.js 會自動視為 ESM；`.cjs` 則視為 CommonJS
2.  **Package 設定**：在 `package.json` 中加入 `"type": "module"`, 該目錄下的 `.js` 檔案會被視為 ESM

---

## 核心開發工具生態系

### 套件管理

*   `npm update` - 更新到最新的 *.*.*
*   `npm i`      - 更新到最新的 x.*.*
*   `npm ci`     - 根據 `package-lock.json` 安裝精確版本, 適用於 CI/CD

### 建置與打包 (Bundlers)

*   **Webpack**：強大的模組打包程式（Bundler）, 支援 HMR (熱模組替換) 與 Lazy Loading
*   **Vite**：現代前端工具, 開發環境下利用瀏覽器原生 ESM 特性, 啟動速度極快

### 程式碼檢查與轉譯

*   **ESLint**：Code 風格檢查工具
*   **Babel**：將新版語法 (ES6+) 編譯為 ES5 以支援舊型瀏覽器
*   **Flow**：靜態類型檢查工具（現代專案多改用 TypeScript）

### 開發輔助

*   **Nodemon**：用於 Node.js 的 live debug, 當檔案變動時自動重啟服務（auto-reload）


### Expo

- tool chain
- 可透過 React Native 簡化 iOS 和 Android 專案的啟動和開發
- `npm i -g expo-cli`

### babel

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

### Spread Operator

```js
// 展開運算符(Spread Operator)
const arr1 = ["hello", true, 7]  // 不被影響
const arr2 = [1, 2, ...arr1]  // [1, 2, "hello", true, 7]
// 做了 陣列的淺拷貝

// 
```


## Promise

### 基本概念

- promise 通常與 future, delay, deferred 等名詞意思相近, 代表 因為計算尚未完成時, 此時結果懸而未決的代理物件
- promise 狀態: pending / fulfilled / rejected
    - pending promise
        - fulfilled 狀態, 得到 value
        - rejected 狀態, 得到 reason

# Node 環境變數

- NODE_ENV
    - 最早一開始起源於 Express. 用來判斷運行環境是 development OR production
    - 後來開始被廣泛的濫用, 維運人員發現開發人員將不同的變數依賴於此環境變數, 導致在部署階段常常搞不清楚應該如何有效部署, 進而衍生出更多亂七八糟的自定義環境變數命名
- NODE_OPTIONS
    - 用來作為所有 node process 啟動時, 用來傳遞參數且順位較低的替代方案