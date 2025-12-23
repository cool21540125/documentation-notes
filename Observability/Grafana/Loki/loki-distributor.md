# Loki distributor


```yaml
limits_config:
  max_line_size: 256KB
  max_line_size_truncate: false

distributor:
  ingest_limits_enabled: false
  max_line_size_truncate: false
  otlp_config:
    default_resource_attributes_as_index_labels:
      - service.name
      - service.namespace
      - service.instance.id
      - 還有其他一大堆
```