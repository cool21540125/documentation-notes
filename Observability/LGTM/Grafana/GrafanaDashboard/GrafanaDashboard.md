# Grafana Dashboard

- 用途: query, transform, visualize data
  - 可再視覺化以前, 先對 data 做 transform/

# Dashboard

- histograms
  - histograms 用來作 numerical data 的 distribution, 將 values group into buckets(也稱作 bins), 再針對 bucket 的 count
  - histograms 可用來查看, 特定時段內的資料分布(value distributions over a specific time range)
    - histograms 的缺點是, 無法看到趨勢的變化
- heatmaps
  - heatmaps 除了 histograms 功能以外, 可再加上時間變化
    - A heatmap is like a histogram, but over time, where each time slice represents its own histogram
    - 使用 cells 以及 colors

# Grafana Dashboard - Variables

- `ad hoc filters` 並非常規的 Dashboard filter. 可自行指定特定的 label name, label value 來做篩選.
  - 僅 Prometheus, Loki, influxDB, ElasticSearch 支援此 ad hoc filters
