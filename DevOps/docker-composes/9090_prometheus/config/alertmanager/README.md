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
        // 扮演了 Ec2InstanceProfileUsedRole 這個 Role 的 Ec2InstanceId (EC2 Instance ID), 可以來 assume this Role
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

而 EC2 Instance Profile 上頭的 Role, 必須要是 `Ec2InstanceProfileUsedRole`
