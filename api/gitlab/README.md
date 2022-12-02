



## 

- [Pagination](https://docs.gitlab.com/ee/api/index.html#pagination)
    - 關於 Gitlab API, 預設回傳 20 筆
    - Gitlab 針對分頁有 2 種如下機制, 官方建議盡可能使用 `Keyset-based`
        - Offset-based pagination : (default), 適用於所有 Endpoints
            - request params:
                - page     : default 1
                - per_page : default 20, max 100
            - response header
                - 參考[Other pagination headers](https://docs.gitlab.com/ee/api/index.html#other-pagination-headers)
                - 如果看到這些 Response Header, 就表示使用此分頁機制
        - Keyset-based pagination : (逐步推出中), 對於大量資料分頁的取得, 此方式效能佳
            - request params:
                - pagination : Required. 若要使用此機制, 設定 `pagination=keyset` 就是了
                - sort       : Required. asc 或 desc
                - order_by   : Required. 要排序的欄位
                - per_page   : default 20, max 100
            - response header
                - `x-total`
                - `x-total-pages`
                - `rel="last"` `link`
