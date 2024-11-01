# CloudWatch metrics - retention period

- Prometheus 擷取 CloudWatch Metrics 的時候, 這些 metrics 的保存期限:
  - 每個 data points 保存 15 months, 並且適度的做 aggregate:
    - 3 hrs 以內, 可以查看 60 secs 以內的 data points
    - 15 days 以內, 可以查看 1 min 的 data points
    - 63 days 以內, 可以查看 5 min 的 data points
    - 15 months 以內, 可以查看 1 hr 的 data point

# CloudWatch Agent 蒐集 metrics 的 protocol

- StatsD protocol (for Linux & Windows)
  - c for counter
  - g for gauge
  - ms for timer
  - h for histogram
  - s for set
- collectd protocol (for Linux)
  - 僅支援 Linux

# Search expression

```bash
###
SEARCH('Namespace="CWAgent" path="/" MetricName="disk_inodes_used"', 'Average', 300)
SEARCH('Namespace="CWAgent" path="/" MetricName="disk_inodes_total"', 'Average', 300)

# SEARCH( SearchTerm, Statistic, Period)

# SEARCH(' {Namespace, DimensionName1, DimensionName2, ...} SearchTerm', 'Statistic')
# SEARCH(' {AWS/EC2,InstanceId} MetricName="CPUUtilization"', 'Average')

SORT(METRICS(), SUM, DESC, 10)


SEARCH('{CWAgent} path="/" MetricName="disk_inodes_used"', 'Average', 300)


### Correct
SEARCH('Namespace="CWAgent" InstanceId="i-01e2289ef44807f01" MetricName="disk_inodes_used"', 'Average', 300)
SEARCH('Namespace="CWAgent" InstanceId="i-01e2289ef44807f01" path="/" MetricName="disk_inodes_used"', 'Average', 300)
SEARCH('Namespace="CWAgent" InstanceId="i-01e2289ef44807f01" path="/" MetricName="disk_inodes_total"', 'Average', 300)
SEARCH('Namespace="CWAgent" path="/" MetricName="disk_inodes_used"', 'Average', 300)

### Error
SEARCH('{Namespace="CWAgent" path="/"} MetricName="disk_inodes_used"', 'Average', 300)
```
