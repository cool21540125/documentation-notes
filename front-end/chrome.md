# Chrome

- 2018/09/17
- [Chrome Develop Tools](https://developers.google.com/web/tools/chrome-devtools/?hl=zh-tw)
- [Git Book - Chrome開發手冊](https://leeon.gitbooks.io/devtools/content/)
- [Dev Tools Tutorial](https://www.pluralsight.com/courses/tactics-tools-troubleshooting-front-end-web-development)


## 商店

Google 查 `web chrome store`


## Chrome

URL : `chrome://flags/`

開啟 `Developer Tools experiments`


## 好用指令

```js
console.table(jsonObj);
```


## Measure Dimensions

## Wappalyzer

## Toggle Pesticide


# Chrome Developer Tool - Network

- https://www.youtube.com/watch?v=gAD2uf3xdC8&list=PLoZQ0sz6CBHGLlYNKB-yzDRasrAYytelS&index=9
  - 07:20 ~ 10:45 - 屬性過濾器
  - 14:05 ~ 14:24 - 增加 custom Reponse Headers
  - 16:19 ~ 17:35 - Response Resource (按住 Shift, 綠色上游, 紅色下游)
  - 18:13 ~ 20:28 - 整個頁面的 Request waterfall
    - 也可直間參考 Chrome for Developers - https://developer.chrome.com/docs/devtools/network/reference/?utm_source=devtools#timing-explanation

- 搜尋列工具(過濾器)
  - `domain:xxx method:XXX` (屬性之間用空格格開)
  - 可使用的過濾屬性:
    - domain
    - has-response-header
    - is
      - `is:running` 可用來查找 WebSocket 資源
      - `is:from-cache` 可查找快取讀出的資源
    - larger-than
      - 預設為 `larger-than:1000` 等同於 > 1K
    - method
    - mime-type
      - `mixed-content:all`
      - `mixed-content:displayed`
    - mixed-content
      - `scheme:http`
      - `scheme:https`
    - scheme
    - set-cookie-domain
    - set-cookie-name
    - set-cookie-value
    - status-code