
# ECS metrics

CPUReservation
CPUUtilization
MemoryReservation
MemoryUtilization
EBSFilesystemUtilization
GPUReservation
ActiveConnectionCount
NewConnectionCount
ProcessedBytes
RequestCount
GrpcRequestCount
HTTPCode_Target_2XX_Count
HTTPCode_Target_3XX_Count
HTTPCode_Target_4XX_Count
HTTPCode_Target_5XX_Count
RequestCountPerTarget
TargetProcessedBytes
TargetResponseTime
ClientTLSNegotiationErrorCount
TargetTLSNegotiationErrorCount


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
    - 
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