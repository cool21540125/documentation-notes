# ECS Events

- Events 到 EventBridge 為 近乎即時(near real time)
  - 發送到 EventBridge 的 Events, 基本上 relatively ordered, 因此可藉此來判斷事件之間的關聯
    - 然而這些 Events 傳送到 listeners 的順序則不保證順序 (因此需要藉由 event 的 detail.version 來確定順序)
  - 發送到 EventBridge 的 Events, 因為是 async, 所以有可能會重複
    - ECS Event 裡頭也有紀錄 Event Version, 可用來追蹤哪些 Events 是屬於重複的部分
      - `Container state change` 及 `Task state change` 包含了 2 種 Version:
        - main body event : 基本上都會是 "0"
        - detail version : 隨著 Resource 版本而異動, 可用此來區分是否為重複性的 Events (藉此排除 retry 的部分)
      - `Service action event` 則僅有 main body event
- ECS 會追蹤 tasks / services 的 state, 若 state 異動, 則觸發 EventBridge. 而這些 Event-Type(`detail-type`) 可以分為:
  - ECS container instance state change event
  - ECS task state change event
    - `"detail-type": "ECS Task State Change"` 有底下的形成原因:
      - 調用 : StartTask / RunTask / StopTask API
      - ECS Scheduler 啟動 / 關閉 task
      - ECS container agent 調用 : SubmitTaskStateChange API
      - 調用 : DeregisterContainerInstance API (進行 ECS deregistration 排水)
      - Task 裡頭的 container instance 被 stopped 或 terminated
      - Task 裡頭的 container
  - ECS service deployment state change event()
    - `"detail-type": ["ECS Deployment State Change"]` 有底下的 events:
      - INFO
        - SERVICE_DEPLOYMENT_IN_PROGRESS
        - SERVICE_DEPLOYMENT_COMPLETED
      - ERROR
        - SERVICE_DEPLOYMENT_FAILED
  - ECS service action event
    - `"detail-type": ["ECS Service Action"]` 有底下的 events:
      - INFO
        - SERVICE_STEADY_STATE
        - TASKSET_STEADY_STATE
        - CAPACITY_PROVIDER_STEADY_STATE
        - SERVICE_DESIRED_COUNT_UPDATED
        - TASKS_STOPPED
        - SERVICE_DEPLOYMENT_IN_PROGRESS
        - SERVICE_DEPLOYMENT_COMPLETED
      - WARN
        - SERVICE_TASK_START_IMPAIRED
        - SERVICE_DISCOVERY_INSTANCE_UNHEALTHY
        - VPC_LATTICE_TARGET_UNHEALTHY
      - ERROR
        - SERVICE_DAEMON_PLACEMENT_CONSTRAINT_VIOLATED
        - ECS_OPERATION_THROTTLED
        - SERVICE_DISCOVERY_OPERATION_THROTTLED
        - SERVICE_TASK_PLACEMENT_FAILURE
        - SERVICE_TASK_CONFIGURATION_FAILURE
        - SERVICE_HEALTH_UNKNOWN
        - SERVICE_DEPLOYMENT_FAILED
  - (這些 Event Type 將來可能會增加), 因此 Your Code 需要保留捕捉未處理的事件
- ECS 的 Health Check
  - 區分為底下 2 種:
    - Container health check
      - 檢測方式定義在 Task Definition, 由 Docker container 內部自己檢測
      - ECS 並不會檢測那些 僅定義在 Docker Image 的 Health check, 但卻沒定義在 Task definition 的 Container
      - 由 Task Definition 所定義的 Container 自行做的 Health check, 包含了下列參數:
        - Command / Interval / Timeout / Retries / Start period
    - ALB Target group health check

### task state change event

- 觸發原因
  - `StartTask` / `RunTask` / `StopTask` API
  - `SubmitTaskStateChange` API

# ECS metrics

- CPUReservation
- CPUUtilization
- MemoryReservation
- MemoryUtilization
- EBSFilesystemUtilization
- GPUReservation
- ActiveConnectionCount
- NewConnectionCount
- ProcessedBytes
- RequestCount
- GrpcRequestCount
- HTTPCode_Target_2XX_Count
- HTTPCode_Target_3XX_Count
- HTTPCode_Target_4XX_Count
- HTTPCode_Target_5XX_Count
- RequestCountPerTarget
- TargetProcessedBytes
- TargetResponseTime
- ClientTLSNegotiationErrorCount
- TargetTLSNegotiationErrorCount

# ECS Service event messages

https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-event-messages-list.html

- service `SVC` has reached a steady state.
- service `SVC` was unable to place a task because no container instance met all of its requirements.
- service `SVC` was unable to place a task because no container instance met all of its requirements. The closest matching container-instance container-instance-id has insufficient CPU units available.
- service `SVC` was unable to place a task because no container instance met all of its requirements. The closest matching container-instance container-instance-id encountered error "AGENT".
- service `SVC` (instance instance-id) is unhealthy in (elb elb-name) due to (reason Instance has failed at least the UnhealthyThreshold number of health checks consecutively.)
- service `SVC` is unable to consistently start tasks successfully.
  - ECS Service 裡頭包含了 task, 歷經重複嘗試後, 依舊無法正常啟動
  - 因而後續 service scheduler 開始嘗試 **漸進式增加 retry 的時間**
  - 需要自行人工排解
- service `SVC` operations are being throttled. Will try again later.
- service `SVC` was unable to stop or start tasks during a deployment because of the service deployment configuration. Update the minimumHealthyPercent or maximumPercent value and try again.
- service `SVC` was unable to place a task. Reason: You've reached the limit on the number of tasks you can run concurrently
- service `SVC` was unable to place a task. Reason: Internal error.
- service `SVC` was unable to place a task. Reason: The requested CPU configuration is above your limit.
- service `SVC` was unable to place a task. Reason: The requested MEMORY configuration is above your limit.
- service `SVC` was unable to place a task. Reason: You’ve reached the limit on the number of vCPUs you can run concurrently
- service `SVC` was unable to reach steady state because task set `TASK_ID` was unable to scale in. Reason: The number of protected tasks are more than the desired count of tasks.
- service `SVC` was unable to reach steady state. Reason: No Container Instances were found in your capacity provider.
- service `SVC` was unable to place a task. Reason: Capacity is unavailable at this time. Please try again later or in a different availability zone.
- service `SVC` deployment failed: tasks failed to start.
- service `SVC` Timed out waiting for Amazon ECS Agent to start. Please check logs at /var/log/ecs/ecs-agent.log".
- service `SVC` task set `TASK_ID` is not healthy in target-group `TARGET_GROUP_ARN` due to TARGET GROUP IS NOT FOUND.
- service `SVC` task set `TASK_ID` is not healthy in target-group `TARGET_GROUP_ARN` due to TARGET IS NOT FOUND.
