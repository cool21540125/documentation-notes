

理解 Nginx 架構的方式, 可以將之拆解如下:

- Core Directive
    - Event Core Directive
        - Nginx 自身軟體運行管理
        - Nginx 事件驅動架構
    - HTTP Core Directive
        - 客戶端發起 HTTP Request、完成 HTTP Request Handle、回應 Request 的所有過程
        - 關閉 HTTP connection
- Module Directive
    - 對每個 Nginx 模組內對於模組的操作方法的相關配置


Nginx 常見的配置指令域如下:

- main : 此為 全局域, 其餘皆為 指令域.
- events
- http
- upstream
- server
- location
- stream : Nginx 對 TCP 協議實現代理的配置指令域.
- types
- if