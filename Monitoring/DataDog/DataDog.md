
# Monitors

- time window
    - ![time window](../img/time%20window.png)
- DDog 有 2 種 notifications: `alert` 及 `warning`
- 



# Metric Types

- 發送到 DDOG 的每個 metric 都有個 **submitted type**
    - 此 metric type 會影響 查詢時, 如何呈現該 metric values 的方式
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
                - 假設 特定時段(10 secs 內) host 觸發了 [1,1,1,2,2,2,3,3] 的 values, 則 Agent 會將 此一段時間的 values 加總, 得到 15, COUNT metric's value
            - RATE
                - 假設 特定時段(10 secs 內) host 觸發了 [1,1,1,2,2,2,3,3] 的 values, 則 Agent 會將 {{此加總數值 15 / 時段內秒數 10secs}}, 則會得到 1.5, RATE metric's value
            - GAUGE
                - 假設 特定時段(10 secs 內) host 觸發了 [71,71,71,71,71,71,71.5] 的 values, 則 Agent 會取最後一筆 71.5, GAUGE metric's value
            - HISTOGRAM
                - 假設 特定時段(10 secs 內) host 搜集了 [1,1,1,2,2,2,3,3] 的 values `request.response_time.histogram`, 則 Agent 會回傳底下的 metrics:
                    - `request.response_time.histogram.avg`, 1.88, DataDog IN-APP Type: GAUGE
                    - `request.response_time.histogram.count`, 0.8, DataDog IN-APP Type: RATE
                    - `request.response_time.histogram.median`, 2, DataDog IN-APP Type: GAUGE
                    - `request.response_time.histogram.95percentile`, 3, DataDog IN-APP Type: GAUGE
                    - `request.response_time.histogram.max`, 3, DataDog IN-APP Type: GAUGE
            - DISTRIBUTION
                - 一段時間內橫跨整個 distribution infra 的 global statistical distribution of a set of values
                - DISTRIBUTION metric 會在時間區間內, 發送所有的 raw data 到 Datadog (Server Side 進行 Aggregation)
                    - 因此具備兩個特色: `Calculation of percentile aggregations` && `Customization of tagging`
                - 假設有 2 個 hosts, 分別發送了底下的 values:
                    - `webserver:web_1` -> [1,1,1,2,2,2,3,3]
                    - `webserver:web_2` -> [1,1,2]
                    - 則可計算出底下的 global statistical distribution of all values collected from both webservers:
                        - `avg:request.response_time.distribution`, 1.73, DataDog IN-APP Type GAUGE
                        - `count:request.response_time.distribution`, 11, DataDog IN-APP Type COUNT
                        - `max:request.response_time.distribution`, 3, DataDog IN-APP Type GAUGE
                        - `min:request.response_time.distribution`, 1, DataDog IN-APP Type GAUGE
                        - `sum:request.response_time.distribution`, 19, DataDog IN-APP Type COUNT
                    - 除此之外還可計算 p50, p75, p90, p95, p99
            - SET
                - 官方還有列出這個, 但我懷疑這個放錯了. 點進去以後, 跑到 Python StatsD 的 documentation
- 上述的那些 Submission types 會被 map 到底下 4 種 *in-app metric types*:
    - COUNT
    - RATE
    - GAUGE
    - DISTRIBUTION



