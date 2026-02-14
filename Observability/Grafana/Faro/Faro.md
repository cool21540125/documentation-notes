# Faro - 讓前端具備觀測

## Faro signals 與 Alloy Receiver

- 前端發送 Signals 到 Alloy 的選擇:
  - 藉由引入 `@grafana/faro-web-sdk`,                                       讓前端發送: `Faro format signals` 到 Alloy 的 `faro.receiver`
  - 藉由引入 `@grafana/faro-web-sdk` & `@grafana/faro-transport-otlp-http`, 讓前端發送: `OTLP format signals` 到 Alloy 的 `otelcol.receiver.otlp`

- Faro 發送的 logs
  - kind
    - measurement             -- 效能指標
      - type: web-vitals          -- Core Web Vitals（INP、LCP、CLS、FCP、TTFB）
      - type: navigation          -- 頁面導航時間
      - type: resource            -- 資源載入時間
      - type: custom              -- Core Web Vitals（INP、LCP、CLS、FCP、TTFB）
    - log                     -- 一般日誌
      - type: console
    - event                   -- 使用者事件
      - type: click
    - exception               -- 錯誤異常
      - type: error
    - trace                   -- 

```ini
## 前端效能監控的 Web Vitals 指標 log, 記錄使用者互動的回應速度
# 核心指標 INP (Interaction to Next Paint)

timestamp="2026-01-16 07:18:22.699 +0000 UTC"
kind=measurement
type=web-vitals
inp=48.000000  # user 操作到畫面更新的總延遲
context_rating=good  # 評級良好（<200ms）
input_delay=11.100000  # 拆解延遲 - 1 瀏覽器接收到輸入的延遲
processing_duration=6.600000  # 拆解延遲 - 2 執行 JavaScript 處理時間
presentation_delay=30.300000  # 拆解延遲 - 3 渲染到螢幕的延遲
context_interaction_type=pointer  # 觸發原因 - 滑鼠/觸控操作
context_navigation_type=reload    # 觸發原因 - 重整頁面觸發
context_load_state=complete  # 頁面已載入完成
sdk_version=2.1.0    # log 來源
app_name=fe_web      # log 來源
app_environment=stag # log 來源
session_id=M1bNhaVDVV  # #### Session ####
delta=48.000000
interaction_time=786969.900000
next_paint_time=787017.900000
context_id=v5-1768547112756-1004531620547
context_navigation_entry_id=DYQDp215ak
value_delta=48
value_inp=48
value_input_delay=11.100000023841858
value_interaction_time=786969.8999999762
value_next_paint_time=787017.8999999762
value_presentation_delay=30.299999952316284
value_processing_duration=6.600000023841858
page_url=http://localhost:5173/
browser_name=Chrome  # @@ Browser @@
browser_version=143.0.0.0  # @@ Browser @@
browser_os="Mac OS 10.15.7"  # @@ Browser @@
browser_mobile=false  # @@ Browser @@
browser_userAgent="Mozilla ...(pass)... 537.36"  # @@ Browser @@
browser_language=en-US  # @@ Browser @@
browser_viewportWidth=2400  # @@ Browser @@
browser_viewportHeight=1138  # @@ Browser @@
```