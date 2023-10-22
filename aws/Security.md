
# AWS SG, AWS Security Group

- 使用 AWS Console 增加 rules 需要注意的是, 別直接在 old rule 去修改, 而是直接新增新的(再砍舊的)
    - 因為這邊有個小坑 XD
    - (ex: 由 allow 0.0.0.0:80 改成 allow 其他 ALB, 點選下拉清單會找不到 ALB 選項)
- Naming: 無法使用 `sg-` 開頭


# WAF, Web Application Firewall

- [AWS WAF](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)
- 可用於保護底下這些 http(s) endpoints:
    - Amazon CloudFront distribution
    - Amazon API Gateway REST API
    - Application Load Balancer, ALB
    - AWS AppSync GraphQL API
    - Amazon Cognito user pool


# Penetration testing

- 如果使用 AWS 來跑服務, 對於底下的 Services 做滲透測試時, 不須知會 AWS (可自行測爆他)
    - EC2
    - RDS
    - CloudFront
    - Aurora
    - API Gateway
    - Lambda & Lambda Edge Function
    - Lightsail
    - Elastic Beanstalk