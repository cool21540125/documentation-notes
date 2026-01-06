- [Life of a Label](https://www.robustperception.io/life-of-a-label/)
- [relabel_configs vs metric_relabel_configs](https://www.robustperception.io/relabel_configs-vs-metric_relabel_configs/)
- https://crossoverjie.top/2023/03/13/metrics/relabel_configs_%20metric_relabel_configs/


# relabel_configs

relabel_configs 用來規範, 要 scrape 哪些 targets

relabel 的基本原則, 如果探詢到

- machine type
- tags
- __meta_*

等等的 labels, 則可以在 `relabel_configs` 做 `relabel`

以及相關的 `drop` 及 `keep` actions

```yml
relabel_configs:

  - source_labels: [ __address__ ]
    regex: '192.x.x.x:80'
    action: drop  # scrap target 的任務會被捨棄 (也就是根本就不會去抓)

```


# metric_relabel_configs

metric_relabel_configs 用來規範, scraped metrics 回來了以後, 哪些 metrics 是要被儲存的

metric_relabel_configs 具體用途, 是在 prometheus 保存 metrics 以前的最後一步 標籤重新編輯(relabel_configs)

也就是將不需要的 metrics 直接丟掉 (不保存在 prometheus 當中)

```yml
metric_relabel_configs:

  - source_labels: [ __name__ ]
    regex: "up{job="prometheus"}"
    action: drop  # 刪除不必要 metrics

  - source_labels: [ __name__ ]
    regex: "container_label_org_.+"
    action: labeldrop  # 刪除不必要 label

  - source_labels: [ container ]
    regex: (.+)
    target_label: container_name
    replacement: $1
    action: replace  # 修改 metric label
    separator: ,

```
