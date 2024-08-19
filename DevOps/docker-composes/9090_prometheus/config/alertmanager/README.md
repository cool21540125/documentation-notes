
# sns_configs

此情境是在 EC2 上頭使用 alertmanager, 要讓 alertmanager 可以發送訊息到 SNS Topic

發送到 SNS Topic 所需的 IAM Role

假設此 RoleArn 為 `arn:aws:iam::123456789012:role/Ec2NotificationRole`

其所需的 Policy

```jsonc
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "*"
        }
    ]
}
```

其所配置的 Trust relationships:

```jsonc
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Principal": {
              // Principal type == Role sessions
              // "AWS": "arn:aws:sts::{Account}:assumed-role/{RoleName}/{RoleSessionName}"
                "AWS": "arn:aws:sts::123456789012:assumed-role/Ec2InstanceProfileUsedRole/Ec2InstanceId"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

而 Ec2InstanceProfileUsedRole 無需要有 AssumeRole, PassRole, 一堆讓人摸不著頭緒的權限