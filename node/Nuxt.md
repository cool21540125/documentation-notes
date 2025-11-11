# nuxt

- nuxt 的 Server 使用 `Nitro`
  - 可以把 Nitro 的功能, 視為是等同於 Django 的 render template 的功能
    - 只不過 Nitro 的 template 是整個 Vue Element Tree
    - Nitro 透過 SSR 生成 html, 再由 Browser 的 Vue 接手成 SPA
  - Nitro 被用來與 Nuxt 搭配, 作為 `渲染伺服器引擎`
  

# nuxt.config.ts

```ts
// nuxt.config.ts
// 

// defineNuxtConfig 裡頭的東西為 global, 可在 App 裏頭, 藉由 `const runtimeConfig = useRuntimeConfig()` 取得並使用環境變數
export default defineNuxtConfig({

  // runtimeConfig 裡頭的東西, 可以被 環境變數 覆寫
  runtimeConfig: {
    // runtimeConfig.public 及 runtimeConfig.app 以外的 keys 只適用於 server-side
    apiSecret: '123',

    // runtimeConfig.public 及 runtimeConfig.app 則同時適用於 server-side && client-side
    public: {
      apiBase: '/api',
    },
    app: {
      a: 'b'
    }
  },
})
```


# app.config.ts

```ts
// app/app.config.ts
// 用來放置 build time 就決定, 並且不會被 runtime 覆蓋的東西

// 使用方式: const appConfig = useAppConfig()
export default defineAppConfig({
  title: 'Hello Nuxt',
  theme: {
    dark: true,
    colors: {
      primary: '#ff0000',
    },
  },
})
```


# Nuxt 目錄結構

- .nuxt
- assets        用於打包
  - example.png      會參與打包. 從 `~/assets/example.png` 訪問
- components    放置 Vue 組件
- layouts       
  - default.vue          (預設佈局格式)
  - error.vue            錯誤頁面內容 (路徑錯誤會跑來這邊)
  - error_layout.vue     錯誤頁面佈局
- middleware    
- modules       官方支援的外部模組, ex: axios
- pages         
- plugins       非官方支援的外部模組
- static        不參與 Vue 及 Nuxt 的編譯處理
  - robots.txt          (不參與打包) 用來給爬蟲程式參考的指引
  - landing_page.html   (不參與打包) 還可放置像是 Landing Page. 直接從 `/landing_page.html` 訪問
- store         Vue 的狀態管理, 用於套件之間的交換. Vue 內建為 Vuex/vuex(應該啦), 但常看到有人用 pinia
