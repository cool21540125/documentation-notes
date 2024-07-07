

# StatsD protocol (for Linux & Windows)

- c for counter
- g for gauge
- ms for timer
- h for histogram
- s for set



# collectd protocol (for Linux)

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