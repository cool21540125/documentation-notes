# CloudWatch Alarms

- CloudWatch Alarm Pricing -` USD $0.1 / month`
- ComparisonOperator (與 門檻值 的比較運算方式)
  - GreaterThanOrEqualToThreshold
  - GreaterThanThreshold
  - LessThanThreshold
  - LessThanOrEqualToThreshold
  - LessThanLowerOrGreaterThanUpperThreshold
  - LessThanLowerThreshold
  - GreaterThanUpperThreshold
- TreatMissingData (缺失值 的處理)
  - notBreaching : 視為 good && within the threshold
  - breaching : 視為 bad && breaching the threshold
  - ignore : 維持目前的 ALARM state
  - missing : (預設) 若 evaluation range 皆為 missing, 則切換為 INSUFFICIENT_DATA
