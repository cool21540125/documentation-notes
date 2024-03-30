
# [Step Functions](https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html)

- 可用視覺化的流程關係, 來查看一系列 Lambda FNs 以及 other AWS Services 之間的流程互動(事件觸發流程)
    - 使用 JSON 撰寫流程
- Step Function 基於 `State machines`, 組成一個 **Workflow**, 而裡頭每個 Step/task 都是一個 **State**
- Step Function 可以做成各種 tasks:
    - Lambda Task         - 只單純與 Lambda Function 串起來
    - Activity Task(HTTP) - 與各種 HTTP Services 串起來, ex: EC2, Mobile Device, On-Premise, ...
    - Service Task        - 與各種 AWS Services 串起來, ex: ECS, DDB, SNS, Batch job, ...
    - Wait Task           - wait TIME 或 until TIME
- 具備了一堆特色: sequence, parallel, conditions, timeouts, error handling, ...
- 除了 Lambda 以外, 也可與像是 EC2, ECS, API Gateway 等服務整合(但較少)
- 用來整合 Lambda 及 一系列 AWS Services
- 可使用流程圖的方式, 並基於 state machines && tasks 來做展示
