
# AWS CodeDeploy

- [What is CodeDeploy?](https://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html)
- CodeDeploy 目標如下:
    - EC2/On-Premise Server (需安裝 *CodeDeploy Agent*)
    - Lambda
    - ECS
- 不依賴於 CloudFormation && Beanstalk
- Deploy 會需要 `appspec.yml` (等同於 `.drone.yml`) (避免與 `buildspec.yml` 搞混)
    - buildspec.yaml 理解 Dockerfile
    - appspec.yaml 理解成 CI/CD pipeline yaml
    - [AppSpec File structure](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure.html)
    - 其中幾個重要階段
        - ValidateService : deploy 以後的 verify 流程
- CodeDeploy Service 會到 *S3* 或 *GitHub* 拿取要 deploy 的 artifacts 來做 deploy
- 權限 (需要事先 create 2 個 Roles):
    - Service Role for CodeDeploy
        - CodeDeploy Agent 去操作其他相關的 AWS Resources 的權限
    - EC2 Instance Profile(Role) if Use EC2
        - 要讓 EC2 能夠 read S3 (ReadOnly 即可)
- CodeDeploy 的 Source Code 來源, 目前(2022Q3) 只能是 S3 或 GitHub
- [IAM instance Profile](./IAM.md#tips)
- [Service Role](./IAM.md#tips), 等同於 *IAM Role*
    - Deployed APP access 相關 AWS Resources 的相關必要權限
- Application Revision
    - APP Code + `appspec.yml` = APP Revision
- Target Revision
    - 要 deploy 到 *Deployment Group* 的 Revision
- CodeDeploy Rollback (回滾)
- 可使用 Auto(借助 *CloudWatch Alarm*) 或 Manual
- rollback 本身是 re-deploy 最近一個正常版本, 而非 restore OLD Version
    - 有點 `git revert` 的感覺~


# CodeDeploy 主要元件

- Application
    - a unique name functions as a container (不知道這在說啥, 可能只是在講部署的服務名稱吧)
- Compute Platform (要部署到哪邊啦~)
     - EC2 / On-Premise Server
    - Lambda
    - ECS
- Deployment Configuration - a set of deployment rules for success/failure (應該是在說, 如何做好 deploy 的流程吧)
    - if EC2/On-Premise, 此 Deployment 裡頭, 最起碼應該有多少個 healthy instances
    - if Lambda/ECS, 此 Deployment 裡頭, traffic 如何 route to NEW Version
- Deployment Group - group of tagged EC2 instances (不是很懂)
    - ex: dev, test, prod
- [Deployment Type](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployments.html)
    - 指如何部署到 *Deployment Group* 的方法
    - CodeDeploy 部署方式有下面 2 種 Deployment Type Options:
        - In-place Deployment
            - 直接在原有的 EC2 / On-Premise 和 ASG *in-place deployment(就地部署)*
            - 比較適用於 服務可中斷 的情境來使用
        - Blue/Green Deployment
            - 會建立新的 EC2 / ASG 進行部署. 等待部署完成後再引導流量到新環境
            - (借助 Load Balancer) EC2 / Lambda, ECS (無 On-Premise)
- CodeDeploy 依照部署目標來分類的話, 分成下列 3 種:
    - [CodeDeploy to Lambda](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-steps-lambda.html)
        - 而部署到 Lambda 也分成 2 種 Type Options:
            - AllAtOnce
            - Canary
    - [CodeDeploy to ECS](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-steps-ecs.html)
        > 2023/02 的現在 <br>
        > Deployments on an Amazon ECS compute platform are not supported in the Asia Pacific (Osaka) Region.
    - [CodeDeploy to EC2/on-premise](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-steps-server.html)
