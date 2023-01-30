
# 

- 發送到 DDOG 的每個 metric 都有個 submitted type
- 上述的 metric type 會影響 查詢時, 如何呈現該 metric values 的方式
- 可利用下列的 submission methods 來將 metrics 發送到 DDOG:
    - [Agent check](https://docs.datadoghq.com/metrics/custom_metrics/agent_metrics_submission/?tab=count)
        - 最主要都是用此方式來將 agent 端的 metrics 送往 Server
    - [DogStatsD](https://docs.datadoghq.com/metrics/custom_metrics/dogstatsd_metrics_submission/)
    - [Datadog's HTTP API](https://docs.datadoghq.com/api/latest/metrics/#submit-metrics)
- Submission types
    - Submit 這動作指的是, **資料搜集端(以下統稱 Agent)** 將 metrics 發送到 DDOG 的這個動作
        - 資料搜集 可能是 每1秒一筆, 每2秒一筆, 然後每隔一個 flush time interval(ex: 20秒), 依照 Submission Type 將之作 aggregate, 再 submit/flush 到 DDOG
        - Agent 負責將蒐集到的這些 values, combine into single representative value, 作為該資料期間的 metric value.
        - 若由 API 方式直接 submit 到 DDOG 的 data, 除了 `distribution metrics` 以外, 都不會被 DDOG aggregate
    - 如果發送到 DDOG 的 metric type 並未聲明, 則會被視為 `Not Assigned`
        - 無法被匹配到對應的 *in-app metric types*
    - Submission Types 說明:
        - Submission types, 總共有底下這些:
            - COUNT
                - 假設特定時段收集到了 [1,1,1,2,2,2,3,3], 則 Agent 會將之
            - RATE
            - GAUGE
            - HISTOGRAM
            - DISTRIBUTION
- 上述的那些 Submission types 會被 map 到底下 4 種 *in-app metric types*:
    - COUNT
    - RATE
    - GAUGE
    - DISTRIBUTION




