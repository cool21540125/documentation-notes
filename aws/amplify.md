
# Amplify

- [Deploy a Web App on AWS Amplify 101](https://aws.amazon.com/getting-started/guides/deploy-webapp-amplify/?nc1=h_ls)
- [Getting started](https://docs.amplify.aws/start/)
- 可視為用來建 mobile APP && web APP 的 beanstalk
- serverless
- 整合了各種 AWS serverless services

---

```mermaid
flowchart LR

subgraph Frontend
    iOS
    Flutter
    Angular
    misc["其他各種前端框架"]
end
subgraph Backend
    DynamoDB
    AppSync
    Cognito
    S3
end
Amplify <-- connect with frontend libs --> Frontend
Amplify <-- build --> Backend
```
---

Amplify Hosting

```mermaid
flowchart LR

subgraph code["Source Code Repo"]
    Github
    Gitlab
    CodeCommit
end
code --> Frontend -- deploy --> CloudFront
code --> Backend -- deploy --> Amplify
```


# CLI

```bash
### init Amplify project
amplify init


### (尚未知)
amplify add hosting


### 新增 Auth
amplify add auth
    
### 新增 REST/GraphQL API
amplify add api


### Deploy API
amplify push


### Check Amplify's status
amplify status
##    Current Environment: dev
##    
##┌──────────┬───────────────┬───────────┬─────────────────┐
##│ Category │ Resource name │ Operation │ Provider plugin │
##└──────────┴───────────────┴───────────┴─────────────────┘
## 輸出


### 
amplify console api
```
