# relabel_configs

```yaml
scrape_configs:
  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    relabel_configs:
      - source_labels: [__meta_kubernetes_node_label_monitoring]
        regex: "true"
        action: keep
```

這段配置是在 **篩選 targets**,只保留有 `monitoring` label 的 node

Relabel Action: keep - `action: keep` 的意思是: 只保留符合 `regex` 條件的 targets, 其他全部丟棄

實務上, 常用來選擇性監控特定 node, 避免抓取不必要的 targets

**Node 1:**

`__meta_kubernetes_node_label_monitoring: "true"` → 符合 regex → **保留**
```yaml
labels:
  kubernetes.io/hostname: worker-1
  monitoring: "true"
```

**Node 2:**

沒有 monitoring label → `__meta_kubernetes_node_label_monitoring` 不存在 → 不符合 → **丟棄**
```yaml
labels:
  kubernetes.io/hostname: worker-2
```

**Node 3:**

`__meta_kubernetes_node_label_monitoring: "false"` → 不符合 regex `"true"` → **丟棄**
```yaml
labels:
  kubernetes.io/hostname: worker-3
  monitoring: "false"
```

