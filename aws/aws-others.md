# 未分類雜訊


AWS 租機器的方式
- 整台給 $$$
- 不超賣 $$
- 會超賣 $
    - Ondemand
    - Reserved
    - Spot (競拍), 將來可能有人出價較高, 會出現 CPU steal time 的情形
        - note: 實體主機, 多人共享資源, 但主機上就算沒幹嘛, CPU 資源可能被其他人拿去用, 形成 steal time


# AWS Distro for OpenTelemetry

- distribution & open-source
- 用來提供給 Your App 一系列的 APIs, libs, agents, collector services
    - 蒐集 Apps 的 distributed traces and metrics
        - 可搜集 EC2, ECS, EKS, Lambda, On-Premise
    - 蒐集 AWS resources and services 的 metadata
    - 有點類似於 X-Ray(純 AWS 的產品)
- 蒐集完的資料可以發送到 X-Ray / CloudWatch / Prometheus / ...
